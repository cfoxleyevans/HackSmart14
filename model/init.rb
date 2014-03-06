require 'active_record'
require 'rgeo'
require 'rgeo-activerecord'
require 'yaml'
require_relative 'journey_time'
require_relative 'roadwork'

def read_config 
  filepath = File.expand_path('..', File.dirname(__FILE__)) + '/config/db.yml'
  YAML::load(File.open(filepath)) 
end

ActiveRecord::Base.logger = Logger.new(STDOUT)

config = read_config()
ActiveRecord::Base.establish_connection(
  :adapter => "mysql2spatial",
  :host => config['host'],
  :username => config['username'],
  :password => config['password'],
  :database => "wonder"
)
