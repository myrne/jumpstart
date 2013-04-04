optimist = require 'optimist'
jumpstart = require './jumpstart'
commander = require "commander"
async = require "async"

module.exports = 
  run: ->
    @runWith optimist.argv._

  runWith: (inputs) ->
    if inputs.length isnt 2
      console.log "Usage: jumpstart [project-name] [template-name]"
      process.exit 1
    targetDir = "#{process.cwd()}/#{inputs[0]}" 
    templateName = inputs[1]
    jumpstart.createProject targetDir, templateName, askForMissingValues, (err) ->
      throw err if err
      console.log "Created #{targetDir}."
      process.exit(0)

askForMissingValues = (missingVarNames, next) ->
  values = {}
  console.log ""
  console.log "Please provide missing placeholder values."
  console.log "=========================================="
  setValue = (varName, next) ->
    commander.prompt varName + ": ", (value) ->
      next null, values[varName] = value
  async.forEachSeries missingVarNames, setValue, (err) ->
    return next err if err
    return next null, values