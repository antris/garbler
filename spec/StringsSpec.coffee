Strings = (require '../src/Strings.coffee').Strings

describe 'always', ->
	it 'should create a function that returns a given value', ->
		expect(Strings.always('abc')()).toBe('abc')

describe 'tryExec', ->
	it 'should evaluate a function', ->
		expect(Strings.tryExec(-> 'hello :)')).toBe('hello :)')
	it 'should return a primitive', ->
		expect(Strings.tryExec('hello again!')).toBe('hello again!')

describe 'range', ->
	it 'should give a range of characters', ->
		expect(Strings.range('a', 'f')).toBe('abcdef')

describe 'pull', ->
	it 'should return one character by default', ->
		expect(Strings.pull('a').length).toBe(1)
	it 'should return a character from the given range', ->
		range = Strings.range('a', 'z')
		randomCharacter = Strings.pull(range)
		expect(randomCharacter in range).toBeTruthy()
	it 'should return the given amount of characters', ->
		expect(Strings.pull('a', 5).length).toBe(5)