# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn, firestore_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json
import logging
import google.cloud.logging
from langchain_community.vectorstores.faiss import FAISS
from langchain_openai import OpenAIEmbeddings
from openai import OpenAI, OpenAIError
import os
from py import retrieve_memories
from py.common import Firestore_Db


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
def get_embeddings(req: https_fn.Request) -> https_fn.Response:
    openai_apikey = os.environ.get('OPENAI_APIKEY', '')
    client = OpenAI(api_key=openai_apikey)
    logger.debug(f"Request: {req.json}")
    data = req.json["data"]
    memory = data['memoryText']
    
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

    response_data = json.dumps({"data": {"embeddings": embeddings}})
    response = https_fn.Response(response_data, status=200, headers={"Content-Type": "application/json"})
    return response

@https_fn.on_request()
def retrieve_memory(req: https_fn.Request) -> https_fn.Response:
    logger.debug(f"Request: {req.json}")
    data = req.json["data"]
    query = data['memoryText']
    user = data['user']
    logger.info(f"Retrieving memory: {query} | For user: {user}")
    
    # Get all memories from firestore
    db = firestore.client()
    memories = db.collection("users").document(user).collection("memories").stream()

    # Turn the memories into a list of dictionaries
    memories_list = []
    for memory in memories:
        memory_dict = memory.to_dict()
        memories_list.append(memory_dict)
    
    # Print the first memory list
    logger.debug(f"FIRST MEMORY: {memories_list[0]}")
    
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

@https_fn.on_request()
def autoremove_guests(req: https_fn.Request) -> https_fn.Response:
    logger.debug(f"Request: {req.json}")
    data = req.json["data"]
    user = data['user']

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
    return response