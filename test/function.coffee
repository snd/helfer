helfer = require '../src/helfer'

module.exports =

  'parseFunctionArguments': (test) ->
    try
      helfer.parseFunctionArguments 0
    catch err
      test.equal err.message, 'argument must be a function'
    test.deepEqual [], helfer.parseFunctionArguments ->
    test.deepEqual ['first'],
      helfer.parseFunctionArguments (first) ->
    test.deepEqual ['first', 'second'],
      helfer.parseFunctionArguments (first, second) ->
    test.deepEqual ['first', 'second', 'third'],
      helfer.parseFunctionArguments (first, second, third) ->
    test.done()
