from openai import OpenAI, OpenAIError
import os
import logging

# Initialize stdout and cloud logger
logger = logging.getLogger("cloudLogger")


def retrieve_answer(query: str, memories:list[str]) -> str:
    """
    From a query and list of memories, call GPT to generate an answer.
    """
    openai_apikey = os.environ.get('OPENAI_APIKEY', '')
    client = OpenAI(api_key=openai_apikey)
    sysmsg = """You are an AI assistant. Your job is to answer the user based on the notes you are given.

If you don't find the answer, say that the answer is not in the notes.

NOTES:

{memories}"""

    # Format the memories, one per line, with a number
    memories_formatted = "\n".join([f"{i+1}. {mem}" for i, mem in enumerate(memories)])

    messages = [
        {
            "role": "system",
            "content": sysmsg.format(memories=memories_formatted)
        },
        {
            "role": "user",
            "content": query
        }
    ]

    logger.info(f"MESSAGES:\n\n{messages}")

    response = client.chat.completions.create(
        model=os.getenv("MODEL_NAME"),
        messages=messages,
        temperature=0
    )

    return response.choices[0].message.content