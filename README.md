# bs-ruby-koans

To run Dice problem Use<br>
**ruby greedy_scoring.rb** 

TO run mars rover problem<br>
Use<br>
**cat mar_rover_input.txt | ruby mars_rovers_problem.rb**


Key Server 
A Simple key server application that allows to generate new unique keys,
delete, refresh and get free keys from a pool of keys

API Endpoints 

GET "/"
"ok"

GET "/api/key/generate"
Response if 200
{
key: "0b9fff61-dec7-48d7-a9a6-291b18cf200c"
}
otherwise 400


GET '/api/key/:id/release'
Response if 200
true
otherwise 400

GET '/api/key/:id/delete'
Response if 200
true
otherwise 400

GET '/api/key/:id/refresh'
Response if 200
true
otherwise 400



