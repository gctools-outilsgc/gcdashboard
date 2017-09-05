require 'net/http'
require 'json'

incrementer = 0

SCHEDULER.every '10s' do
	incrementer = incrementer % 5

	url = 'https://gccollab.ca/services/api/rest/json/?method=member.stats&type=all&lang=en'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	json = JSON.parse(response)

	users = []
  	users << ['Federal', json['result']['federal'].to_i]
  	users << ['Student', json['result']['student'].to_i]
  	users << ['Academic', json['result']['academic'].to_i]
  	users << ['Provincial', json['result']['provincial'].to_i]
  	users << ['Retired', json['result']['retired'].to_i]
  	users << ['Business', json['result']['business'].to_i]
  	users << ['Other', json['result']['other'].to_i]
  	users << ['Community', json['result']['community'].to_i]
  	users << ['NGO', json['result']['ngo'].to_i]
  	users << ['Municipal', json['result']['municipal'].to_i]
  	users << ['International', json['result']['international'].to_i]
  	users << ['Media', json['result']['media'].to_i]

	send_event('user_types_gccollab', { name: users[incrementer][0], value: users[incrementer][1] })

	incrementer += 1
end
