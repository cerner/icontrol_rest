# Icontrol

Gem used to wrap iControl API REST calls to an F5. The intent of this client is to match the iControl API methods and pass the response without modification. It does not contain business logic to scrub a response or prevent certain methods. This logic is to be in your orchestration layer, not in the client.

This has been tested against 11.5.4, but should be compatible with future versions. If this gem isn't compatible with a newer version of BIG-IP, or doesn't have the functionality required to access a certain method, feel free to follow the [guidelines for contributing](.github/CONTRIBUTING.md) and provide an enhancement. When doing so, please follow semantic versioning when considering changes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'icontrol_rest'
```

And then execute:

```
$ bundle install
```

Or install it yourself:

```
$ gem install icontrol_rest
```


## Usage

```ruby
require 'icontrol_rest'

api = IcontrolRest::Client.new(host: '1.2.3.4', user: 'user', pass: 'pass', verify_cert: false)
# => <IcontrolRest::Client:0x007fb953ab7750 @options={ ... }>

api.get_sys_dns
# => {"kind"=>"tm:sys:dns:dnsstate",
      "selfLink"=>"https://localhost/mgmt/tm/sys/dns?ver=11.5.4",
      "description"=>"configured-by-dhcp",
      "nameServers"=>["1.2.3.72", "1.2.3.73"],
      "search"=>["domain.com"]}

# Or you can manually do it:
api.get('/mgmt/tm/sys/dns')
# => {"kind"=>"tm:sys:dns:dnsstate",
      "selfLink"=>"https://localhost/mgmt/tm/sys/dns?ver=11.5.4",
      "description"=>"configured-by-dhcp",
      "nameServers"=>["1.2.3.72", "1.2.3.73"],
      "search"=>["domain.com"]}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Please review the [guidelines for contributing](.github/CONTRIBUTING.md) to this repository.
