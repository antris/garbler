Garbler = @Garbler = {}

# Create a random number. You can plug in your own random number
# generator by overriding this function.
Garbler.random = -> Math.random()

# An abstraction of a range of characters.
Garbler.Range = class Range
	constructor: (@start, @end) ->
	expand: ->
		(String.fromCharCode(n) for n in @getCodes()).join('')
	getCodes: ->		
		start = @start.charCodeAt(0)
		end = @end.charCodeAt(0)
		[start..end]

# A set of unique characters.
Garbler.Set = class Set
	constructor: (o) ->
		@operations = []
		if o
			@addRange(o) if o.constructor is Range
			@operations = o.operations if o.constructor is Set
	addRange: (range) ->
		@operations.push({
			operation: 'addRange'
			start: range.start
			end: range.end
		})
		@
	removeRange: (range) ->
		@operations.push({
			operation: 'removeRange'
			start: range.start
			end: range.end
		})
		@
	toggleRange: (range) ->
		@operations.push({
			operation: 'toggleRange'
			start: range.start
			end: range.end
		})
		@
	addCharacters: (string) ->
		@operations.push({
			operation: 'addCharacters'
			string: string
		})
		@
	removeCharacters: (string) ->
		@operations.push({
			operation: 'removeCharacters'
			string: string
		})
		@
	toggleCharacters: (string) ->
		@operations.push({
			operation: 'toggleCharacters'
			string: string
		})
		@
	expand: ->
		codes = {}
		getCodes = Range::getCodes
		for op in @operations
			if op.start? and op.end?
				operableCodes = getCodes.apply({
					start: op.start
					end: op.end
				})
			switch op.operation
				when 'addRange'
					for code in operableCodes
						codes[code] = true
				when 'removeRange'		
					for code in operableCodes
						delete codes[code]
				when 'toggleRange'
					for code in operableCodes
						if codes[code] then delete codes[code]
						else codes[code] = true
				when 'addCharacters'
					for char in op.string
						code = char.charCodeAt(0)
						codes[code] = true
				when 'removeCharacters'
					for char in op.string
						code = char.charCodeAt(0)
						delete codes[code]
				when 'toggleCharacters'
					for char in op.string
						code = char.charCodeAt(0)
						if codes[code] then delete codes[code]
						else codes[code] = true
		(String.fromCharCode(n) for n, s of codes).join('')

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

# Create many random strings
Garbler.createMany = (userOpts) ->
	results = []
	while (userOpts.amount--)
		results.push(Garbler.create(userOpts))
	results