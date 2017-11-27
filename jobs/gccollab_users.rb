require 'net/http'
require 'json'

incrementer = 0

SCHEDULER.every '10s' do
	uri = URI('https://gccollab.ca/services/api/rest/json/?method=member.stats&type=all&lang=en')
	response = Net::HTTP.get(uri)
	json = JSON.parse(response)
  incrementer = incrementer % json['result'].size

  usertype = json['result'].keys[incrementer].capitalize
  count = json['result'].values[incrementer].to_i
  total = json['result']['total'].to_i

	send_event('user_types_gccollab', { name: usertype, value: count, max: total })

	incrementer += 1
end
