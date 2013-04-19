Memoblock = require "Memoblock"
{detectSeries,adapt} = require "faithful"
fsExists = require "fs-exists"
fsExists = adapt fsExists

createProject = require "./createProject"

module.exports = runWith = ({cwd, env, containingDir, inputs, resolveValues, log}) ->
  templateName = inputs[1]
  templateDirs = ("#{path}/jumpstart-#{templateName}/template" for path in [cwd,containingDir])
  configDirs = ("#{dir}/.jumpstart.json" for dir in [cwd,env.HOME])
  Memoblock.do([
    -> @configFilePath = detectSeries configDirs, fsExists
    -> log "No config file in #{configDirs.join ", or "}. Please read README.md." unless @configFilePath
    -> log "Using config file #{@configFilePath}." if @configFilePath
    -> throw new Error "Usage: jumpstart [project-name] [template-name]" if inputs.length isnt 2
    -> @targetDir = "#{cwd}/#{inputs[0]}" 
    -> @cwdExists = fsExists cwd
    -> @cdExists = fsExists containingDir
    -> throw new Error "Supplied cwd #{cwd} does not exist." unless @cwdExists
    -> throw new Error "Supplied containing dir #{containingDir} does not exist." unless @cdExists
    -> @config = if @configFilePath then require @configFilePath else {}
    -> @templateDir = detectSeries templateDirs, fsExists
    -> throw new Error "Cannot find template in #{templateDirs.join ", or "}." unless @templateDir
    -> log "Using template #{@templateDir}."
    -> @creatingProject = createProject @targetDir, @templateDir, @config, resolveValues, log
    -> log "Created #{@targetDir}."
  ])

# setDefault = (name, value) ->
#   getConfig(config).then (config) ->
#     config.defaults[name] = value
#     writeConfig config, next
# 
# writeConfig = (config) ->
#   @findConfigFilePath.then (path) ->
#     @log "Writing config to #{path}."
#     writeFile path, JSON.stringify config