DigitalDevice = include "devices/digitalDevice"
NoteDictionary = include "devices/buzzer/noteDictionary"
Timer = require "nanotimer"
EventEmitter = require("events").EventEmitter
board = include "board"
module.exports = #---

#A piezo that can play sounds by
#clicking at the right frequency.
class Buzzer extends DigitalDevice
	constructor: (pin) ->
		super pin
		@notes = new NoteDictionary().notes

		@events = new EventEmitter() #EMITILOS GUACHIN

	#play a *note* (e.g. "a#4") for *duration* ms.
	playNote: (note, duration) =>
		@events.emit "start"

		high = @notes
			.find((noteInfo) => noteInfo.note == note)
			.timeHigh

		@_playTone high, duration

	#play a tone creating a wave with *high* ns
	#of high time, with *duration* ms long.
	_playTone: (high, duration) =>
		timer = new Timer()
		timer.elapsedTime = => #ns -> ms
			timer.difTime / 1000000

		makeWave = =>
			@toggle()
			if timer.elapsedTime() >= duration
				@off()
				timer.clearInterval()
				@events.emit "end"

		timer.setInterval makeWave, null, "#{high}u", =>