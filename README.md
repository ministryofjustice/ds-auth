# Defence Solicitor Authentication

This is a centralised OAuth 2-based single sign-on provider.

We use Devise to provide username / password sign-in, and Doorkeeper to provide an OAuth 2 provider.

Notes on the application structure can be found [here](docs/structure.pdf)

## Usage
The app currently uses Rails seeds to populate consuming applications and users. See [db/seeds](db/seeds) for more info.

An [omniauth](https://github.com/intridea/omniauth) gem has been written to make integrating consuming applications easier: [omniauth-dsds](https://github.com/ministryofjustice/defence-request-service-omniauth-dsds)

## Environment Variables
see .example.env

### Session Timeout
By default sessions will last 1 hour with no action before requiring the User to log in again.
This can be customized by setting the ```SESSION_TIMEOUT_MINUTES``` ENV variable.
(Note the value is in minutes)

## Local Setup

To get the application running locally, you need to:

 * ### Clone the repository
 	``` git clone git@github.com:ministryofjustice/defence-request-service-auth.git```

 * ### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * ### Install postgres 9.4 or above
 	http://www.postgresql.org/

 * ### Bundle the gems
       cd defence-request-service-auth
       bundle install

 * ### Create and migrate the database; run seeds

 		bundle exec rake db:create
 		bundle exec rake db:migrate
 		bundle exec rake db:seed


 * ### Start the server
 		cd defence-request-service-auth && bundle exec rails server

 * ### Use the app

 	You can find the service app running on `http://localhost:45454`

  To find which users credentials you can use, look in the `db/seeds/users.rb` file

### Test setup

To run the tests, you will need to install [PhantomJS](http://phantomjs.org/), the test suite is known to be working with version `1.9.7`, it may or may not work with other versions. To run the tests, use the command: ```bundle exec rake```

## Docker

A [Makefile](Makefile) is provided to build the app as a docker image.

3 different environments are used for Docker - dev, test and production.

* development - includes phantomjs and mounts the code as a volume
* test - includes phantomjs and copies code into image. Default run commmand set to ```rake spec```
* production - just what is needed for production. No dev or test gems / services

```make all``` will build all 3 environments

```make development_container``` will just build be development image

