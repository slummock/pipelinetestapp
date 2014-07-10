require 'newrelic-eventstest'

@revision = ENV['GO_PIPELINE_LABEL'] || (raise 'no GO_PIPELINE_LABEL specified')
@deployer = ENV['GO_TRIGGER_USER'] || (raise 'no GO_TRIGGER_USER specified')
@server = ENV['GO_SERVER_URL'] || (raise 'no GO_SERVER_URL specified')
@pipeline = ENV['GO_PIPELINE_NAME'] || (raise 'no GO_PIPELINE_NAME specified')
@stage = ENV['GO_STAGE_NAME'] || (raise 'no GO_STAGE_NAME specified')
@enviroment = ENV['GO_ENVIRONMENT_NAME'] || (raise ' no GO_ENVIRONMENT_NAME specified')
@proxy_address = ENV['NEW_RELIC_DEPLOY_EVENT_PROXY_ADDRESS'] || 'prod-proxy.laterooms.com'
@proxy_port = ENV['NEW_RELIC_DEPLOY_EVENT_PROXY_PORT'] || '8080'
@app_id = ENV['NEW_RELIC_APPLICATION_ID'] || (raise 'no NEW_RELIC_APPLICATION_ID specified')

task :default do
	description = "#{@deployer} deployed revision #{@revision} from #{@server} using the #{@pipeline} pipeline #{@stage} stage. Also testing: GO_ENVIRONMENT_NAME = #{@environment}"

	events = NewRelicEvents::new
	#events.api_key = '6a66564ffe52236cf15ea91857ff86a7a549455c6b5f489'
	events.api_key = 'df282cbd13a438f14993c62830df0286b8f3980e15286e0' # test api key
	#	events.application_id = 3712767
	events.application_id = @app_id # test cc
	events.proxy_address = @proxy_address
	events.proxy_port = @proxy_port
	
	result = events.send_deployment_event(description, @revision, @deployer, "")
end