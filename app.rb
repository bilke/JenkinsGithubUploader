require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require "uri"

set :environment, :development

$stdout.sync = true

get '/' do
	'I am the OGS to Github Uploader!'
end

post '/upload/?' do
	json = JSON.parse(request.body.read)
	if json['build']['status'] =~ /SUCCESS/ and json['build']['phase'] =~ /FINISHED/
		full_url_match = /(.*:\/\/)(.*)/.match(json['build']['full_url'])
		auth_full_url = "#{full_url_match[1]}#{ENV['JENKINS_USER']}:#{ENV['JENKINS_PW']}@#{full_url_match[2]}"
		download_url = URI.escape(auth_full_url) + 'artifact/' + ENV["UPLOAD_FILE_NAMES"]
		`wget #{download_url}`
	end
end

get '/finished/' do
	'Hey you succesfully uploaded something!'
end