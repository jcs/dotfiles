local config = hs.json.read("config.json")
local log = hs.logger.new("local", "debug")

require("keys")

if config.weather.api_key == "" then
	log.e("no weather.api_key in config.json")
else
	weather = require("weather")
	weather.start(config.weather.location, config.weather.api_key)
end
