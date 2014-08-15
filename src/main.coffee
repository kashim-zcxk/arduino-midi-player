require "./utils/include"

Led = include "devices/led"
Buzzer = include "devices/buzzer"
Melody = include "devices/buzzer/melody"

fs = require "fs"
MIDIFile = require "midifile"
NoteDictionary = include "devices/buzzer/noteDictionary"

board = include "board"
module.exports =

#------------------------------------------------------------------------------------------
blinkTheLed = -> new Led(13).blink 200

playHappyBirthday = ->
	buzz = new Buzzer 3

	happyBirthday = new Melody [
		{ note: "c6", length: 1/8 }
		{ note: null, length: 1/16 }
		{ note: "c6", length: 1/16 }
		{ note: "d6", length: 1/4 }
		{ note: "c6", length: 1/4 }
		{ note: "f6", length: 1/4 }
		{ note: "e6", length: 1/4 }
		{ note: null, length: 1/4 }
		{ note: "c6", length: 1/8 }
		{ note: null, length: 1/16 }
		{ note: "c6", length: 1/16 }
		{ note: "d6", length: 1/4 }
		{ note: "c6", length: 1/4 }
		{ note: "g6", length: 1/4 }
		{ note: "f6", length: 1/4 }
		{ note: null, length: 1/4 }
	], 120

	happyBirthday.events
		.on "start", -> console.log "start!"

	happyBirthday.events.on "note", (noteInfo) ->
		console.log "i'm playing a #{noteInfo.note} of #{noteInfo.length}"

	happyBirthday.events
		.on "end", -> console.log "end!"

	happyBirthday.playWith buzz

openMidi = ->
	buffer = fs.readFileSync "test.mid"

	toArrayBuffer = (buffer) ->
		ab = new ArrayBuffer buffer.length
		view = new Uint8Array ab

		for i in [0..buffer.length]
			view[i] = buffer[i]

		ab

	midiFile = new MIDIFile toArrayBuffer(buffer)

	notes = midiFile.getTrackEvents(0)
		.filter((event) -> event.type is 8 and event.subtype is 9)
		.map (event) -> { note: new NoteDictionary().noteNames()[event.param1], length: 1/4 }

	buzz = new Buzzer 3
	midiMelody = new Melody notes, 120

	midiMelody.events
		.on "start", -> console.log "start!"

	midiMelody.events.on "note", (noteInfo) ->
		console.log "i'm playing a #{noteInfo.note} of #{noteInfo.length}"

	midiMelody.events
		.on "end", -> console.log "end!"

	midiMelody.playWith buzz
	
	#Headers
	#console.log "format: #{midiFile.header.getFormat()}"
	#console.log "tracks: #{midiFile.header.getTracksCount()}"

	midiFile.getTrackEvents 0 #eventos del midi a reproducir

board.on "ready", ->
	console.log "Hello f*ckin' world :D"; debugger

	#blinkTheLed()
	#playHappyBirthday()
	openMidi()
#------------------------------------------------------------------------------------------