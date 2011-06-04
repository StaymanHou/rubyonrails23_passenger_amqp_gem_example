# An example Ruby on Rails 2.3 application that uses Ruby AMQP gem with Passenger #

This app demonstrates how you can integrate [Ruby amqp gem](http://github.com/ruby-amqp/amqp) into a Ruby on Rails application that runs on [Passenger](http://www.modrails.com/).

## Getting Started ##

    gem install bundler

and then

    bundle install

after that, launch passenger standalone (or use nginx/apache module)

    bundle exec passenger start -p 3000

finally, visit http://localhost:3000/ with your browser and watch console output.


## What does it do? ##

When application receives a request it is redirected to one of the free passenger workers. If there aren't any, passenger spawns one and gives control to it once it is loaded.

Key moment here is that you should start eventmachine reactor after the fork (if you use one of the smart* spawning methods),
that's why `PhusionPassenger.on_event(:starting_worker_process)` is used. See `config/initializers/amqp.rb` for details.

## License ##

Apache Public License 2.0.

See LICESE file in the repository root.
