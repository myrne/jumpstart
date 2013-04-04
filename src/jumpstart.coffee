fs = require "fs"
async = require "async"

ProjectCreator = require "./project_creator"

module.exports = jumpstart =
  createProject: (targetDir, templateDir, resolveValues, next) ->
    @getConfig (err, config) =>
      projectCreator = new ProjectCreator config, resolveValues
      projectCreator.createProject targetDir, templateDir, next
      
  findConfigFilePath: (next) ->
    paths = ("#{containerDir}/.jumpstart.json" for containerDir in [process.cwd(),process.env.HOME])
    async.detect paths, fs.exists, (path) ->
      return next new Error "Cannot find config file." unless path
      return next null, path
  
  getConfig: (next) ->
    @findConfigFilePath (err, path) =>
      return next err if err
      @log "Using config file #{path}."      
      return next null, require path
  
  setDefault: (name, value, next) ->
    getConfig (err, config) =>
      return next err if err
      config.defaults[name] = value
      writeConfig config, next
  
  findConfigFilePath: (next) ->
    paths = ("#{containerDir}/.jumpstart.json" for containerDir in [process.cwd(),process.env.HOME])
    async.detectSeries paths, fs.exists, (path) ->
      return next new Error "Cannot find config file." unless path
      return next null, path
  
  writeConfig: (config, next) ->
    @findConfigFilePath (err, path) =>
      return next err if err
      @log "Writing config to #{path}."
      return fs.writeFile path, JSON.stringify(config), next
  
  log: (msg) ->
    console.log msg