# AceBook

REQUIRED INSTRUCTIONS:

1. Fork this repository to `acebook-teamname` and customize
the below**

[You can find the engineering project outline here.](https://github.com/makersacademy/course/tree/master/engineering_projects/rails)

2. The card wall is here: <please update>

## How to contribute to this project
See [CONTRIBUTING.md](CONTRIBUTING.md)

## Quickstart

First, clone this repository. Then:

```bash
> bundle install
> bin/rails db:create
> bin/rails db:migrate

> bundle exec rspec # Run the tests to ensure it works
> bin/rails server # Start the server at localhost:3000
```

## Clearance
Clearance is being used to manage User registration.
This page has details on how to override some of the default behaviour (ie. redirects after signing in ).
Unfortunately it isn't that up to date.
https://github.com/thoughtbot/clearance/wiki/Usage


The [readme](https://github.com/thoughtbot/clearance) suggests to override the default clearance routes.
Thus we ran `rails generate clearance:routes` which added `config.routes = false` to the `/config/initializers/clearance.rb` file and a whole bunch of stuff to `/config/routes.rb`.

We then created `/app/controllers/users_controller.rb` which inherits the clearance Users controller and overwrites the `url_after_create` method to allow custom redirects. (We may add further overwrites to this file)

To ensure the router uses our controller we changed `/config/routes.rb`, namely
`resources :users, controller: 'clearance/users', only: [:create] do`
to
`resources :users, controller: 'users', only: [:create] do`


!!!

Added `require 'clearance/rspec'` to rails helper.
This allows the clearance helper methods to be used.

Added `require 'support/features/clearance_helpers'` to rails helper.
This allows the clearance helper methods to be used even when the spec file is called individually (which wasn't happening before).tests
This slows down rspec slightly.



###Testing
Ran `rails generate clearance:specs` which added tests for user functionality (thanks clarence!)
Unfortunately needed a factory gem.
Ran `gem install factory_bot_rails`
Methods such as `sign_in` and `sign_out` now available in Rspec tests, in particular the controller tests.

Added `Rails.application.routes.default_url_options[:host] = '???'` to `/config/application.rb` which sets this for all of the environments (prod/dev/test). This was required to allow the 'Visitor resets password with valid email' test to pass.
TODO: Should probably be changed for production.
[Answer found here](https://stackoverflow.com/questions/18742779/actionviewtemplateerror-missing-host-to-link-to#18742821)



## Travis CI
NB: There is a difference between .org and .com

Check deployment.

https://travis-ci.com/dtrts/acebook-ConnectU


https://docs.travis-ci.com/user/tutorial/
https://docs.travis-ci.com/user/deployment/heroku/



## Heroku
```
brew install heroku
```
Once you have a heroku account you can host your own via these commands:
```
heroku create
git push heroku master
heroku rake db:migrate
heroku open /posts
```

Our app is deployyed at: acebook-connectu.herokuapp.com




## Code Climate
https://codeclimate.com/repos/5d7658b000ca3e0177007b30
Reviews quality of repo


## Database Development
If you need to play with the development database in IRB you can use these commands to get stuck in with the orm.

Make sure you have a database first!
Add on any additional models if needed.

```
require 'active_record'
require 'clearance'
ActiveRecord::Base.establish_connection(adapter: 'postgresql', database:'pgapp_development')
require_relative './app/models/application_record.rb'
require_relative './app/models/user.rb'
require_relative './app/models/post.rb'
```

<<<<<<< HEAD
## Brief : Branch Merging
Once a branch has been completed and all tests are passing, the merge a branch, first you need to create a pull request to the master branch. 
=======
## Rails Time Object, Freeze & Structure

### Freeze

For our testing framework we will need to freeze 'Time' be able to test effectively for posts being in order and timing out the ability to edit posts after 10 minutes have passed.

To do this I found a native rails helper called 'travel_to'

```ruby

travel_to Time.local(1994)

```

In the above example we are setting the Time for the test to just after midnight, January 1st 1994.

### Beautifying Time

On our post index view, we wanted to see the time a post was created at, however the Time object isn't exactly nice to look at. To fix this, we used an formatting tool found below;

```ruby

strftime("%I:%M %p, %d of %B")

```

This, when called on a time object, will return;

`12:00 AM, 01 of January`
>>>>>>> c039d4312bc1aa58ca79669df35b47c93ec4b4a3

The process first needs to pass the merge and any conflicts resolved, then once merged to master to deploy - .travis and CI process needs to pass which builds the app and if all tests pass the app is deployed. 


## Profile Creation

After profile controller created and profile routes, in routes.rb, created by adding;

```ruby

resources :profile

```

Inside the profile controller we created;

```ruby

def index
    @posts = Post.where(user_id: current_user.id)
end

```

What we are doing here, is assigning the @posts instance variable with all Posts where the foriegn key of user_id matched the current logged in users id.
This is using the one to many relationship we created inside the database and the model of the Post and User.
