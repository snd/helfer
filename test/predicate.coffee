Promise = require 'bluebird'
Q = require 'q'

helfer = require '../src/helfer'

module.exports =

  'isObject': (test) ->
    test.ok not helfer.isObject null
    test.ok not helfer.isObject undefined
    test.ok not helfer.isObject 0
    test.ok not helfer.isObject false
    test.ok not helfer.isObject ''
    test.ok helfer.isObject {}

    test.done()

  'isNull': (test) ->
    test.ok helfer.isNull null
    test.ok not helfer.isNull undefined
    test.ok not helfer.isNull 0
    test.ok not helfer.isNull false
    test.ok not helfer.isNull ''
    test.ok not helfer.isNull {}

    test.done()

  'isUndefined': (test) ->
    test.ok helfer.isUndefined undefined
    test.ok not helfer.isUndefined null
    test.ok not helfer.isUndefined 0
    test.ok not helfer.isUndefined false
    test.ok not helfer.isUndefined ''
    test.ok not helfer.isUndefined {}

    test.done()

  'isExisting': (test) ->
    test.ok not helfer.isExisting undefined
    test.ok not helfer.isExisting null
    test.ok helfer.isExisting false
    test.ok helfer.isExisting 0
    test.ok helfer.isExisting ''
    test.ok helfer.isExisting {}

    test.done()

  'isThenable': (test) ->
    test.ok not helfer.isThenable undefined
    test.ok not helfer.isThenable null
    test.ok not helfer.isThenable 0
    test.ok not helfer.isThenable false
    test.ok not helfer.isThenable ''
    test.ok not helfer.isThenable {}
    test.ok helfer.isThenable Q.delay('a', 100)
    test.ok helfer.isThenable Promise.resolve('a')

    test.done()
