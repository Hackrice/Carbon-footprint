from pydantic import BaseModel

class CarbonEmissionRequest(BaseModel):
    city: str
    state: str

class PersonalData(BaseModel):
    vehicle_type: str
    commute_miles: str
    commute_time: str
    electircal_usage: str
    state: str
    city: str

class OptimizationRequest(BaseModel):
    personal_data_suggestions: str
