from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
import threading
import time
import watchdog
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from gpt_index import SimpleDirectoryReader, GPTListIndex, GPTSimpleVectorIndex, LLMPredictor, PromptHelper
from langchain.chat_models import ChatOpenAI
import os

os.environ["OPENAI_API_KEY"] = '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'

app = FastAPI()

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class MyHandler(FileSystemEventHandler):
    def on_modified(self, event):
        print(f'Event type: {event.event_type}  path : {event.src_path}')
        if event.is_directory:
            print("The directory has been modified.")
            # Reconstruct the index
            index = construct_index("docs")
        else:
            print("The file has been modified.")
            # Reconstruct the index
            index = construct_index("docs")
            
class Item(BaseModel):
    text: str

def construct_index(directory_path):
    max_input_size = 4096
    num_outputs = 512
    max_chunk_overlap = 20
    chunk_size_limit = 600

    prompt_helper = PromptHelper(max_input_size, num_outputs, max_chunk_overlap, chunk_size_limit=chunk_size_limit)
    llm_predictor = LLMPredictor(llm=ChatOpenAI(temperature=0.7, model_name="gpt-3.5-turbo", max_tokens=num_outputs))

    documents = SimpleDirectoryReader(directory_path).load_data()

    index = GPTSimpleVectorIndex(documents, llm_predictor=llm_predictor, prompt_helper=prompt_helper)

    index.save_to_disk('index.json')

    return index

def start_observer():
    event_handler = MyHandler()
    observer = Observer()
    observer.schedule(event_handler, path='docs', recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

@app.post("/chatbot/")
async def chatbot(item: Item):
    index = GPTSimpleVectorIndex.load_from_disk('index.json')
    response = index.query(item.text, response_mode="compact")
    return {"response": response.response}

index = construct_index("docs")

threading.Thread(target=start_observer).start()