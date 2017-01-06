faithful = require "faithful"
optimist = require 'optimist'
path = require "path"
prompt = require "prompt"
prompt.message = ""
prompt.delimiter = ": "
promptGet = faithful.adapt prompt.get

module.exports =
  cwd: process.cwd()
  env: process.env
  inputs: optimist.argv._
  containingDir: path.resolve(__dirname, "../../")
  log: console.log.bind console
  resolveValues: (varNames, globals) ->
    console.log ""
    console.log "Please enter the missing values for the placeholders."
    console.log "====================================================="
    promptGet varNames