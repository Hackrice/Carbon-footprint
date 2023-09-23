from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/data/{state}")
def read_state(state: str):
    return {"state": state}

@app.put("/form/{item_id}")
def update_form(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}

@app.get("/footprint/personal/{user_id}")
def read_personal(user_id: int):
    return {"user_id": user_id}

@app.get("/footprint/local/{user_id}")
def read_local(user_id: int):
    return {"user_id": user_id}