# `originalElements` should be an array of objects.
# Each object will be given a _code word_.
# The code words will use the `alphabet` provided.
#
# Shorter _code word_ for the first ones in iteration order.
# Longest with last characters from alphabet to the last ones in iteration order.
# 
# The functions runs `callback(element, codeWord)` for each object in `originalElements` and returns
# `undefined`.
#
# For alphabet [a, b, c] elements will be given code words in order:
# a, b, c, aa, ab, ac, ba, ... cccccc*

{ getPref }               = require 'prefs'

exports.addSimpleCodeWordsTo = (originalElements, {alphabet}, callback) ->
  unless typeof(alphabet) == 'string'
    throw new TypeError('`alphabet` must be provided and be a string.')

  nonUnique = /([\s\S])[\s\S]*\1/.exec(alphabet)
  if nonUnique
    throw new Error("`alphabet` must consist of unique letters. Found '#{nonUnique[1]}' more than once.")

  if alphabet.length < 1
    throw new Error('`alphabet` must consist of at least 1 character.')

  unless typeof(callback) == "function"
    throw new TypeError "`callback` must be provided and be a function."


  if getPref('hints_bloom_on')
    elements = originalElements[..]
    elements.sort((a, b) -> b.weight - a.weight)
  else
    elements = originalElements

  last_word = ''
  for el in elements
    last_word = genCodeWord(alphabet, last_word)
    callback(el, last_word)

  return

genCodeWord = (alphabet, previous) ->
  if previous == undefined or previous.length == 0
    return alphabet[0]
  lastChar = previous.slice(-1)
  prefix = previous.slice(0, -1)
  newidx = alphabet.indexOf( lastChar ) + 1
  if newidx < alphabet.length
    return prefix + alphabet[newidx]
  return genCodeWord(alphabet, prefix) + alphabet[0]

