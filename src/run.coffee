runWith = require "./runWith"

module.exports = run = ->
  runWith(require("./cliOptions"))
    .then ->
      process.exit 0
    .then null, (error) ->
      console.error error.message
      process.exit 1