import os
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain, SequentialChain

class LangChainChat:
    def __init__(self, api_key):
        os.environ['OPENAI_API_KEY'] = "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"
        self.llm = OpenAI(temperature=0.9)

    def get_carbon_emission_suggestions(self, city, state):
        prompt_template_carbon = PromptTemplate(
            input_variables=['city', 'state'],
            template="I want to analysis the carbon emission given in the last table from the {city}, {state} in the US. Suggest some ideas on how to reduce carbon emissions."
        )
        p = prompt_template_carbon.format(city=city, state=state)
        return self.llm.predict(p)

    def get_personal_data_suggestions(self, vehicle_type, commute_miles, commute_time, state, city):
        prompt_template_personal_data = PromptTemplate(
            input_variables=['vehicle_type', 'commute_miles', 'commute_time', 'state', 'city'],
            template="""An individual, who lives in {city}, {state}, drives a vehicle type of {vehicle_type}, and drives on average of {commute_miles} miles per day with a average commute time of {commute_time} minutes per day. Provide 5 suggestions in a few words on how to reduce carbon emissions, in JSON structure."""
        )
        p = prompt_template_personal_data.format(vehicle_type=vehicle_type, commute_miles=commute_miles, commute_time=commute_time, state=state, city=city)
        return self.llm.predict(p)

    def get_optimizations(self, personal_data_suggestions):
        prompt_further_personal_optimization = PromptTemplate(
            input_variables=['personal_data_suggestions'],
            template="Given these recommendations to reduce carbon footprint: {personal_data_suggestions}, estimate the optimizations of how much person can save with numbers.Provide how much carbon footprint it will reduce numerically."
        )
        p = prompt_further_personal_optimization.format(personal_data_suggestions=personal_data_suggestions)
        return self.llm.predict(p)

    def get_sequential_chain(self, vehicle_type, commute_miles, commute_time, state, city):

        prompt_template_personal_data = PromptTemplate(
            input_variables=['vehicle_type', 'commute_miles', 'commute_time', 'state', 'city'],
            template="""An individual, who lives in {city}, {state}, drives a vehicle type of {vehicle_type}, and drives on average of {commute_miles} miles per day with a average commute time of {commute_time} minutes per day. Provide 5 suggestions in a few words on how to reduce carbon emissions, in JSON structure."""
        )

        prompt_further_personal_optimization = PromptTemplate(
            input_variables=['personal_data_suggestions'],
            template="Given these recommendations to reduce carbon footprint: {personal_data_suggestions}, estimate the optimizations of how much person can save with numbers.Provide how much carbon footprint it will reduce numerically."
        )


        personal_chain = LLMChain(llm=self.llm, prompt=prompt_template_personal_data, output_key="personal_data_suggestions")
        optimization_chain = LLMChain(llm=self.llm, prompt=prompt_further_personal_optimization, output_key="optimizations")
        chain = SequentialChain(
            chains=[personal_chain, optimization_chain],
            input_variables=['vehicle_type', 'commute_miles', 'commute_time', 'state', 'city'],
            output_variables=['personal_data_suggestions', "optimizations"]
        )
        return chain({'city': city, 'state': state, "vehicle_type": vehicle_type, "commute_miles": commute_miles, "commute_time": commute_time})



lc = LangChainChat("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")
print(lc.get_carbon_emission_suggestions("Houston", "Texas"))
print(lc.get_personal_data_suggestions("sedan", "30", "50", "Texas", "Houston"))
print(lc.get_optimizations("Carpool, Use public transportation, Drive a hybrid vehicle, Reduce driving speed, Reduce vehicle idling"))
print(lc.get_sequential_chain("sedan", "30", "50", "Texas", "Houston"))
