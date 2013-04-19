faithful = require "faithful"
optimist = require 'optimist'
commander = require "commander"
faithful = require "faithful"
path = require "path"

module.exports = 
  cwd: process.cwd()
  env: process.env
  inputs: optimist.argv._
  containingDir: path.resolve(__dirname, "../../")
  log: console.log.bind console
  resolveValues: (missingVarNames) ->
    console.log ""
    console.log "Please provide missing placeholder values."
    console.log "=========================================="
    setValue = (values, varName) ->
      faithful.makePromise (resolve) ->
        commander.prompt "#{varName}: ", (value) ->
          values[varName] = value
          resolve values
    faithful.reduce missingVarNames, {}, setValue