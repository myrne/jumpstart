fs = require "fs"
fsExists = require "fs-exists"
readdir = require "recursive-readdir"
ncp = require "ncp"
easytable = require "easy-table"
Memoblock = require "memoblock"
faithful = require "faithful"
renames = require "./renames"
{union} = require "underscore"
_ = require "underscore"

{reduce,forEach,adapt,collect,map,applyEach,filter} = faithful
ncp = adapt ncp
readFile = adapt fs.readFile
writeFile = adapt fs.writeFile
fsExists = adapt fsExists
rename = adapt fs.rename
readdir = adapt readdir

module.exports = createProject = (targetDir, templateDir, config, resolveValues, log) ->
  Memoblock.do [
    -> @targetExists = fsExists targetDir
    -> throw new Error "Target directory #{targetDir} already exist." if @targetExists
    -> @paths = readdir templateDir
    -> @buffers = map @paths, readFile
    -> @varNamesArrays = @buffers.map (buffer) -> findPlaceholderNames buffer
    -> @varNames = _.union.apply {}, @varNamesArrays
    -> @values = makeValues @varNames, config.globals, targetDir
    -> @missingVarNames = (name for name, value of @values when value is null)
    -> @resolvedValues = resolveValues @missingVarNames
    -> @values[name] = value for name, value of @resolvedValues
    -> log printValues @values
    -> @copyingFiles = ncp templateDir, targetDir
    -> @targetPaths = readdir targetDir
    -> @replacements = ([new RegExp("---#{name}---","g"),value] for name, value of @values)
    -> @filePairs = map @targetPaths, (path) -> collect [path,readFile path]
    -> @filePairs = mapRight @filePairs, (buffer) -> buffer.toString()
    -> @filePairs = mapRight @filePairs, (contents) => @replacements.reduce replace, contents
    -> @writingFiles = applyEach @filePairs, writeFile
    -> @rpaths = filter Object.keys(renames), (path) -> fsExists "#{targetDir}/#{path}"
    -> @renamePairs = (["#{targetDir}/#{path}","#{targetDir}/#{renames[path]}"] for path in @rpaths)
    -> @renamingFiles = applyEach @renamePairs, rename
  ]

printValues = (values) ->
  """
  
  
  VALUES TO BE USED
  =================
  #{easytable.printObj sortValues values}
  """

mapRight = (pairs, iterator) ->
  [pair[0], iterator pair[1]] for pair in pairs

makeValues = (varNames, globals, targetDir) ->
  globals = {} unless globals
  values = {}
  for varName in varNames
    values[varName] = if globals[varName] then globals[varName] else null 
  values["target-dir"] = targetDir
  values["current-year"] = new Date().getFullYear()
  values

sortValues = (values) ->
  names = (name for name, value of values).sort()
  sortedValues = {}
  sortedValues[name] = values[name] for name in names
  sortedValues

findPlaceholderNames = (contents) ->
  return [] unless matches = contents.toString().match  /---([a-z]+(-[a-z]+)*)---/g
  return (match.substring 3,match.length-3 for match in matches)
  
replace = (string, replacement) ->
  string.replace replacement[0], replacement[1] 