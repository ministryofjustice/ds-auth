# Drs::AuthClient

This gem is a part of the *Defence Request Service Auth* project. It's a thin wrapper to provide abstraction of the RESTful api the Auth service provides.

## Instalation

At the moment there's only the Github version available, which can be added to `Gemfile`:

```ruby

gem "drs-auth_client", github: "ministryofjustice/defence-request-service-auth"

```

## Configuration

There are 2 configuration options:

* *host* - full protocol, host and port to the Auth api
* *version* - which version of the Auth api to use

The client is currently only configured globally, ie. in Rails initializer:

```Ruby

Drs::AuthClient.configure do |client|
  client.host = "http://localhost:45454"
  client.version = :v1
end

```

## Usage


```Ruby

    # get a valid authenticated OAuth token
    auth_token = '...'
    
    # instantiate the client with the token
    client = Drs::AuthClient::Client.new(auth_token)
    
    # single resource example
    organisation = client.organisation('UID')
    
    # collection of resources
    profiles = client.profiles
    
```

## Design and extending

The client is based on a few conventions:

1. The API is implemented as RESTful
2. Models are named based on remote resources and in the `Drs::AuthClient::Models` namespace - ie. `Organisation` for `/organisations`
3. Models have `uid` attribute as their unique identified and can be retrieved by it - ie. `/organisations/UID`
4. Remote responses have the resource data prefixed on the top level based on the model (resource) name - ie. for `profile` and `profiles`

	```json

	// single resource	
	{
		"profile": {
			"uid": "PROFILE",
			"name": "Name and Surname"
		}
	}
	
	// collection
	{
		"profiles": [
			{
				"uid": "PROFILE1",
				"name": "Name and Surname"
			},
			{
				"uid": "PROFILE2",
				"name": "Other Name"
			}
		]
	}
	
	```
	
5. client automatically exposes methods for single and collection resources for all models in the namespace (apart from `Base`)


## Extending

### New resource / model

The most usual extension probably will be adding more resources / models. That's done by adding a new class in the right namespace. Models can extend the `Base` class or even each other:

```ruby

module Drs::AuthClient::Models
	class SolicitorSearch < Profile
		
	end
end
```

Require the model in the `lib/drs/auth_client/client.rb` file for the resource methods to become available.

### Adding available fields to models

This is done by simply adding more `attr_accessor` fields on the model classes.

### Nested resources

For the moment there's no support for nested resources, but probably the easiest implementation would be to allow specifying these in the model like this:

```ruby

class Profile < Base
	attr_accessor :name
	nested :law_firm, type: :organisation
end

```

The `nested` method should be implemented in the `Base` model.