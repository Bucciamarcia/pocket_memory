# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json
import functions_framework
import logging
import datetime
import google.cloud.logging
from langchain_community.vectorstores.faiss import FAISS
from langchain_openai import OpenAIEmbeddings
from openai import OpenAI, OpenAIError
import os
from py import retrieve_memories
from py.common import Firestore_Db
from cloudevents.http.event import CloudEvent
import firebase_admin



initialize_app()

# Initialize stdout and cloud logger
client = google.cloud.logging.Client()
logger = client.logger("my-log-name")
handler = google.cloud.logging.handlers.CloudLoggingHandler(client)
logger = logging.getLogger("cloudLogger")
logger.setLevel(logging.INFO)
logger.addHandler(handler)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# Add console logger
consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(formatter)
logger.addHandler(consoleHandler)


@https_fn.on_request()
def add_memory(req: https_fn.Request) -> https_fn.Response:
    openai_apikey = os.environ.get('OPENAI_APIKEY', '')
    client = OpenAI(api_key=openai_apikey)
    logger.debug(f"Request: {req.json}")
    data = req.json["data"]
    memory = data['memoryText']
    temporary = data['isTemporary']
    expiration_days_to_add = data['expiration']
    user = data['user']
    
    logger.info(f"Getting embeddings for memory: {memory}")
    try:
        response = client.embeddings.create(
            input=memory,
            model="text-embedding-3-large",
            dimensions=512,
        )

        logger.info(f"Embeddings obtained!")
    except OpenAIError as e:
        logger.error(f"Error getting embeddings: {e}")
        raise e

    embeddings = response.data[0].embedding

    logger.debug(embeddings)
    logger.debug(f"length of embeddings: {len(embeddings)}")

    if expiration_days_to_add:
        expiration_date = datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(days=expiration_days_to_add)
    
    expiration = expiration_date if expiration_days_to_add else None

    dict_to_add = {
        "memoryText": memory,
        "embeddings": embeddings,
        "isTemporary": temporary,
        "timestamp": datetime.datetime.now(tz=datetime.timezone.utc),
        "expirationDate": expiration
    }
    logger.info(f"Adding memory to Firestore")
    logger.debug(f"Memory to add: {dict_to_add}")
    try:
        Firestore_Db().add_memory(user=user, memory=dict_to_add)
    except Exception as e:
        logger.error(f"Error adding memory: {e}")
        raise e
    logger.info(f"Memory added to Firestore - SUCCESS!")
    response_data = json.dumps({"data": {"result": "OK"}})
    response = https_fn.Response(response_data, status=200, headers={"Content-Type": "application/json"})
    return response

@https_fn.on_request()
def retrieve_memory(req: https_fn.Request) -> https_fn.Response:
    logger.debug(f"Request: {req.json}")
    data = req.json["data"]
    query = data['memoryText']
    user = data['user']
    logger.info(f"Retrieving memory: {query} | For user: {user}")
    
    memories = Firestore_Db().get_memories_stream(user=user)

    # Turn the memories into a list of dictionaries
    memories_list = []
    for memory in memories:
        memory_dict = memory.to_dict()
        memories_list.append(memory_dict)
    
    # Print the first memory list
    logger.debug(f"Memories: {memories_list}")
    
    # Create the faiss block for langchain
    memory_embeddings = [memory['embeddings'] for memory in memories_list]
    memory_texts = [memory['memoryText'] for memory in memories_list]
    text_embedding_pairs = zip(memory_texts, memory_embeddings)
    embeddings = OpenAIEmbeddings(model="text-embedding-3-large", dimensions=512, api_key=os.environ.get('OPENAI_APIKEY', ''))
    fdb = FAISS.from_embeddings(text_embedding_pairs, embeddings)

    docs = fdb.similarity_search(query, 5)

    results = []
    for doc in docs:
        results.append(doc.page_content)
    
    logger.info(f"Results: {results}")

    answer = retrieve_memories.retrieve_answer(query, results)

    logger.info(f"Answer: {answer}")
    

    # Return a 200 response for now
    response_data = json.dumps({"data": {"answer": answer}})
    response = https_fn.Response(response_data, status=200, headers={"Content-Type": "application/json"})
    return response

@functions_framework.cloud_event
def autoremove_guests(cloud_event: CloudEvent) -> None:

    users = Firestore_Db().get_all_users()
    for user in users:
        logger.info(f"Checking if user is anonymous: {user}")
        is_anon = Firestore_Db().check_anon(user=user)
        logger.info(f"Is user anonymous: {is_anon}")

        if is_anon:
            logger.info(f"Removing anonymous user: {user}")
            response = Firestore_Db().remove_user(user=user)
            logger.info(f"User removed: {response}")
        else:
            logger.info(f"User is not anonymous, will not remove: {user}")
        

    response_data = json.dumps({"data": {"result": is_anon}})
    response = https_fn.Response(response_data, status=200, headers={"Content-Type": "application/json"})
    return None

@functions_framework.cloud_event
def remove_temp_memories(cloud_event: CloudEvent) -> None:
    users = Firestore_Db().get_all_users()
    for user in users:
        logger.info(f"Removing temporary memories for user: {user}")
        memories = Firestore_Db().get_all_temporary_memories(user=user)
        if not memories:
            logger.info(f"No temporary memories found for user: {user}")
            continue
        for memory in memories:
            logger.info(f"MEMORY: {memory}")
            expiration_date = memory['expirationDate']
            if expiration_date < datetime.datetime.now(tz=datetime.timezone.utc):
                logger.info(f"Removing temporary memory: {memory}")
                Firestore_Db().delete_single_memory(user=user, memory=memory["id"])
            else:
                logger.info(f"Temporary memory is not expired: {memory}")
        logger.info(f"Temporary memories removed for user: {user}")
