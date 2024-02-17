# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn, firestore_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json
import logging
import google.cloud.logging

from openai import OpenAI, OpenAIError
import os


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

    # Add memory to firestore


    response_data = json.dumps({"data": {"embeddings": embeddings}})
    response = https_fn.Response(response_data, status=200, headers={"Content-Type": "application/json"})
    return response