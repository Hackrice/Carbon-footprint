from fastapi import FastAPI
from langChat import LangChainChat
import sqlConnector
import classTypes
# from OptimizationRequest import classTypes
# from CarbonEmissionRequest import classTypes

app = FastAPI()

lc = LangChainChat("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")

sqlAPI = sqlConnector.sqlConnector()
CarbonEmissionRequest = classTypes.CarbonEmissionRequest()
PersonalData = classTypes.PersonalData()
OptimizationRequest = classTypes.OptimizationRequest()

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

@app.post("/formdata")
async def create_form_data(PostData: PersonalData):
    return sqlAPI.insert_data(PostData)
 