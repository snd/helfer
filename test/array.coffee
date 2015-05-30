helfer = require '../src/helfer'

module.exports =

  'coerceToArray': (test) ->
    test.deepEqual [], helfer.coerceToArray []
    test.deepEqual [1, 2, 3], helfer.coerceToArray [1, 2, 3]
    test.deepEqual [1], helfer.coerceToArray 1
    test.deepEqual [], helfer.coerceToArray null
    test.done()

  'findIndex': (test) ->
    test.equal -1, helfer.findIndex [], -> true
    test.equal 0, helfer.findIndex [1], (x) -> x is 1
    test.equal -1, helfer.findIndex [1], (x) -> x is 2
    test.equal 1, helfer.findIndex [1, 2, 3], (x) -> x > 1
    test.equal -1, helfer.findIndex [1, 2, 3], (x) -> x > 3

    test.done()

  'findIndexWhereProperty': (test) ->
    test.equals -1, helfer.findIndexWhereProperty(
      []
      'a'
    )
    test.equals -1, helfer.findIndexWhereProperty(
      [{}, {}, {b: 'b'}]
      'a'
    )
    test.equals 0, helfer.findIndexWhereProperty(
      [{a: 'a'}, {}, {b: 'b'}]
      'a'
    )
    test.equals -1, helfer.findIndexWhereProperty(
      [{a: undefined}, {}, {b: 'b'}]
      'a'
    )
    test.equals 3, helfer.findIndexWhereProperty(
      [{}, {}, {b: 'b'}, {a: null}]
      'a'
    )
    test.done()

  'splitArrayWhere': (test) ->
    test.deepEqual [[], []],
      helfer.splitArrayWhere [], -> true
    test.deepEqual [[], [1, 2, 3]],
      helfer.splitArrayWhere [1, 2, 3], -> true
    test.deepEqual [[1, 2, 3], []],
      helfer.splitArrayWhere [1, 2, 3], -> false
    test.deepEqual [[1], [2, 3]],
      helfer.splitArrayWhere [1, 2, 3], (x) -> x is 2

    test.done()

  'findIndexWhereSequence': (test) ->
    test.equal -1, helfer.findIndexWhereSequence [], []
    test.equal -1, helfer.findIndexWhereSequence [], ['where']
    test.equal -1, helfer.findIndexWhereSequence ['first'], []

    test.equal 0, helfer.findIndexWhereSequence ['where'], ['where']
    test.equal -1, helfer.findIndexWhereSequence ['first'], ['where']
    test.equal -1, helfer.findIndexWhereSequence ['first', 'order', 'report'], ['where']
    test.equal 3, helfer.findIndexWhereSequence ['first', 'order', 'report', 'where'], ['where']
    test.equal 1, helfer.findIndexWhereSequence ['first', 'where', 'created', 'at'], ['where']
    test.equal 2, helfer.findIndexWhereSequence ['first', 'order', 'where', 'created', 'at', 'where'], ['where']
    test.equal 4, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['where']

    test.equal 0, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['first']
    test.equal 0, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['first', 'order']
    test.equal 0, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['first', 'order', 'report']
    test.equal 1, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['order', 'report', 'log']
    test.equal 2, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['report', 'log', 'where']
    test.equal 3, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['log', 'where', 'created', 'at']
    test.equal 4, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['where', 'created', 'at', 'where']

    test.equal 5, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['created', 'at', 'where', 'id']
    test.equal 6, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['at', 'where', 'id']
    test.equal 7, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['where', 'id']

    test.equal 8, helfer.findIndexWhereSequence ['first', 'order', 'report', 'log', 'where', 'created', 'at', 'where', 'id'], ['id']

    test.equal 6, helfer.findIndexWhereSequence ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc', 'order', 'by', 'order'], ['order', 'by']
    test.equal 3, helfer.findIndexWhereSequence ['created', 'at', 'desc', 'order', 'by', 'order'], ['order', 'by']
    test.equal -1, helfer.findIndexWhereSequence ['order'], ['order', 'by']

    test.done()

  'splitArrayWhereSequence': (test) ->
    test.deepEqual [[]],
      helfer.splitArrayWhereSequence [], 'where'
    test.deepEqual [[], []],
      helfer.splitArrayWhereSequence ['where'], 'where'
    test.deepEqual [['first']],
      helfer.splitArrayWhereSequence ['first'], 'where'
    test.deepEqual [['first', 'order', 'report']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report'], 'where'
    test.deepEqual [['first', 'order', 'report'], []],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where'], 'where'
    test.deepEqual [['first', 'order', 'report'], ['created', 'at']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'created', 'at'], 'where'
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], []],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'created', 'at', 'where'], 'where'
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], ['id']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'created', 'at', 'where', 'id'], 'where'

    test.deepEqual [[]],
      helfer.splitArrayWhereSequence [], []
    test.deepEqual [[]],
      helfer.splitArrayWhereSequence [], ['where']
    test.deepEqual [[], []],
      helfer.splitArrayWhereSequence ['where'], ['where']
    test.deepEqual [['first']],
      helfer.splitArrayWhereSequence ['first'], ['where']
    test.deepEqual [['first', 'order', 'report']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report'], ['where']
    test.deepEqual [['first', 'order', 'report'], []],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where'], ['where']
    test.deepEqual [['first', 'order', 'report'], ['created', 'at']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'created', 'at'], ['where']
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], []],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'created', 'at', 'where'], ['where']
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], ['id']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'created', 'at', 'where', 'id'], ['where']

    test.deepEqual [[]],
      helfer.splitArrayWhereSequence [], []
    test.deepEqual [[]],
      helfer.splitArrayWhereSequence [], ['order', 'by']
    test.deepEqual [[], []],
      helfer.splitArrayWhereSequence ['order', 'by'], ['order', 'by']
    test.deepEqual [['first']],
      helfer.splitArrayWhereSequence ['first'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'order', 'id'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], []],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], ['created', 'at', 'desc']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], ['created', 'at', 'desc'], ['count', 'asc']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc', 'order', 'by', 'count', 'asc'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], ['created', 'at', 'desc'], ['order']],
      helfer.splitArrayWhereSequence ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc', 'order', 'by', 'order'], ['order', 'by']

    test.deepEqual [[], []],
      helfer.splitArrayWhereSequence ['table'], ['table']
    test.deepEqual [['user'], []],
      helfer.splitArrayWhereSequence ['user', 'table'], ['table']
    test.deepEqual [['project', 'message'], []],
      helfer.splitArrayWhereSequence ['project', 'message', 'table'], ['table']
    test.deepEqual [['project', 'message'], ['garbage']],
      helfer.splitArrayWhereSequence ['project', 'message', 'table', 'garbage'], ['table']
    test.deepEqual [['project', 'message'], ['garbage'], []],
      helfer.splitArrayWhereSequence ['project', 'message', 'table', 'garbage', 'table'], ['table']
    test.deepEqual [['project', 'message'], ['garbage'], ['more', 'garbage']],
      helfer.splitArrayWhereSequence ['project', 'message', 'table', 'garbage', 'table', 'more', 'garbage'], ['table']

    test.done()

  'reverseIndex': (test) ->
    test.deepEqual {},
      helfer.reverseIndex {}
    test.throws ->
      helfer.reverseIndex {a: null}
    test.deepEqual {b: ['a']},
      helfer.reverseIndex {a: 'b'}
    test.deepEqual {b: ['a', 'c']},
      helfer.reverseIndex {a: 'b', c: 'b'}
    test.deepEqual {b: ['a', 'c', 'f'], e: ['d', 'i'], h: ['g']},
      helfer.reverseIndex {a: 'b', c: 'b', d: 'e', f: 'b', g: 'h', i: 'e'}
    test.done()

  'arrayOfStringsHasDuplicates': (test) ->
    test.ok not helfer.arrayOfStringsHasDuplicates []
    test.ok not helfer.arrayOfStringsHasDuplicates ['a']
    test.ok not helfer.arrayOfStringsHasDuplicates ['a', 'b']
    test.ok not helfer.arrayOfStringsHasDuplicates ['a', 'b', 'c']
    test.ok helfer.arrayOfStringsHasDuplicates ['a', 'a']
    test.ok helfer.arrayOfStringsHasDuplicates ['a', 'a', 'b']
    test.ok helfer.arrayOfStringsHasDuplicates ['b', 'a', 'b']
    test.ok helfer.arrayOfStringsHasDuplicates ['a', 'b', 'b']
    test.done()
