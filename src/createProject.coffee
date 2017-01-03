fs = require "fs"
fsExists = require "fs-exists"
{getFiles} = require "explorer"
faithful = require "faithful"
mkdirp = require "mkdirp"
_ = require "underscore"
getDirname = require("path").dirname
Bluebird = require "bluebird"


renames = require "./renames"

{reduce,each,adapt,collect,map,applyEach,filter} = faithful

readFile = adapt fs.readFile
writeFile = adapt fs.writeFile
fsExists = adapt fsExists
rename = adapt fs.rename
getFiles = adapt getFiles
mkdirp = adapt mkdirp

module.exports = createProject = Bluebird.coroutine (targetDir, templateDir, getValues) ->
  targetExists = yield fsExists targetDir
  throw new Error "Target directory #{targetDir} already exist." if targetExists
  paths = yield getFiles templateDir
  buffers = yield map paths, readFile
  contents = buffers.map (buffer) -> buffer.toString()
  varNamesArrays = buffers.map (buffer) -> findPlaceholderNames buffer
  varNames = _.union.apply {}, varNamesArrays
  values = yield getValues varNames
  targetPaths = paths.map (path) -> path.replace templateDir, targetDir
  replacements = ([new RegExp("---#{n}---","g"),v] for n,v of values)
  newContents = contents.map (contents) => replacements.reduce replace, contents
  targetDirs = _.unique targetPaths.map getDirname
  yield each targetDirs, mkdirp
  yield applyEach _.zip(targetPaths,newContents), writeFile
  rPaths = yield filter Object.keys(renames), (path) -> fsExists "#{targetDir}/#{path}"
  renamePairs = (["#{targetDir}/#{path}","#{targetDir}/#{renames[path]}"] for path in rPaths)
  yield applyEach renamePairs, rename
  return {targetPaths: targetPaths}

replace = (string, [search,replace]) ->
  string.replace search, replace

findPlaceholderNames = (contents) ->
  return [] unless matches = contents.toString().match  /---([a-z]+(-[a-z]+)*)---/g
  return (match.substring 3,match.length-3 for match in matches)