# Server Timing Response Headers for Rails

Bring Ruby on Rails server-side performance metrics 📈 to Chrome's Developer Tools (and other browsers that support the [Server Timing](https://w3c.github.io/server-timing/) API) via the `server_timing` gem. 

Metrics are collected from the [scout_apm](https://github.com/scoutapp/scout_apm_ruby) gem. A [Scout](https://scoutapp.com) account is not required.

![server timing screenshot](https://s3-us-west-1.amazonaws.com/scout-blog/ruby_server_timing.png?x)

## Gem Installation

Add this line to your application's Gemfile:

```ruby
gem 'server_timing'
```

And then execute:

    $ bundle

## Configuration

A minimal Scout config file is required. The `server_timing` gem reports metrics collected by the [scout_apm](https://github.com/scoutapp/scout_apm_ruby) gem (added as a dependency of `server_timing`).

If you don't have a Scout account, copy and paste the following minimal configuration into a `RAILS_ROOT/config/scout_apm.yml` file:

```yaml
common: &defaults
  monitor: true

production:
  <<: *defaults
```

If you have a Scout account, no extra configuration is required. If you wish to see server timing metrics in development, ensure `monitor: true` is set for the `development` environment in the `scout_apm.yml` file.

[See the scout_apm configuration reference](http://help.apm.scoutapp.com/#ruby-configuration-options) for more information.

## Browser Support

- Chrome 65+
- Firefox 59+
- Opera 52+

## Instrumentation

### Auto-Instrumentation

By default, the total time consumed by each of the libraries `scout_apm` instruments is reported. This includes ActiveRecord, HTTP, Redis, and more. [View the full list of supported libraries](http://help.apm.scoutapp.com/#ruby-instrumented-libs). 

### Custom Instrumentation

Collect performance data on additional method calls by adding custom instrumentation via `scout_apm`. [See the docs for instructions](http://help.apm.scoutapp.com/#ruby-custom-instrumentation).

## Security

* Non-Production Environments (ex: development, staging) - Server timing response headers are sent by default. 
* Production - The headers must be enabled.

Response headers can be enabled in production by calling `ServerTiming::Auth.ok!`:

```ruby
# app/controllers/application_controller.rb

before_action do
  if current_user && current_user.admin?
    ServerTiming::Auth.ok!
  end
end
```

To only enable response headers in development and for admins in production:

```ruby
# app/controllers/application_controller.rb

before_action do
  if current_user && current_user.admin?
    ServerTiming::Auth.ok!
  elsif Rails.env.development?
    ServerTiming::Auth.ok!
  else
    ServerTiming::Auth.deny!
  end
end
```

## Overhead

`scout_apm` is designed for use in production apps and is engineered for [low overhead](http://blog.scoutapp.com/articles/2016/02/07/overhead-benchmarks-new-relic-vs-scout) instrumentation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scoutapp/ruby_server_timing.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

