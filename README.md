# SatellitePuppet

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'satellite-puppet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install satellite-puppet

## Usage

- Clone above repository ( currently i dont have gem )
- create new module ( puppet generate dj-testing )
- Update Rakefile with below contents ( make sure you have required gems installed and RUBYLIB path is set )
- 
`
require 'puppetlabs_spec_helper/rake_tasks' # needed for some module packaging tasks
require 'puppet_blacksmith/rake_tasks'
require 'satellite_puppet/rake_tasks'
`
- create "etc/sat-simple-config.yml" file with below contents

`
sat_username: "admin"
sat_password: "changeme"
sat_server: "your satellite server"
`

now once your puppet module is ready, you can run task.

rake satellite:upload("repo_id")  ==>  Pass repository ID

and it will upload module for you ...!!!!



## Contributing

1. Fork it ( https://github.com/[my-github-username]/satellite-puppet/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
