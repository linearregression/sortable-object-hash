test = require 'tape'

sortable = require '../'

test 'hash', (t) ->
  order =
    style: ['freestyle', 'compulsory']
    division: ['singles', 'doubles']

  hash = sortable(['style','division'], order)

  t.equal hash({style: 'freestyle', division: 'singles'}), '1x1'
  t.equal hash({style: 'freestyle', division: 'doubles'}), '1x2'
  t.equal hash({style: 'freestyle', division: 'doubles'}), '1x2'
  t.equal hash({style: 'none', division: 'singles'}), 'ox1'
  t.ok '1x1' < '1x2' < 'ox1'
  t.end()

test 'hex number', (t) ->
  order =
    c: 'abcdefghijklmno'.split('')
    n: '1234'.split('')

  hash = sortable(['c','n'], order)

  t.equal hash({c:'a', n:'1'}), '1x1'
  t.equal hash({c:'o', n:'4'}), 'fx4'
  t.ok '1x1' < 'fx4'
  t.end()

test 'expands hash for longer order', (t) ->
  order =
    c: 'abcdefghijklmnop'.split('')
    n: '1234'.split('')

  hash = sortable(['c','n'], order)

  t.equal hash({c:'a', n:'1'}), '01x1'
  t.equal hash({c:'d', n:'9'}), '04xo'
  t.equal hash({c:'p', n:'4'}), '10x4'
  t.ok '01x1' < '04xo' < '10x4'
  t.end()

test 'sort empty before', (t) ->
  order =
    c: 'abcdefghijklmnop'.split('')
    n: '1234'.split('')

  hash = sortable(['c','n'], order, {}, {empty: 'before'})

  t.equal hash({c:'a', n:'9'}), '01x0'
  t.equal hash({c:'a', n:'1'}), '01x1'
  t.equal hash({c:'d', n:'9'}), '04x0'
  t.ok '01x0' < '01x1' < '04x0'
  t.end()

test 'interpolates', (t) ->
  path = ['{key}.val','n']
  order =
    c: 'abcdefghijklmnopqr'.split('')
    n: '123456789'.split('')
  interpolated =
    x: 'xyz'.split('')

  hash = sortable(path, order, interpolated)

  t.equal hash({key:'x', val: ['x','z'], c:'a', n:'1'}), '13x1'
  t.equal hash({key:'x', val: ['x','y','z'], c:'a', n:'2'}), '123x2'
  t.end()
