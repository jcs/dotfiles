--
-- Hammerspoon module for key actions from my Thinkpad USB Keyboard
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

local function sendSystemKey(key, modifiers)
	hs.eventtap.event.newSystemKeyEvent(key, true):setFlags(modifiers):post()
	hs.eventtap.event.newSystemKeyEvent(key, false):setFlags(modifiers):post()
end

-- F1: mute
hs.hotkey.bind({}, "F1", function()
	sendSystemKey("MUTE")
end)

-- F2: volume down (small increment)
local function volume_down()
	sendSystemKey("SOUND_DOWN", { [ "alt" ] = true, [ "shift" ] = true })
end
hs.hotkey.bind({}, "F2", volume_down, nil, volume_down)

-- F3: volume up (small increment)
local function volume_up()
	sendSystemKey("SOUND_UP", { [ "alt" ] = true, [ "shift" ] = true })
end
hs.hotkey.bind({}, "F3", volume_up, nil, volume_up)

-- F5: brightness down
hs.hotkey.bind({}, "F5", function()
	-- XXX: not sure why this doesn't work:
	-- sendSystemKey("BRIGHTNESS_DOWN", {})
	hs.brightness.set(math.max(0, hs.brightness.get() - 5))
end)

-- F6: brightness up
hs.hotkey.bind({}, "F6", function()
	-- sendSystemKey("BRIGHTNESS_UP", {})
	hs.brightness.set(math.min(100, hs.brightness.get() + 5))
end)

-- F10: previous track
hs.hotkey.bind({}, "F10", function()
	sendSystemKey("PREVIOUS", {})
end)
-- cmd+F10: previous album
hs.hotkey.bind({ "cmd" }, "F10", function()
	local playing = hs.itunes.isPlaying()
	if playing then
		hs.itunes.pause()
	end

	local al = hs.itunes.getCurrentAlbum()
	local cal = al
	-- skip to last track of previous album
	while cal == al do
		hs.itunes.previous()
		cal = hs.itunes.getCurrentAlbum()
	end
	-- then again until we're at the last track of the album before that one
	al = cal
	while cal == al do
		hs.itunes.previous()
		cal = hs.itunes.getCurrentAlbum()
	end
	-- then go forward to be at the first track of the first previous album
	hs.itunes.next()

	if playing then
		hs.itunes.play()
	end
end)

-- F11: play/pause
hs.hotkey.bind({}, "F11", function()
	sendSystemKey("PLAY", {})
end)

-- F12: next track
hs.hotkey.bind({}, "F12", function()
	sendSystemKey("NEXT", {})
end)
-- cmd+F12: next album
hs.hotkey.bind({ "cmd" }, "F12", function()
	local playing = hs.itunes.isPlaying()
	if playing then
		hs.itunes.pause()
	end

	local al = hs.itunes.getCurrentAlbum()
	local cal = al
	while cal == al do
		hs.itunes.next()
		cal = hs.itunes.getCurrentAlbum()
	end

	if playing then
		hs.itunes.play()
	end
end)
