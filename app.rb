require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require "mongo_mapper"
require "./db_connection.rb"
require "./flight.rb"
require "./db.rb"

set :environment, :development

get '/' do
	'I am the OGS to Github Uploader!'
end