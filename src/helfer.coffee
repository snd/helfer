((root, factory) ->
  # amd
  if ('function' is typeof define) and define.amd?
    define(factory)
  # nodejs
  else if exports?
    module.exports = factory()
  # other
  else
    root.helfer = factory()
)(this, ->
  helfer = {}

################################################################################
# string

  # camelToSnake('camelCase') -> 'camel_case'
  helfer.camelToSnake = (string) ->
    string.replace /([a-z][A-Z])/g, (m) -> m[0] + '_' + m[1].toLowerCase()

  # snakeToCamel('snake_case') -> 'snakeCase'
  helfer.snakeToCamel = (string) ->
    string.replace /_([a-z])/g, (m) -> m[1].toUpperCase()

  # camelToHyphen('camelCase') -> 'camel-case'
  helfer.camelToHyphen = (string) ->
    string.replace /([a-z][A-Z])/g, (m) -> m[0] + '-' + m[1].toLowerCase()

  # hyphenToCamel('hyphen-delimited') -> 'hyphenDelimited'
  helfer.hyphenToCamel = (string) ->
    string.replace /-([a-z])/g, (m) -> m[1].toUpperCase()

  # colonToSnake('colon:delimited') -> 'colon_delimited'
  helfer.colonToSnake = (string) ->
    string.replace /:/g, '_'

  # snakeToColon('snake_case') -> 'snake:case'
  helfer.snakeToColon = (string) ->
    string.replace /_/g, ':'

  # hyphenColonToCamelSnake('hyphen:colon-to:camel-snake') -> 'hyphen_colonTo_camelSnake'
  helfer.hyphenColonToCamelSnake = (string) ->
    helfer.hyphenToCamel(helfer.colonToSnake(string))

  # camelSnakeToHyphenColon('camel_snakeTo_hyphenColon') -> 'camel:snake-to:hyphen-colon'
  helfer.camelSnakeToHyphenColon = (string) ->
    helfer.camelToHyphen(helfer.snakeToColon(string))

  # uppercaseFirstLetter('foo') -> 'Foo'
  helfer.uppercaseFirstLetter = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  # lowercaseFirstLetter('FOO') -> 'fOO'
  helfer.lowercaseFirstLetter = (string) ->
    string.charAt(0).toLowerCase() + string.slice(1)

  # splitCamelcase('oneTwoThree') -> ['one', 'two', 'three']
  helfer.splitCamelcase = (string) ->
    string.match(/([A-Z]?[^A-Z]*)/g).slice(0,-1).map (x) ->
      x.toLowerCase()

  # joinCamelcase(['One', 'two', 'three']) -> 'oneTwoThree'
  helfer.joinCamelcase = (array) ->
    capitalize = (string) ->
      helfer.uppercaseFirstLetter string.toLowerCase()
    helfer.lowercaseFirstLetter array.map(capitalize).join('')

  # splitUnderscore('one_two_three') -> ['one', 'two', 'three']
  helfer.splitUnderscore = (string) ->
    if string is ''
      return []
    string.split('_')

  # joinUnderscore(['one', 'two', 'three']) -> 'one_two_three'
  helfer.joinUnderscore = (array) ->
    array.join('_')

  # splitUppercaseUnderscore('ONE_TWO_THREE') -> ['one', 'two', 'three']
  helfer.splitUppercaseUnderscore = (string) ->
    if string is ''
      return []
    string.split('_').map (x) -> x.toLowerCase()

  # joinUppercaseUnderscore(['one', 'two', 'three']) -> 'ONE_TWO_THREE'
  helfer.joinUppercaseUnderscore = (array) ->
    array.map((x) -> x.toUpperCase()).join('_')

################################################################################
# array

  # coerces `arg` into an array.
  #
  # returns `arg` if it is an array.
  # returns `[arg]` otherwise.
  # returns `[]` if `arg` is null.
  #
  # example:
  # coerceToArray 'a'
  # => ['a']

  helfer.coerceToArray = (arg) ->
    if Array.isArray arg
      return arg
    unless arg?
      return []
    [arg]

  # returns the index of the first array element for which predicate returns true
  # otherwise returns -1
  helfer.findIndex = (array, predicate) ->
    index = -1
    length = array.length
    while ++index < length
      if predicate array[index]
          return index
    return -1

  helfer.findIndexWhereProperty = (objects, property) ->
    helfer.findIndex objects, (object) ->
      helfer.isObject(object) and (not helfer.isUndefined object[property])

  helfer.findIndexWhereSequence = (array, sequence) ->
    if sequence.length is 0
      return -1

    matchingSequenceIndex = -1

    index = -1
    length = array.length
    while ++index < length
      # matching so far
      if matchingSequenceIndex isnt -1
        matchingSequenceIndex++

        # complete match
        if matchingSequenceIndex is sequence.length
          return index - matchingSequenceIndex

        # no longer matching
        if array[index] isnt sequence[matchingSequenceIndex]
          matchingSequenceIndex = -1

        # otherwise still matching

      else
        # just started matching
        # TODO careful here with null values
        if array[index] is sequence[0]
          # single element sequence
          if sequence.length is 1
            return index
          matchingSequenceIndex = 0

    # was still matching at the end
    if matchingSequenceIndex isnt -1 and matchingSequenceIndex + 1 is sequence.length
      return index - sequence.length

    return -1

  # split array into two parts:
  # the first part contains all elements up to (but not including)
  # the first element for which predicate returned true.
  # the second part contains all elements from (and including)
  # the first element for which preducate returned true.
  helfer.splitArrayWhere = (array, predicate) ->
    index = helfer.findIndex array, predicate
    if index is -1
      return [array, []]
    [array.slice(0, index), array.slice(index)]

  helfer.splitArrayWhereSequence = (array, value) ->
    sequence = helfer.coerceToArray value
    results = []
    rest = array

    while true
      index = helfer.findIndexWhereSequence rest, sequence
      # no more matches
      if index is -1
        results.push rest
        return results
      # another match
      else
        results.push rest.slice(0, index)
        rest = rest.slice(index + sequence.length)

  helfer.reverseIndex = (index) ->
    reverseIndex = {}
    Object.keys(index).forEach (key) ->
      value = index[key]
      unless 'string' is typeof value
        throw Error 'all keys in index must map to a string'
      reverseIndex[value] ?= []
      reverseIndex[value].push key
    return reverseIndex

################################################################################
# object

  helfer.inherits = (constructor, superConstructor) ->
    if 'function' is typeof Object.create
      constructor.prototype = Object.create(superConstructor.prototype)
      constructor.prototype.constructor = constructor
    else
      # if there is no Object.create we use a proxyConstructor
      # to make a new object that has superConstructor as its prototype
      # and make it the prototype of constructor
      proxyConstructor = ->
      proxyConstructor.prototype = superConstructor.prototype
      constructor.prototype = new proxyConstructor
      constructor.prototype.constructor = constructor

################################################################################
# function

  # example:
  # parseFunctionArguments (a, b, c) ->
  # => ['a', 'b', 'c']

  helfer.parseFunctionArguments = (fun) ->
    unless 'function' is typeof fun
      throw new Error 'argument must be a function'

    string = fun.toString()

    argumentPart = string.slice(string.indexOf('(') + 1, string.indexOf(')'))

    return argumentPart.match(/([^\s,]+)/g) or []

  helfer.identity = (x) ->
    x

################################################################################
# predicate

  helfer.isObject = (x) ->
    x is Object(x)

  helfer.isUndefined =  (x) ->
    'undefined' is typeof x

  helfer.isNull = (x) ->
    null is x

  helfer.isExisting = (x) ->
    x?

  helfer.isThenable = (x) ->
    helfer.isObject(x) and 'function' is typeof x.then

  helfer.isError = (x) ->
    x instanceof Error

################################################################################
# return

  return helfer
)
