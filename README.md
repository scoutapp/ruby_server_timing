# Server Timing Response Headers for Rails & Rack Apps

The `server_timing` gem brings server-side performance metrics collected by the [scout_apm gem](https://github.com/scoutapp/scout_apm_ruby) to your browser via the [Server Timing](https://w3c.github.io/server-timing/) API. Works on any Ruby framework supported by `scout_apm`. A [Scout](https://scoutapp.com) account is not required.

![server timing screenshot](https://s3-us-west-1.amazonaws.com/scout-blog/ruby_server_timing.png)

## Gem Installation

Add this line to your application's Gemfile:

```ruby
gem 'server_timing'
```

And then execute:

    $ bundle

## Configuration

### Ruby on Rails

For Rails apps, the only required configuration step is setting up a minimal Scout config file. The `server_timing` gem reports metrics collected by the [scout_apm](https://github.com/scoutapp/scout_apm_ruby) gem (added as a dependency of `server_timing`).

If you don't have a Scout account, copy and paste the following minimal configuration into a `RAILS_ROOT/config/scout_apm.yml` file:

```yaml
common: &defaults
  monitor: true

production:
  <<: *defaults
```

If you have a Scout account, no extra configuration is required. If you wish to see server timing metrics in development, ensure `monitor: true` is set for the `development` environment in the `scout_apm.yml` file.

[See the scout_apm configuration reference](http://help.apm.scoutapp.com/#ruby-configuration-options) for more information.

### Rack

Use the `ServerTiming::Middleware`:

```ruby
# config.ru
require 'server_timing'
use ServerTiming::Middleware
```

* Add the minimal Scout config above to `APP_ROOT/scout_apm.yml`.
* Scout requires additional steps to instrument Rack applications. [See the guide](http://help.apm.scoutapp.com/#rack). Without these steps, the instrumentation will not execute and server timing metrics will not be reported.

## Usage

The `server_timing` gem exposes server-side performance metrics collected by the `scout_apm` gem inside your browser. As of this writing, [Chrome Canary](https://www.google.com/chrome/browser/canary.html) Versions 66+ display this information.

### Instrumentation

#### Auto-Instrumentation

By default, the total time consumed by each of the libraries `scout_apm` instruments is reported. This includes ActiveRecord, HTTP, Redis, and more. [View the full list of supported libraries](http://help.apm.scoutapp.com/#ruby-instrumented-libs). 

#### Custom Instrumentation

Collect performance data on additional method calls by adding custom instrumentation via `scout_apm`. [See the docs for instructions](http://help.apm.scoutapp.com/#ruby-custom-instrumentation).

### Security

#### Ruby on Rails

By default, server timing response times are sent in non-development environments. In production, __the headers must be explicitly enabled__ by calling `ServerTiming::Auth.ok!`:

```ruby
# app/controllers/application_controller.rb

before_action do
  if current_user && current_user.admin?
    ServerTiming::Auth.ok!
  end
end
```

#### Rack

Headers are always sent. To toggle:

```
ServerTiming::Auth.ok! # enables on this and all future requests
ServerTiming::Auth.deny! # disables on this and all future requests
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scoutapp/ruby_server_timing.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

