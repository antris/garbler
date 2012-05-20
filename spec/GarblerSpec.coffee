Garbler = (require '../src/Garbler.coffee').Garbler

describe 'Range', ->
	describe 'expand', ->
		it 'should convert the range into a string', ->
			range = new Garbler.Range('a', 'f')
			expect(range.expand()).toBe('abcdef')

		it 'should be able to be run backwards', ->
			range = new Garbler.Range('f', 'a')
			expect(range.expand()).toBe('fedcba')

describe 'Set', ->
	it 'should be constructable from a Range', ->
		range = new Garbler.Range('a', 'f')
		set = new Garbler.Set(range)
		expect(set.expand()).toBe('abcdef')

	it 'should be constructable from another Set', ->
		range = new Garbler.Range('a', 'f')
		set1 = new Garbler.Set(range)
		set2 = new Garbler.Set(set1)
		expect(set1.expand()).toBe(set2.expand())

	describe 'expand', ->
		it 'should convert the Set into a string', ->
			range = new Garbler.Range('a', 'f')
			set = new Garbler.Set(range)
			expect(set.expand()).toBe('abcdef')

	describe 'addRange', ->
		it 'should add Ranges to Set', ->
			range1 = new Garbler.Range('a', 'c')
			range2 = new Garbler.Range('x', 'z')
			set = new Garbler.Set()
				.addRange(range1)
				.addRange(range2)
			expect(set.expand()).toBe('abcxyz')

	describe 'removeRange', ->
		it 'should remove Ranges from Set', ->
			range = new Garbler.Range('a', 'f')
			subrange = new Garbler.Range('b', 'd')
			set = new Garbler.Set()
				.addRange(range)
				.removeRange(subrange)
			expect(set.expand()).toBe('aef')

	describe 'toggleRange', ->
		it 'should toggle Ranges in Set', ->
			range1 = new Garbler.Range('a', 'f')
			range2 = new Garbler.Range('f', 'i')
			set = new Garbler.Set()
				.addRange(range1)
				.toggleRange(range2)
			expect(set.expand()).toBe('abcdeghi')

	describe 'addCharacters', ->
		it 'should add given characters to Set', ->
			set = new Garbler.Set().addCharacters('coffee')
			# Note, that the order is never preserved in a Set, and
			# that duplicates are not possible either. That's why we
			# get 'cefo', which is all the unique characters in
			# 'coffee', in the character code order.
			expect(set.expand()).toBe('cefo')

	describe 'removeCharacters', ->
		it 'should remove given characters from Set', ->
			set = new Garbler.Set()
				.addCharacters('coffee')
				.removeCharacters('script')
			expect(set.expand()).toBe('efo')

	describe 'toggleCharacters', ->
		it 'should toggle given characters in Set', ->
			set = new Garbler.Set().addCharacters('coffee')
			expect(set.expand()).toBe('cefo')
			set.toggleCharacters('scripts')
			# Note, that 's' is toggled twice.
			expect(set.expand()).toBe('efioprt')

describe 'create', ->
	it 'should create a string with a given Set and length', ->
		string = Garbler.create({
			set: new Garbler.Set().addCharacters('abc')
			length: 10
		})
		expect(typeof string).toBe('string')
		expect(string).toMatch(/^[abc]{10}$/)

describe 'createMany', ->
	it 'should create many strings', ->
		strings = Garbler.createMany({
			set: new Garbler.Set().addCharacters('xyz')
			length: 5
			amount: 10
		})
		expect(strings.constructor).toBe(Array)
		expect(strings.length).toBe(10)