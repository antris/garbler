Strings = @Strings = {}

# Create a function that always returns the given value.
Strings.always = (value) -> -> value

# Create a random number. You can plug in your own random number
# generator by overriding this function.
Strings.random = -> Math.random()

# Evaluate or return.
Strings.tryExec = (arg) -> arg?() or arg

# Expand a range of characters.
# Example: Strings.range('a, 'f') -> 'abcdef'
Strings.range = (a, b) ->
	assertString(a, b)
	assert(a.length, 1)
	assert(b.length, 1)
	codeA = a.charCodeAt(0)
	codeB = b.charCodeAt(0)
	(String.fromCharCode(code) for code in [codeA..codeB]).join('')

# Pull random characters from the given list of characters.
Strings.pull = (range, amount = 1) ->
	assertString(range)
	assertNumber(amount)
	results = []
	while (amount--)
		index = 0 + Math.floor(Strings.random() * range.length)
		results.push(range[index])
	results.join('')

# Internals
error = (err) -> console.error new Error(err)
assertString = (args...) ->
	for arg in args
		error "#{arg} is not a string" unless typeof arg is 'string'
assertNumber = (args...) ->
	for arg in args
		error "#{arg} is not a number" unless typeof arg is 'number'
assert = (a, b) ->
	error "#{a} does not equal #{b}" unless a is b
assertRegExp = (str, re) ->
	error "#{str} does not match: #{re}" unless str.match(re)