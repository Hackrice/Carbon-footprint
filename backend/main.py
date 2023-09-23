from fastapi import FastAPI
from pydantic import BaseModel
from langChat import LangChainChat

app = FastAPI()

lc = LangChainChat("your-api-key")

class CarbonEmissionRequest(BaseModel):
    city: str
    state: str

class PersonalDataRequest(BaseModel):
    vehicle_type: str
    commute_miles: str
    commute_time: str
    state: str
    city: str

class OptimizationRequest(BaseModel):
    personal_data_suggestions: str

@app.post("/carbon_emission_suggestions")
def get_carbon_emission_suggestions(request: CarbonEmissionRequest):
    return lc.get_carbon_emission_suggestions(request.city, request.state)

@app.post("/personal_data_suggestions")
def get_personal_data_suggestions(request: PersonalDataRequest):
    return lc.get_personal_data_suggestions(request.vehicle_type, request.commute_miles, request.commute_time, request.state, request.city)

@app.post("/optimizations")
def get_optimizations(request: OptimizationRequest):
    return lc.get_optimizations(request.personal_data_suggestions)

@app.post("/sequential_chain")
def get_sequential_chain(request: PersonalDataRequest):
    return lc.get_sequential_chain(request.vehicle_type, request.commute_miles, request.commute_time, request.state, request.city)