ProductAnalytics app is a simple Elixir & Phoenix application that provides APIs for handling events on a product by user and the data can be used for product analytics.

Getting Started:
To run this application locally, follow these steps:

Prerequisites:
Elixir (>= 1.10)
Erlang (>= 22)
PostgreSQL

Clone the repository:
git clone https://github.com/karthikshivas/product_analytics.git

Navigate to the project directory:
cd product_analytics

Install dependencies:
mix deps.get

Set up the database:
mix ecto.create

Start the Phoenix server:
mix phx.server

Interact with the API using tools like curl or Postman:

Events accepted: "login", "logout", "subscription_activated", "unsubscribed"

Create an Event:
curl -X POST http://localhost:4000/api/events \
 -H "Content-Type: application/json" \
 -d '{
"event": {
"user_id": "user1",
"event_name": "subscription_activated",
"attributes": {
"plan": "pro",
"billing_interval": "year"
}
}
}'

Example response:
{
"id": 1,
"user_id": "user1",
"event_name": "subscription_activated",
"attributes": {
"plan": "pro",
"billing_interval": "year"
},
"inserted_at": "2024-04-27T12:34:56Z",
"updated_at": "2024-04-27T12:34:56Z"
}

To run tests:
mix test
