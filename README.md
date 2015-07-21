# Digital Services Authentication Platform

This is a centralised OAuth 2-based single sign-on provider.

We use Devise to provide username / password sign-in, and Doorkeeper to provide an OAuth 2 provider.

For Rails (or ruby) applications an [omniauth](https://github.com/intridea/omniauth) gem has been written to make integrating consuming applications easier: [ds-auth-omniauth](https://github.com/ministryofjustice/ds-auth-omniauth)

A [demo Rails application](https://github.com/ministryofjustice/ds-auth-omniauth/tree/master/demo) shows how to integrate with the Auth service using the ds-auth-omniauth gem

## Structure
This application is structured around Users belonging to different Groups / Organisations and gaining access to various applications / services because they belong to those Organisations.

![Structure diagram](/docs/schema.png)

As shown above we have consuming Applications registered with the auth app, Organisations and Users. Organisations are given access to Applications by a User with a Webops role. Once done then any Users that are a member of those Organisations are be given access to those Applications.

When a User becomes a member of an Organisation by default they have access to no Applications. The Users membership needs to be updated to indicate which of the Organisations Applications can access. This can only be done by a Webops User or an Organisation Admin user.

A User can be a member of multiple Organisations, and therefore have access to the same Application as a result of being a member of 2 or more Organisations that have access to a given Application.

## Authentication
Each User is authenticated using Devise via an email+password combination.

Read the [devise docs](https://github.com/plataformatec/devise/wiki) for more information.

## Authorization
Authorization can work in 2 different ways.

Each consuming Application can:

* rely on the Auth app for Authorization management
* implement its own Authorization layer (and use the Auth app for Authentication only)

#### Centralized Authorization
The Auth app knows what roles the consuming Application recognises. Each User that has access to the Application needs to be given 1 or more role(s) for that Application. The Auth app will check that the User has access to the application. Failures are not issued access_tokens and are redirected to the ```failure_uri```.

```available_roles``` needs to be filled in (1 role per line)

```failure_uri``` can optionally be customized - by default it is a redirect back to ```/auth/failure``` on the consuming application domain 

Otherwise when that User tries to access the Application they will be redirected to the ```failure_uri``` url (```/auth/failure``` by default) as they are trying to log into an application that requires them to have a role and they have no role assigned to them.

#### Own Authorization
The Auth app only needs to know that the Application that it ```handles_own_authorization``` (set on the Application object)

The role check will be skipped and all Users of this Application will be issued access_tokens. 

Any ```available_roles``` and ```failure_uri``` will be ignored.

## Usage

### User types
There are 2 user types in the Auth app:

#### Webops user
Are the super users - they can do everything. 

Only Webops users can create and manage Applications, create Organisations, and give Organisations access to Applications.

Webops users are created using a rake task as they are meant to be "unseen" users 

```bundle exec rake users:create_webops name='First Last' email=user@example.com password='aabbccddee' ```

Can also do everything that an Organisation Admin and User can.

#### Organisation Admin User
Can add/remove Users from their Organisation. Can specify which Users have access which of the Organisations Applications.

Can also do everything a User can.

#### User
Can update their own information (name, email, password etc). Can see other Users in the Organisations they belong to but cannot change anything else.

### Adding a new Application

* __First - as a Webops User__
* Create the Application
* Make note of the application_id and application_secret to use in the consuming Application
* Enter in the applications roles OR mark the application as handles_own_authorization
* Edit all the Organisations that require access to the Application and give them access
* Create an Organisation Admin user (or add an existing user and give them Organisation Admin rights)

* __Second - as a Webops User OR Organisation Admin user__
* Update the membership of the Users to give them one or more roles OR the login role

### Add a new User to an Organisation

* __As a Webops User OR Organisation Admin user__
* Go to the organisation details page
* Click Add User button
* Fill in the User details and click Create
* On the next screen choose which application(s) this User needs access to
* Click Save

### Add an existing User to an Organisation

* __As a Webops User OR Organisation Admin user__
* Go to the organisation details page
* Click Add User button
* Fill in the User details and click Create
* There will be an error saying the User is already known. Click the link it provides to add the User to the Organisation
* On the next screen choose which application(s) this User needs access to
* Click Save



### Forgot Password
On the login page is a forgot password link.

If a recognised email address is entered a Reset Password email is sent to the User.


## Environment Variables
see .example.env

### Session Timeout
By default sessions will last 1 hour with no action before requiring the User to log in again.
This can be customized by setting the ```SESSION_TIMEOUT_MINUTES``` ENV variable.
(Note the value is in minutes)

## Local Setup

To get the application running locally, you need to:

 * #### Clone the repository
 	``` git clone git@github.com:ministryofjustice/ds-auth.git```

 * #### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * #### Install postgres 9.4 or above
 	http://www.postgresql.org/

 * #### Bundle the gems
       cd ds-auth
       bundle install

 * #### Create and migrate the database; run seeds

 		bundle exec rake db:create
 		bundle exec rake db:migrate


 * #### Start the server
 		cd ds-auth && bundle exec rails server

 * #### Use the app

 	You can find the service app running on `http://localhost:3000`


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

```docker run -i -v./:/app ds-auth_development```













end

