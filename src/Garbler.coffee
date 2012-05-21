Garbler = @Garbler = {}

# Create a random number. You can plug in your own random number
# generator by overriding this function.
Garbler.random = -> Math.random()

# An abstraction of a range of characters.
Garbler.Range = class Range
	constructor: (@start, @end) ->

	# Expands the range into a string. E.g. A range from 'a' to 'f'
	# expands into 'abcdef'.
	expand: -> (asChar(code) for code in @getCodes()).join('')

	# Returns the range as an Array of character codes
	getCodes: -> [asCode(@start)..asCode(@end)]

# A set of unique characters.
Garbler.Set = class Set
	constructor: (o) ->
		@operations = []
		if o
			@addRange(o) if o.constructor is Range
			@operations = o.operations if o.constructor is Set
	addRange: (range) ->
		@operations.push({
			operation: 'add'
			type: 'range'
			start: range.start
			end: range.end
		})
		@
	removeRange: (range) ->
		@operations.push({
			operation: 'remove'
			type: 'range'
			start: range.start
			end: range.end
		})
		@
	toggleRange: (range) ->
		@operations.push({
			operation: 'toggle'
			type: 'range'
			start: range.start
			end: range.end
		})
		@
	addCharacters: (string) ->
		@operations.push({
			operation: 'add'
			type: 'characters'
			string: string
		})
		@
	removeCharacters: (string) ->
		@operations.push({
			operation: 'remove'
			type: 'characters'
			string: string
		})
		@
	toggleCharacters: (string) ->
		@operations.push({
			operation: 'toggle'
			type: 'characters'
			string: string
		})
		@
	expand: ->
		# Object that will be populated with the keyCodes that belong
		# to the set.
		codes = {}

		# Functions that operate on the 'codes' object.
		funcs =
			add: (code) -> codes[code] = true
			remove: (code) -> delete codes[code]
			toggle: (code) ->
				if codes[code] then funcs.remove(code)
				else funcs.add(code)

		range = (f, a, b) -> f(n) for n in [asCode(a)..asCode(b)]
		string = (f, str) -> f(asCode(char)) for char in str

		for op in @operations
			func = funcs[op.operation]
			if op.type is 'range' then range(func, op.start, op.end)
			if op.type is 'characters' then string(func, op.string)
		(asChar(code) for code, s of codes).join('')

# Create a random string
Garbler.create = (userOpts) ->
	# Combine with default options
	opts =
		length: 8
	opts[key] = value for key, value of userOpts

	results = []
	expandedSet = opts.set.expand()
	while (opts.length--)
		index = Math.floor(Garbler.random() * expandedSet.length)
		results.push(expandedSet[index])
	results.join('')

# Create multiple random strings
Garbler.createMany = (userOpts) ->
	results = []
	while (userOpts.amount--)
		results.push(Garbler.create(userOpts))
	results

asCode = (char) -> char.charCodeAt(0)
asChar = (n) -> String.fromCharCode(n)