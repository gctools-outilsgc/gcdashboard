require 'google/api_client'
require 'date'
require_relative '../config.rb'

# Update these to match your own apps credentials
service_account_email = GA_EMAIL
key_file = GA_KEY
key_secret = GA_SECRET
GCcollabID = GA_COLLAB_ID
GCconnexID = GA_CONNEX_ID
GCpediaID = GA_PEDIA_ID

visitorCountTime = '1h'
visitorCountRealTime = '10s'
pagesCountTime = '5m'

$ElggFilters = GA_FILTERS

# Get the Google API client
client = Google::APIClient.new(
  :application_name => 'GCcollab',
  :application_version => '0.01'
)

# Load your credentials for the service account
key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => 'https://www.googleapis.com/auth/analytics.readonly',
  :issuer => service_account_email,
  :signing_key => key
)



#### GCcollab ####

# Start the scheduler #####################################################################################################################
SCHEDULER.every visitorCountTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now - 30
  startDate = startDate.strftime("%Y-%m-%d")
  # startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  visitCount = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + GCcollabID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'metrics' => "ga:visits",
  })

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('visitor_count_gccollab', { current: visitCount.data.rows[0][0].to_i })
end

# Start the scheduler #####################################################################################################################
SCHEDULER.every pagesCountTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now - 1
  startDate = startDate.strftime("%Y-%m-%d")
  # startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  response = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + GCcollabID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'dimensions' => "ga:pagetitle",
    'filters' => $ElggFilters,
    'metrics' => "ga:pageviews",
    'sort' => "-ga:pageviews",
    'max-results' => 5
  })

  topPagesGCcollab = []
  topPagesGCcollab << { 'label': response.data.rows[0][0].to_str.sub(' : GCcollab','') }
  topPagesGCcollab << { 'label': response.data.rows[1][0].to_str.sub(' : GCcollab','') }
  topPagesGCcollab << { 'label': response.data.rows[2][0].to_str.sub(' : GCcollab','') }
  topPagesGCcollab << { 'label': response.data.rows[3][0].to_str.sub(' : GCcollab','') }
  topPagesGCcollab << { 'label': response.data.rows[4][0].to_str.sub(' : GCcollab','') }

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('top_pages_gccollab', { items: topPagesGCcollab })
end

visitorsGCcollab = []

# Start the scheduler #####################################################################################################################
SCHEDULER.every visitorCountRealTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Execute the query
  response = client.execute(:api_method => analytics.data.realtime.get, :parameters => {
    'ids' => "ga:" + GCcollabID,
    'metrics' => "ga:activeVisitors",
  })

  number = (response.data.rows[0] ? response.data.rows[0][0].to_i : 0)
  #number = (number * 3.5).ceil
  visitorsGCcollab << { x: Time.now.to_i, y: number }

  # Update the dashboard
  send_event('visitor_count_real_time_gccollab', points: visitorsGCcollab)
end

#### End GCcollab ####




#### GCconnex ####

# Start the scheduler #####################################################################################################################
SCHEDULER.every visitorCountTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now - 30
  startDate = startDate.strftime("%Y-%m-%d")
  # startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  visitCount = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + GCconnexID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'metrics' => "ga:visits",
  })

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('visitor_count_gcconnex', { current: visitCount.data.rows[0][0].to_i })
end

# Start the scheduler #####################################################################################################################
SCHEDULER.every pagesCountTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now - 1
  startDate = startDate.strftime("%Y-%m-%d")
  # startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  response = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + GCconnexID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'dimensions' => "ga:pagetitle",
    'filters' => $ElggFilters,
    'metrics' => "ga:pageviews",
    'sort' => "-ga:pageviews",
    'max-results' => 5
  })

  topPagesGCconnex = []
  topPagesGCconnex << { 'label': response.data.rows[0][0].to_str.sub(' : GCconnex','')}
  topPagesGCconnex << { 'label': response.data.rows[1][0].to_str.sub(' : GCconnex','')}
  topPagesGCconnex << { 'label': response.data.rows[2][0].to_str.sub(' : GCconnex','')}
  topPagesGCconnex << { 'label': response.data.rows[3][0].to_str.sub(' : GCconnex','')}
  topPagesGCconnex << { 'label': response.data.rows[4][0].to_str.sub(' : GCconnex','')}

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('top_pages_gcconnex', { items: topPagesGCconnex })
end

visitorsGCconnex = []

# Start the scheduler #####################################################################################################################
SCHEDULER.every visitorCountRealTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Execute the query
  response = client.execute(:api_method => analytics.data.realtime.get, :parameters => {
    'ids' => "ga:" + GCconnexID,
    'metrics' => "ga:activeVisitors",
  })

  visitorsGCconnex << { x: Time.now.to_i, y: (response.data.rows[0] ? response.data.rows[0][0].to_i : 0) }

  # Update the dashboard
  send_event('visitor_count_real_time_gcconnex', points: visitorsGCconnex)
end

#### End GCconnex ####




#### GCpedia ####

# Start the scheduler #####################################################################################################################
SCHEDULER.every visitorCountTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now - 30
  startDate = startDate.strftime("%Y-%m-%d")
  # startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  visitCount = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + GCpediaID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'metrics' => "ga:visits"
  })

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('visitor_count_gcpedia', { current: visitCount.data.rows[0][0].to_i })
end

# Start the scheduler #####################################################################################################################
SCHEDULER.every pagesCountTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now - 1
  startDate = startDate.strftime("%Y-%m-%d")
  # startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  response = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + GCpediaID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'dimensions' => "ga:pagetitle",
    'filters' => "ga:pageTitle!=GCpedia",
    'metrics' => "ga:pageviews",
    'sort' => "-ga:pageviews",
    'max-results' => 5
  })

  topPagesGCpedia = []
  topPagesGCpedia << { 'label': response.data.rows[0][0].to_str.sub(' - GCpedia','')}
  topPagesGCpedia << { 'label': response.data.rows[1][0].to_str.sub(' - GCpedia','')}
  topPagesGCpedia << { 'label': response.data.rows[2][0].to_str.sub(' - GCpedia','')}
  topPagesGCpedia << { 'label': response.data.rows[3][0].to_str.sub(' - GCpedia','')}
  topPagesGCpedia << { 'label': response.data.rows[4][0].to_str.sub(' - GCpedia','')}

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('top_pages_gcpedia', { items: topPagesGCpedia })
end

visitorsGCpedia = []  

# Start the scheduler #####################################################################################################################
SCHEDULER.every visitorCountRealTime, :first_in => 0 do

  # Request a token for our service account
  client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')

  # Execute the query
  response = client.execute(:api_method => analytics.data.realtime.get, :parameters => {
    'ids' => "ga:" + GCpediaID,
    'metrics' => "ga:activeVisitors",
  })

  visitorsGCpedia << { x: Time.now.to_i, y: (response.data.rows[0] ? response.data.rows[0][0].to_i : 0) }

  # Update the dashboard
  send_event('visitor_count_real_time_gcpedia', points: visitorsGCpedia)
end

#### End GCpedia ####