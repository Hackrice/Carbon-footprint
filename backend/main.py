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
    electrical_usage: int

class OptimizationRequest(BaseModel):
    personal_data_suggestions: str

app = FastAPI()

lc = LangChainChat("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")
sqlAPI = sqlConnector.sqlConnector()

@app.post("/carbon_emission_suggestions")
def get_carbon_emission_suggestions(request: CarbonEmissionRequest):
    return lc.get_carbon_emission_suggestions(request.city, request.state)

@app.post("/personal_data_suggestions")
def get_personal_data_suggestions(request: PersonalData):
    return lc.get_personal_data_suggestions(request.vehicle_type, request.commute_miles, request.commute_time, request.state, request.city)

@app.post("/optimizations")
def get_optimizations(request: OptimizationRequest):
    return lc.get_optimizations(request.personal_data_suggestions)

@app.post("/sequential_chain")
def get_sequential_chain(request: PersonalData):
    return lc.get_sequential_chain(request.vehicle_type, request.commute_miles, request.commute_time, request.state, request.city)

@app.post("/selfprompt")
def get_self_prompt(prompt):
    return lc.get_self_prompt(prompt)

@app.post("/formdata")
async def create_form_data(request: PersonalData):
    return sqlAPI.insert_data(request.emailId,request.state,request.city,request.vehicle_type,request.commute_miles,request.commute_time, request.electrical_usage)
 

@app.post("/getCityYearEmissions")
def getCityYearEmissions(city, year):
    return sqlAPI.getCityYearEmissions(state, year)

@app.post('/getCityMonthYearPercentile')
def getCityMonthYearPercentile(month, year):
    return sqlAPI.getCityMonthYearPercentile(month, year)
