require 'dashing'

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Cache-Control'] = 'no-cache'
end

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

# set :assets_prefix, 'YOUR_ASSETS_DIR'
map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

set :default_dashboard, 'YOUR_DEFAULT_DASHBOARD'

run Sinatra::Application
