runWith = require "./runWith"

module.exports = run = ->
  runWith(require("./cliOptions"))
    .then ->
      process.exit 0
    .then null, (error) ->
      console.error error.message
      process.exit 1

# setDefault = (name, value) ->
#   getConfig(config).then (config) ->
#     config.defaults[name] = value
#     writeConfig config, next
# 
# writeConfig = (config) ->
#   @findConfigFilePath.then (path) ->
#     @log "Writing config to #{path}."
#     writeFile path, JSON.stringify config