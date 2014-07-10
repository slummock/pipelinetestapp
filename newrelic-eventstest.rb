require 'net/http'
require "uri"

class NewRelicEvents
	
	attr_accessor :api_key, :application_id, :proxy_address, :proxy_port

	def initialize()
		
	end

	def send_deployment_event(description, revision, deployer, changelog)
		
		raise 'must specify api_key' if @api_key.nil?
		raise 'must specify application_id' if @application_id.nil?

		uri = URI("http://requestb.in/1a4sdxc1")

		request = build_deployment_request(uri, description, revision, deployer, changelog)
		response = send_request(uri, request)
				
		raise "Deployment logging failed #{response.code}, #{response.body}" unless response.code=='201'

		puts "Deployment logged successfully"
	end

	def send_request(uri, request)

		http = Net::HTTP.new(uri.host, uri.port, @proxy_address, @proxy_port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		http.read_timeout = 50

		response = http.request(request)

		response
	end

	def build_deployment_request(uri, description, revision, deployer, changelog)
		raise 'must specify description' if description.nil?
		raise 'must specify revision' if revision.nil?
		raise 'must specify deployer' if deployer.nil?

		request = Net::HTTP::Post.new(uri.request_uri)
		request.add_field 'x-api-key', @api_key
		request.set_form_data(
			{
				'application_id' => @application_id,
				'description' => description,
				'revision' => revision,
				'user' => deployer,
				'changelog' => changelog
			})

		request
	end
end