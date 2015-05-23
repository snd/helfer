# helfer

[![NPM Package](https://img.shields.io/npm/v/helfer.svg?style=flat)](https://www.npmjs.org/package/helfer)
[![Build Status](https://travis-ci.org/snd/helfer.svg?branch=master)](https://travis-ci.org/snd/helfer/branches)
[![Dependencies](https://david-dm.org/snd/helfer.svg)](https://david-dm.org/snd/helfer)

**useful helper functions**

> `helfer` is german for `helper`

a place for helper functions that are generic enough to be used in more than
one of my npm packages but specific enough not to be
present in utility libraries like [lodash](https://lodash.com/).
it aims to have no dependencies, which means that it must reimplement some lodash
functions (`findIndex` for example) that some `helfer` functions depend on.

at the moment it contains mostly [string](#string) and [array](#array) helpers.

[see a list of all functions below.](#string)

*this is a work in progress.
it is well tested but the API should not be considered stable.
for the moment i'll make breaking changes between versions without warning.
i might extract sets of functions into separate packages in the future.*

```
npm install helfer
```

```
bower install helfer
```

``` javascript
var helfer = require('helfer');
```

[lib/helfer.js](lib/helfer.js) supports [AMD](http://requirejs.org/docs/whyamd.html).  
if [AMD](http://requirejs.org/docs/whyamd.html) is not available it sets the global variable `helfer`.

also look at the [tests](test) (and [code](src/helfer.coffee)) for documentation.

### [string](test/string.coffee)

- `camelToSnake('camelCase')` -> `'camel_case'`
- `snakeToCamel('snake_case')` -> `'snakeCase'`
- `camelToHyphen('camelCase')` -> `'camel-case'`
- `hyphenToCamel('hyphen-delimited')` -> `'hyphenDelimited'`
- `colonToSnake('colon:delimited')` -> `'colon_delimited'`
- `snakeToColon('snake_case')` -> `'snake:case'`
- `hyphenColonToCamelSnake('hyphen:colon-to:camel-snake')` -> `'hyphen_colonTo_camelSnake'`
- `camelSnakeToHyphenColon('camel_snakeTo_hyphenColon')` -> `'camel:snake-to:hyphen-colon'`
- `uppercaseFirstLetter('foo')` -> `'Foo'`
- `lowercaseFirstLetter('FOO')` -> `'fOO'`
- `splitCamelcase('oneTwoThree')` -> `['one', 'two', 'three']`
- `joinCamelcase(['One', 'two', 'three'])` -> `'oneTwoThree'`
- `joinUnderscore(['one', 'two', 'three'])` -> `'one_two_three'`

### [array](test/array.coffee)

- `coerceToArray(array | value | null | undefined)` -> returns `arg` if it is an array. returns `[arg]` otherwise. returns `[]` if `arg` is `null` or `undefined`.
- `findIndex(array, predicate)` -> returns the index of the first `array` element for which `predicate` returns true. otherwise returns `-1`.
- `findIndexOfFirstObjectHavingProperty(objects, property)` returns the index of the first of `objects` for which `property` is not `undefined`. otherwise returns `-1`.

### [object](test/object.coffee)

- `inherits(constructor, superConstructor)` makes an object that has `superConstructor` as its prototype the prototype of `constructor` (portable).
  useful to create error hierarchies that can work with `bluebird.catch` and `helfer.isError`.

### [function](test/function.coffee)

- `parseFunctionArguments(function(a, b, c) {})` -> `['a', 'b', 'c']` the names of the functions arguments
- `identity(value)` -> returns `value`

### [predicate](test/predicate.coffee)

- `isObject(value)` -> returns boolean whether `value` is an object
- `isUndefined(value)` -> returns boolean whether `value` is `undefined`
- `isNull(value)` -> returns boolean whether `value` is `null`
- `isExisting(value)` -> returns boolean whether `value` is neither `null` nor `undefined`
- `isThenable(value)` -> returns boolean whether `value` is a thenable (promise)
- `isError(value)` -> returns boolean whether `value` is `instanceof Error`

## [license: MIT](LICENSE)
