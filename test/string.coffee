helfer = require '../src/helfer'

module.exports =

  'camelToSnake': (test) ->
    test.equal 'camel_case', helfer.camelToSnake('camelCase')
    test.done()

  'snakeToCamel': (test) ->
    test.equal 'snakeCase', helfer.snakeToCamel('snake_case')
    test.done()

  'camelToHyphen': (test) ->
    test.equal 'camel-case', helfer.camelToHyphen('camelCase')
    test.done()

  'hyphenToCamel': (test) ->
    test.equal 'hyphenDelimited', helfer.hyphenToCamel('hyphen-delimited')
    test.done()

  'colonToSnake': (test) ->
    test.equal 'colon_delimited', helfer.colonToSnake('colon:delimited')
    test.done()

  'snakeToColon': (test) ->
    test.equal 'snake:case', helfer.snakeToColon('snake_case')
    test.done()

  'hyphenColonToCamelSnake': (test) ->
    test.equal 'hyphen_colonTo_camelSnake', helfer.hyphenColonToCamelSnake('hyphen:colon-to:camel-snake')
    test.done()

  'camelSnakeToHyphenColon': (test) ->
    test.equal 'camel:snake-to:hyphen-colon', helfer.camelSnakeToHyphenColon('camel_snakeTo_hyphenColon')
    test.done()

  'splitCamelcase': (test) ->
    test.deepEqual [],
      helfer.splitCamelcase ''
    test.deepEqual ['a'],
      helfer.splitCamelcase 'a'
    test.deepEqual ['first'],
      helfer.splitCamelcase 'first'
    test.deepEqual ['first', 'where', 'id'],
      helfer.splitCamelcase 'firstWhereId'
    test.deepEqual ['a', 'one', 'a', 'two', 'a', 'three'],
      helfer.splitCamelcase 'aOneATwoAThree'
    test.deepEqual ['config_url', 'prefix'],
      helfer.splitCamelcase 'config_urlPrefix'
    test.deepEqual ['pages', 'order', 'by', 'created', 'at', 'desc'],
      helfer.splitCamelcase 'pagesOrderByCreatedAtDesc'

    test.done()

  'joinCamelcase': (test) ->
    test.equal '', helfer.joinCamelcase []
    test.equal 'a', helfer.joinCamelcase ['a']
    test.equal 'first', helfer.joinCamelcase ['first']
    test.equal 'firstWhereId', helfer.joinCamelcase ['first', 'where', 'id']

    test.done()

  'joinUnderscore': (test) ->
    test.equal '', helfer.joinUnderscore []
    test.equal 'first', helfer.joinUnderscore ['first']
    test.equal 'first_where_id', helfer.joinUnderscore ['first', 'where', 'id']

    test.done()
