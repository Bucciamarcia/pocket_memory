from google.cloud import firestore
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
        """
        try:
            self.collection.document(user).delete()
            Firestore_Db.delete_memories(self, user=user, batch_size=50)
            return "OK", 200
        except Exception as e:
            raise e
        
    def delete_memories(self, user, batch_size):

        coll_ref = self.collection.document(user).collection("memories")
        docs = coll_ref.list_documents(page_size=batch_size)
        deleted = 0

        for doc in docs:
            logging.info(f"Deleting doc {doc.id} => {doc.get().to_dict()}")
            doc.delete()
            deleted = deleted + 1

        if deleted >= batch_size:
            return Firestore_Db.delete_memories(coll_ref, batch_size)