_ = require 'lodash'
Promise = require 'bluebird'

helfer = require '../src/helfer'

MyBrokenError = ->

MyError = ->
helfer.inherits MyError, Error

MyChildError = ->
helfer.inherits MyChildError, MyError

module.exports =

  'isError': (test) ->
    test.ok helfer.isError new Error
    test.ok helfer.isError new MyError
    test.ok helfer.isError new MyChildError

    test.ok helfer.isError new EvalError
    test.ok helfer.isError new RangeError
    test.ok helfer.isError new ReferenceError
    test.ok helfer.isError new SyntaxError
    test.ok helfer.isError new TypeError
    test.ok helfer.isError new URIError

    test.ok not (helfer.isError {})
    test.ok not (helfer.isError new MyBrokenError)
    test.ok not (helfer.isError 'error')

    test.done()

  'inherits':

    'can be used to construct error hierarchies':

      "that work well with Promise.catch": (test) ->
        error = new MyError
        childError = new MyChildError

        Promise.reject(error)
          .catch Error, (e) ->
            test.equal e, error

            Promise.reject(error)
          .catch MyError, (e) ->
            test.equal e, error

            Promise.reject(childError)
          .catch Error, (e) ->
            test.equal e, childError

            Promise.reject(childError)
          .catch MyError, (e) ->
            test.equal e, childError

            Promise.reject(childError)
          .catch MyChildError, (e) ->
            test.equal e, childError

            test.done()

      "without which Promise.catch doesn't work": (test) ->
        brokenError = new MyBrokenError
        Promise.reject(brokenError)
          .catch Error, (e) ->
            test.ok false
          .catch MyBrokenError, (e) ->
            test.ok false
          .error (e) ->
            test.equal e, brokenError
            test.done()

      "that work well with instanceof": (test) ->
        error = new MyError
        test.ok (error instanceof Error)

        childError = new MyChildError
        test.ok (childError instanceof Error)
        test.ok (childError instanceof MyError)

        test.done()

      "without which instanceof doesn't work": (test) ->
        brokenError = new MyBrokenError
        test.ok not (brokenError instanceof Error)
        test.done()
