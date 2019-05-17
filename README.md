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


