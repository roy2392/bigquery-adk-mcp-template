from google.adk.agents.llm_agent import Agent
from google.adk.tools.bigquery import BigQueryToolset

# Create BigQuery toolset with default configuration
# This will use application default credentials and environment variables
bigquery_toolset = BigQueryToolset()

root_agent = Agent(
   model="gemini-2.0-flash",
   name="bigquery_agent",
   description=(
       "Agent that answers questions about BigQuery data by executing SQL queries"
   ),
   instruction=""" You are a data analysis agent with access to several BigQuery tools. Make use of those tools to answer the user's questions.
   """,
   tools=[bigquery_toolset]
)
