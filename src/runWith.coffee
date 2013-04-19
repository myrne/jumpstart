optimist = require 'optimist'
commander = require "commander"
faithful = require "faithful"
Memoblock = require "Memoblock"
fsExists = require "fs-exists"
fsExists = faithful.adapt fsExists

createProject = require "./createProject"

logg = undefined
module.exports = runWith = ({cwd, env, containingDir, inputs, resolveValues, log}) ->
  templateName = inputs[1]
  logg = log
  Memoblock.do([
    -> @configFilePath = findConfigFilePath cwd, env.HOME
    -> log "Did not find config file in #{searchPaths.join ", "}." unless @configFilePath
    -> log "Using config file #{@configFilePath}." if @configFilePath
    -> throw new Error "Usage: jumpstart [project-name] [template-name]" if inputs.length isnt 2
    -> @targetDir = "#{cwd}/#{inputs[0]}" 
    -> @cwdExists = fsExists cwd
    -> @cdExists = fsExists containingDir
    -> throw new Error "Supplied cwd #{cwd} does not exist." unless @cwdExists
    -> throw new Error "Supplied containing dir #{containingDir} does not exist." unless @cdExists
    -> @config = if @configFilePath then require @configFilePath else {}
    -> @templateDir = findTemplateDir cwd, containingDir, templateName
    -> @creatingProject = createProject @targetDir, @templateDir, @config, resolveValues, log
    -> log "Created #{@targetDir}."
  ])
  
findTemplateDir = (cwd, containingDir, templateName) ->
  logg "Searching for template #{templateName}."
  searchPaths = [cwd,containingDir]
  dirs = ("#{searchPath}/jumpstart-#{templateName}/template" for searchPath in searchPaths)
  tryDir = (path) =>
    logg "Trying #{path}"
    fsExists path
  faithful.detectSeries(dirs, tryDir).then (path) =>
    throw new Error "Cannot find template #{templateName}." unless path
    logg "Using template #{path}."
    path

findConfigFilePath = (cwd, home) ->
  faithful.detectSeries(("#{dir}/.jumpstart.json" for dir in [cwd,home]), fsExists)

# setDefault = (name, value) ->
#   getConfig(config).then (config) ->
#     config.defaults[name] = value
#     writeConfig config, next
# 
# writeConfig = (config) ->
#   @findConfigFilePath.then (path) ->
#     @log "Writing config to #{path}."
#     writeFile path, JSON.stringify config