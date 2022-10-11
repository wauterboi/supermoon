-------------------------------------------------------------------------------
--  A library for working with table values
--  @module supermoon.table

-------------------------------------------------------------------------------
--  Performs a copy of all keyvalues. Table values are recursively copied.
--
--  As a consequence of the above, this function is slower than @{shallowcopy}
--  but creates "true" copies of data - mutations to the source table will not
--  affect the copy and vice versa.
--
--  @function deepcopy
--  @param x the table to copy
--  @return copy of the table
--  @see shallowcopy

deepcopy = (x) ->
  res = {}
  for key, value in pairs x
    res[key] = type(value) == "table" and deepcopy(value) or value
  res

-------------------------------------------------------------------------------
--  Create a table that only contains keyvalues that satisfy criteria
--  implemented by a callback. This should not be used for sequences. (see
--  @{filtersequence})
--
--  Due to the nature of Lua, it is best to create the callback outside of
--  any function bodies whenever possible to avoid needless recreation.
--
--  The callback should accept a table, key, and value. It should also return
--  `true` to add the keyvalue to the resulting table, or `false` to skip it.
--
--  @function filter
--  @param source the table to filter
--  @param callback the function used for filtering
--  @return the table of filtered keyvalues

filter = (source, callback) ->
  res = {}
  for key, value in pairs source
    if callback(source, key, value) then res[key] = value
  res

-------------------------------------------------------------------------------
--  Create a sequence that only contains values that satisfy criteria
--  implemented by a callback. Unlike @{filter}, this function iterates using
--  @{ipairs} and _appends_ values to a resulting table.
--
--  Due to the nature of Lua, it is best to create the callback outside of
--  any function bodies whenever possible to avoid needless recreation.
--
--  The callback should accept a table, key, and value. It should also return
--  `true` to append the value to the resulting table, or `false` to skip it.
--
--  @function filtersequence
--  @param source the table to filter
--  @param callback the function used for filtering
--  @return the table of filtered keyvalues
--  @return the filtered table length

filtersequence = (source, callback) ->
  res = {}
  length = 0
  for index, value in ipairs source
    if callback(source, index, value)
      length += 1
      res[length] = value
  res

-------------------------------------------------------------------------------
--  Determines if a given table is a proper sequence without intermediary `nil`
--  values.
--
--  This function exists because using `#` or @{ipairs} on a table with
--  intermediary `nil` values yields undefined results.
--
--  The solution relies on these properties:
--  * Empty tables are always proper sequences.
--  * In order for a table to be a proper sequence, there must be no integer
--  index between 1 and the length of the table associated with `nil`.
--  * @{pairs} is guaranteed to iterate through every keyvalue in the table,
--  just out of order.
--
--  Thus, we simply count the iterations and use the iteration count to index
--  the table. If at any point during the loop `nil` is encountered, we know
--  that the table is not a proper sequence.
--
--  @function issequential
--  @param x the table to check
--  @return[1] `true` (the table is a sequence)
--  @return[1] the length of the table
--  @return[2] `false` (the table is not a sequence)
--  @return[2] the index associated with a nil value

issequential = (x) ->
  length = 0
  for key, value in pairs x
    length += 1
    if x[length] == nil then return false, length
  return true, length

-------------------------------------------------------------------------------
--  Overwrite the keyvalues on the target table with the keyvalues from the
--  source tables. Tables values contained within any of the source tables
--  are not recursed.
--
--  If you do not wish to destroy data in any tables used as the source, you
--  may consider using an empty table as the first argument.
--
--  Furthermore, wrapping the call to @{merge} with a call to @{deepcopy}
--  effectively makes it a "deep merge", although one must remember that the
--  first argument is to @{merge} is still necessarily mutated.
--
--  This table will loop through all tables given as varargs. The varargs
--  should be treated as being organized in from least precedence to highest
--  precedence, as the last table is used to write the final values to the
--  table:
--
--    table.merge {a: 1, b: 2, c: 3}, {b: 4, c: 5}, {c: 6}
--    -- result: {a: 1, b: 4, c: 6}
--
--  @function merge
--  @param target the table to merge data into
--  @param ... tables to merge into x (ordered with increasing precedence)
--  @return the target table

merge = (target, ...) ->
  for index, tab in ipairs {...}
    for key, value in pairs tab
      target[key] = value
  target

-------------------------------------------------------------------------------
--  Performs a shallow copy of all keyvalues. Table values are not recursively
--  copied.
--
--  As a consequence of the above, table values will be shared between the
--  source table and its copy. This may be inappropriate in cases where
--  modifications should not be shared. In these cases, you will want to use
--  @{deepcopy}
--
--  @function shallowcopy
--  @param x the table to copy
--  @return copy of the table
--  @see deepcopy

shallowcopy = (x) ->
  {key, value for key, value in pairs x}

{
  :deepcopy
  :filter
  :filtersequence
  :issequential
  :merge
  :shallowcopy
}
