--
-- Hammerspoon module for showing weather from openweathermap.org in the toolbar
-- Copyright (c) 2021 joshua stein <jcs@jcs.org>
--
-- Permission to use, copy, modify, and distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--

local weather = {}

weather.callback = function(code, body, headers)
	if code ~= 200 then
		weather.log.e("bad http status " .. code .. ", body: " .. body)
		weather.menu:setTitle("Weather error!")
		weather.stop()
		return
	end

	weather.log.i("http callback: " .. body)
	local js = hs.json.decode(body)
	local title = js.weather[1].description
		:gsub("^scattered ", "")
		:gsub("^overcast clouds", "overcast")
		:gsub("^broken clouds", "cloudy")
		:gsub("^overcast clouds", "overcast")
		:gsub("^(.)", function(s) return string.upper(s) end)

	title = title .. " " .. math.floor(js.main.temp) .. "°F / " ..
		math.floor(js.main.humidity) .. "%"

	weather.menu:setTitle(title)
end

weather.update = function()
	hs.http.doAsyncRequest(
		"https://api.openweathermap.org/data/2.5/weather?" ..
		"q=" .. hs.http.encodeForQuery(weather.location) ..
		"&units=imperial" ..
		"&appid=" .. weather.api_key,
		"GET", nil, nil, weather.callback)
end

weather.start = function(location, api_key)
	weather.log = hs.logger.new("weather", "info")
	weather.log.i("weather module starting up for " .. location)
	weather.location = location
	weather.api_key = api_key
	weather.menu = hs.menubar.new()
	weather.update()
	weather.timer = hs.timer.doEvery(300, function() weather.update() end)
end

weather.stop = function()
	weather.timer:stop()
end

return weather
