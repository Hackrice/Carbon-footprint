from fastapi import FastAPI
from langChat import LangChainChat
from CarbonEmissionRequest import CarbonEmissionRequest
from OptimizationRequest import OptimizationRequest
from CarbonEmissionRequest import CarbonEmissionRequest

app = FastAPI()

lc = LangChainChat("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")

sqlAPI = sqlConnector()
CarbonEmissionRequest = CarbonEmissionRequest()
PersonalData = PersonalData()
OptimizationRequest = OptimizationRequest()

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
async def create_form_data(PersonalData: PostData):
    return sqlAPI.insert_data(PostData)
 