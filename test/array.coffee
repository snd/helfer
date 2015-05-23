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

  'findIndexOfFirstObjectHavingProperty': (test) ->
    test.equals -1, helfer.findIndexOfFirstObjectHavingProperty(
      []
      'a'
    )
    test.equals -1, helfer.findIndexOfFirstObjectHavingProperty(
      [{}, {}, {b: 'b'}]
      'a'
    )
    test.equals 0, helfer.findIndexOfFirstObjectHavingProperty(
      [{a: 'a'}, {}, {b: 'b'}]
      'a'
    )
    test.equals -1, helfer.findIndexOfFirstObjectHavingProperty(
      [{a: undefined}, {}, {b: 'b'}]
      'a'
    )
    test.equals 3, helfer.findIndexOfFirstObjectHavingProperty(
      [{}, {}, {b: 'b'}, {a: null}]
      'a'
    )
    test.done()

  'splitArray': (test) ->
    test.deepEqual [[]],
      helfer.splitArray [], 'where'
    test.deepEqual [[], []],
      helfer.splitArray ['where'], 'where'
    test.deepEqual [['first']],
      helfer.splitArray ['first'], 'where'
    test.deepEqual [['first', 'order', 'report']],
      helfer.splitArray ['first', 'order', 'report'], 'where'
    test.deepEqual [['first', 'order', 'report'], []],
      helfer.splitArray ['first', 'order', 'report', 'where'], 'where'
    test.deepEqual [['first', 'order', 'report'], ['created', 'at']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'created', 'at'], 'where'
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], []],
      helfer.splitArray ['first', 'order', 'report', 'where', 'created', 'at', 'where'], 'where'
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], ['id']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'created', 'at', 'where', 'id'], 'where'

    test.deepEqual [[]],
      helfer.splitArray [], []
    test.deepEqual [[]],
      helfer.splitArray [], ['where']
    test.deepEqual [[], []],
      helfer.splitArray ['where'], ['where']
    test.deepEqual [['first']],
      helfer.splitArray ['first'], ['where']
    test.deepEqual [['first', 'order', 'report']],
      helfer.splitArray ['first', 'order', 'report'], ['where']
    test.deepEqual [['first', 'order', 'report'], []],
      helfer.splitArray ['first', 'order', 'report', 'where'], ['where']
    test.deepEqual [['first', 'order', 'report'], ['created', 'at']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'created', 'at'], ['where']
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], []],
      helfer.splitArray ['first', 'order', 'report', 'where', 'created', 'at', 'where'], ['where']
    test.deepEqual [['first', 'order', 'report'], ['created', 'at'], ['id']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'created', 'at', 'where', 'id'], ['where']

    test.deepEqual [[]],
      helfer.splitArray [], []
    test.deepEqual [[]],
      helfer.splitArray [], ['order', 'by']
    test.deepEqual [[], []],
      helfer.splitArray ['order', 'by'], ['order', 'by']
    test.deepEqual [['first']],
      helfer.splitArray ['first'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report']],
      helfer.splitArray ['first', 'order', 'report'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'order', 'id'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], []],
      helfer.splitArray ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], ['created', 'at', 'desc']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], ['created', 'at', 'desc'], ['count', 'asc']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc', 'order', 'by', 'count', 'asc'], ['order', 'by']
    test.deepEqual [['first', 'order', 'report', 'where', 'order', 'id'], ['created', 'at', 'desc'], ['order']],
      helfer.splitArray ['first', 'order', 'report', 'where', 'order', 'id', 'order', 'by', 'created', 'at', 'desc', 'order', 'by', 'order'], ['order', 'by']

    test.done()

  'splitWith': (test) ->
    test.deepEqual [[], []],
      helfer.splitWith [], -> true
    test.deepEqual [[], [1, 2, 3]],
      helfer.splitWith [1, 2, 3], -> true
    test.deepEqual [[1, 2, 3], []],
      helfer.splitWith [1, 2, 3], -> false
    test.deepEqual [[1], [2, 3]],
      helfer.splitWith [1, 2, 3], (x) -> x is 2

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
