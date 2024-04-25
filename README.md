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


1. Create an Event:

curl -X POST http://localhost:4000/api/events \
-H "Content-Type: application/json" \
-d '{ "user_id": "user1", "event_name": "subscription_activated", "attributes": { "plan": "pro", "billing_interval": "year" } }'

Example Response:

{"data":{"attributes":{"billing_interval":"year","plan":"pro"},"id":"9e9b6fef-d473-4946-b327-c96498f4572c","event_name":"subscription_activated","event_time":"2024-04-25T19:15:46Z","user_id":"user1"}}

2. Get User Analytics

curl -X GET 'http://localhost:4000/api/user_analytics?event_name=login'

Example Response:

{"data":[{"user_id":"user4","last_event_at":"2024-04-25T10:14:45Z","event_count":1},{"user_id":"user3","last_event_at":"2024-04-25T10:14:34Z","event_count":1},{"user_id":"user2","last_event_at":"2024-04-25T10:14:18Z","event_count":1},{"user_id":"user1","last_event_at":"2024-04-25T10:14:04Z","event_count":2}]}

3. Get Event Analytics with events grouped by date and shows total even count and unique user count within that date range

curl -X GET 'http://localhost:4000/api/event_analytics?from=2024-04-24&to=2024-04-25&event_name=login'

Example Response

{"data":[{"count":1,"date":"2024-04-24","unique_count":1},{"count":14,"date":"2024-04-25","unique_count":4}]}

To run tests:
mix test
