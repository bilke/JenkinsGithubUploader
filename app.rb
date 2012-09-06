require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"

set :environment, :development

get '/' do
	'I am the OGS to Github Uploader!'
end