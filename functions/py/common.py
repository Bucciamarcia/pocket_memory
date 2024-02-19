from google.cloud import firestore
from firebase_functions import https_fn
import functions_framework

import logging

# Initialize stdout and cloud logger
logger = logging.getLogger("cloudLogger")


class Firestore_Db:
    """
    This class is used to interact with the Firestore database.
    """
    def __init__(self):
        self.db = firestore.Client()
        self.collection = self.db.collection('users')
    
    def check_anon(self, user:str) -> bool:
        """
        Check if the user is anonymous.
        """
        try:
            doc = self.db.collection("users").document(user).get()
            doc_data = doc.to_dict()
            return doc_data["isAnonymous"]
        except Exception as e:
            raise e

    def remove_user(self, user:str) -> tuple[any, int]:
        """
        Remove the user from the database.
        First remove the user document and then remove the memories using the delete_memories method.
        """
        try:
            self.collection.document(user).delete()
            Firestore_Db.delete_memories(self, user=user, batch_size=50)
            return "OK", 200
        except Exception as e:
            raise e
        
    def delete_memories(self, user, batch_size):
        """
        Deletes the memories of the user.
        """

        coll_ref = self.collection.document(user).collection("memories")
        docs = coll_ref.list_documents(page_size=batch_size)
        deleted = 0

        for doc in docs:
            logging.info(f"Deleting doc {doc.id} => {doc.get().to_dict()}")
            doc.delete()
            deleted = deleted + 1

        if deleted >= batch_size:
            return Firestore_Db.delete_memories(coll_ref, batch_size)
    
    def delete_single_memory(self, user:str, memory:str) -> None:
        """
        Delete a single memory from the user.
        """
        try:
            self.collection.document(user).collection("memories").document(memory).delete()
        except Exception as e:
            raise e
    
    def get_all_users(self) -> list[str]:
        """
        Get all users from the database.
        """
        users = self.collection.list_documents(50)
        usrid_list = [user.id for user in users]
        logger.info(f"Users: {usrid_list}")
        return usrid_list
    
    def get_all_temporary_memories(self, user:str) -> list[dict[str, any]]:
        """
        Get all temporary memories from the user. It will only return the isTemporary and expirationDate fields.
        """
        try:
            collection = self.collection.document(user).collection("memories")
            query_ref = collection.where(filter=firestore.FieldFilter("isTemporary", "==", True))
            memories = query_ref.select(["isTemporary", "expirationDate"]).stream()
        except Exception as e:
            logger.error(f"Error getting memories: {e}")
            raise e
        memories_list = []
        for memory in memories:
            memory_dict = memory.to_dict()
            memory_dict["id"] = memory.id
            memories_list.append(memory_dict)
        return memories_list
    
    def get_memories_stream(self, user:str) -> list:
        return self.db.collection("users").document(user).collection("memories").stream()
    
    def add_memory(self, user:str, memory:dict) -> None:
        """
        Add a memory to the user.
        """
        try:
            self.collection.document(user).collection("memories").add(memory)
        except Exception as e:
            raise e

def cors_headers_preflight(req: https_fn.Request) -> https_fn.Response:
    """
    Add CORS headers for preflight requests.
    """
    cors_headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Max-Age': '3600',
    }
    return https_fn.Response('', headers=cors_headers)

def cors_headers(response: https_fn.Response) -> https_fn.Response:
    """
    Add CORS headers to the response.
    """
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    return response