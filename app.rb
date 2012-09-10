require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require "uri"
require "net/http"
require "github_api"

set :environment, :development

$stdout.sync = true

get '/' do
	'I am the OGS to Github Uploader!'
end

post '/upload/?' do
	json = JSON.parse(request.body.read)
	if json['build']['status'] =~ /SUCCESS/ and json['build']['phase'] =~ /FINISHED/

		# Get file from Jenkins
		local_filename = /.*\/(.*)/.match(ENV["UPLOAD_FILE_NAMES"])[1]
		uri = URI.parse("#{json['build']['full_url']}artifact/#{ENV['UPLOAD_FILE_NAMES']}")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		req = Net::HTTP::Get.new(uri.request_uri)
		req.basic_auth ENV['JENKINS_USER'], ENV['JENKINS_PW']
		response = http.request(req)
		open(local_filename, "wb") do |file|
			file.write(response.body)
		end

		# Upload file to GitHub
		gh = Github.new basic_auth: "#{ENV['GITHUB_AUTH_USER']}:#{ENV['GITHUB_PW']}", user: ENV['GITHUB_USER'], repo: ENV['GITHUB_REPO']

		# remvove previous download with the same name
		gh.repos.downloads.list ENV['GITHUB_USER'], ENV['GITHUB_REPO'] do |download|
		  if local_filename == download.name
			gh.repos.downloads.delete ENV['GITHUB_USER'], ENV['GITHUB_REPO'], download.id
			break
		  end
		end

		# Create download on GitHub
		hash = gh.repos.downloads.create ENV['GITHUB_USER'], ENV['GITHUB_REPO'],
		  "name" => local_filename,
		  "size" => File.size(local_filename),
		  "description" => "Created by Jenkins: #{json['build']['full_url']}"

		# Actually upload to Amazon S3
		gh.repos.downloads.upload hash, local_filename

		puts "uploaded file #{local_filename}"
	end
end

get '/finished/' do
	'Hey you succesfully uploaded something!'
end