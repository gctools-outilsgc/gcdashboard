filename = "/var/www/html/gcdashboard/biggestloser.txt"

SCHEDULER.every '1m' do
	File.open(filename).readlines.each do |line|
		data = line.strip.split(" - ")
		weight = data[1].split(" > ")
		send_event("biggestloser-" + data[0], { last: weight[0], current: weight[1] })
	end
end
