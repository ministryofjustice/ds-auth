# Defence Solicitor Authentication

## Environment Variables
see .example.env

### Session Timeout
By default sessions will last 1 hour with no action before requiring the User to log in again.
This can be customized by setting the ```SESSION_TIMEOUT_MINUTES``` ENV variable.
(Note the value is in minutes)

## API documentation
Written using API Blueprint syntax: https://apiblueprint.org/ into apiary.apib

To generate a new HTML format locally run: ```bin/render_api```
(requires [aglio](https://github.com/danielgtaylor/aglio))

API docs accessible from /api.html

## Local Setup

To get the application running locally, you need to:

 * ### Clone the repository
 	``` git clone git@github.com:ministryofjustice/defence-request-service-auth.git```

 * ### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * ### Install postgres
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

