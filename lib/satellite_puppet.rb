require 'rest-client'
require 'json'
require 'yaml'

require 'satellite_puppet/version'
require 'satellite_puppet/base'
require 'satellite_puppet/repositories'
require 'satellite_puppet/rake_tasks'

module SatellitePuppet
  def self.sat_server=(server)
    @sat_server = server
  end

  def self.sat_server
    @sat_server ||= config['sat_server']
  end

  def self.sat_username=(username)
    @sat_username = username
  end

  def self.sat_username
    @sat_username ||= config['sat_username']
  end

  def self.sat_password=(password)
    @sat_password = password
  end

  def self.sat_password
    @sat_password ||= config['sat_password']
  end

  def self.base_url
    "https://#{sat_username}:#{sat_password}@#{sat_server}/katello/api"
  end

  private

  def self.config
    YAML.load(File.read 'etc/sat-simple-config.yml')
  end
end
