path = require "path"
{makePromise} = require "faithful"

module.exports =
  cwd: path.resolve __dirname, "workingdir"
  containingDir: path.resolve __dirname, "../../"
  env: process.env
  log: (msg) ->
  inputs: ["someproject","something"]
  resolveValues: (names) ->
    makePromise (cb) ->
      obj = {}
      obj[name] = "random-value" for name in names
      cb null, obj