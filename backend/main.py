from fastapi import FastAPI
from langChat import LangChainChat
import sqlConnector
from pydantic import BaseModel

class CarbonEmissionRequest(BaseModel):
    city: str
    state: str

class PersonalData(BaseModel):
    emailId: str
    state: str
    city: str
    vehicle_type: str
    commute_miles: int
    commute_time: int
    electircal_usage: int

class OptimizationRequest(BaseModel):
    personal_data_suggestions: str

app = FastAPI()

lc = LangChainChat("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")
sqlAPI = sqlConnector.sqlConnector()

@app.get("/carbon_emission_suggestions")
def get_carbon_emission_suggestions(request: CarbonEmissionRequest):
    return lc.get_carbon_emission_suggestions(request.city, request.state)

@app.get("/personal_data_suggestions")
def get_personal_data_suggestions(request: PersonalData):
    return lc.get_personal_data_suggestions(request.vehicle_type, request.commute_miles, request.commute_time, request.state, request.city)

@app.get("/optimizations")
def get_optimizations(request: OptimizationRequest):
    return lc.get_optimizations(request.personal_data_suggestions)

@app.get("/sequential_chain")
def get_sequential_chain(request: PersonalData):
    return lc.get_sequential_chain(request.vehicle_type, request.commute_miles, request.commute_time, request.state, request.city)

@app.post("/formdata")
async def create_form_data(PostData: PersonalData):
    return sqlAPI.insert_data(PostData)
 