require("mocha-as-promised")()

fs = require "fs"
faithful = require "faithful"
path = require "path"
fsExists = require "fs-exists"
fsExists = faithful.adapt fsExists
rimraf = require "rimraf"
rimraf = faithful.adapt rimraf
readFile = faithful.adapt require("fs").readFile
exec = require "faithful-exec"

assert = require "assert"
workingDir = path.resolve __dirname, "../fixtures/workingdir"
templateDir = path.resolve workingDir, "jumpstart-black-coffee/template"

existingDir = path.resolve workingDir, "existing-project"
expectedDir = path.resolve workingDir, "expected-project"
targetDir = path.resolve workingDir, "created-project"

config = require "../fixtures/global-config.json"

diffDirs = (dir1, dir2) ->
  exec "diff -r #{dir1} #{dir2}"

foundVarNames = []
getValues = (varNames) ->
  foundVarNames = varNames
  values = {} 
  values[name] = value for name,value of config.globals
  values['module-name'] = 'expected-module'
  values['module-description'] = 'The module that was expected.'
  values['current-year'] = "2013"
  faithful.return values

expectedVarNames =[ 'github-username', 'github-repos-path','module-name', 'module-description', 'module-is-private', 'github-ownername', 'commit-message', 'current-year', 'author-name', 'author-email', 'node-version', 'npm-version' ]

createProject = require "../lib/createProject"
describe "createProject", ->
  describe "when target directory already exists", ->
    it "fails", ->
      createProject(existingDir, templateDir, getValues)
        .then (->throw new Error "createProject should have failed."), (error) -> #expected
  describe "when template directory does not exist", ->
    it "fails", ->
      createProject(targetDir, templateDir + "abc", getValues)
        .then (->throw new Error "createProject should have failed."), (error) -> # expected
    
  describe "when all is good", ->
    before (next) ->
      fs.rename expectedDir + "/package.jumpstart.json", expectedDir + "/package.json", next
    result = createProject targetDir, templateDir, getValues
    it "copies files", ->
      result.then ->
        a = fsExists path.resolve targetDir, ".gitignore"
        b = fsExists path.resolve targetDir, "README.md"
        faithful.collect [a,b]
    it "finds all placeholders",  ->
      result.then -> assert.deepEqual expectedVarNames.sort(), foundVarNames.sort()
    it "results in right output", ->
      diffDirs(expectedDir, targetDir).then null, (err) ->
        # console.log err
        console.log err.stdout
        throw err
    after ->
      fs.renameSync expectedDir + "/package.json", expectedDir + "/package.jumpstart.json"
      rimraf targetDir