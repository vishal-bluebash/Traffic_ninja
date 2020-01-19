# README

​This application is accept all type of Store​, ​Validate​ traffic & Forward to https://www.mocky.io/v2/5185415ba171ea3a00704eed/

### Here are the setup instructions from repository:

* Dependencies
   `Ruby version - 2.4.4`
   `Latest Postgres`

* Clone application locally
   `git clone repo_url`

* Install gems
   `bundle install`

* Configure database.yml
   `mv database.yml.example database.yml`
   `rake db:create`
   `rake db:migrate`

* Start application

	`rails s`

After all these steps your application is up and running

Use postman for GET, POST requests or for GET request you can use browser

`http://localhost:3000//pings/handle?proxy=true&type=static&app_id=1 2376` 
`http://localhost:3000//pings/handle?type=static&app_id=1 2376`
`http://localhost:3000//pings/handle?type=1static&app_id=1 2376`



### Here are the setup instructions from DOCKER:

How to run
	`docker-compose build`
	`docker-compose up -d`
	`docker-compose exec -it web rake db:create`
	`docker-compose exec -it web rake db:migrate`


### Challenge

● Create a simple proxy service to ​Forward, Store​ and ​Validate​ traffic.
● You shouldn’t use more than 4h to work through this exercise.
● Technical Stories Forward:
      The service should change the host from the request and change it to
  https://www.mocky.io/v2/5185415ba171ea3a00704eed/
● The service should append all Query string parameters to the above Mock URL 


Store:
 ● The service should only store pings (traffic) in a database when the URL has a query parameter ​proxy=true
 ● The service should store the following ping data: 
     - Original URL
                 - Query params (Key/Value)
                 - Errors (Key/Value described in validation section)
Example:
- localhost/<controller>/<action>?proxy=true&type=static&app_id=1 2376



Validate:
● Incase of stored pings, the service should validate the following criteria: 
		- validate presence of query params: type​ and ​app_id
		- validate inclusion of ​type​ in s​tatic​, ​lite​ and ​dynamic
		- validate ​app_id​ as numeric string
● The service should store ping’s errors in ​Errors​ column

Validate Technologies
● Ruby 2.4+, Rails 5+, Postgres 9.6+ Evaluation
● Clean code
● Exceptions handling and logging
● Test cases
● Bonus: 
    Dockerizing the application
