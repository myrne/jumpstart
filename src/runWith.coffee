Memoblock = require "memoblock"
{detectSeries,adapt} = require "faithful"
fsExists = require "fs-exists"
fsExists = adapt fsExists
_ = require "underscore"

createProject = require "./createProject"
printValues = require "./printValues"

module.exports = runWith = ({cwd, env, containingDir, inputs: [dirName, templateName], resolveValues, log}) ->
  configDirs = ("#{dir}/.jumpstart.json" for dir in [cwd,env.HOME])
  targetDir = "#{cwd}/#{dirName}" 
  autoValues = 
    "target-dir": targetDir
    "current-year": new Date().getFullYear()
  Memoblock.do [
    -> @cwdExists = fsExists cwd
    -> @cdExists = fsExists containingDir
    -> throw new Error "Supplied cwd #{cwd} does not exist." unless @cwdExists
    -> throw new Error "Supplied containing dir #{containingDir} does not exist." unless @cdExists
    -> @configFilePath = detectSeries configDirs, fsExists
    -> log "No config file in #{configDirs.join ", or "}. Please read README.md." unless @configFilePath
    -> log "Using config file #{@configFilePath}." if @configFilePath
    -> @config = if @configFilePath then require @configFilePath else globals:{}
    -> 
      if templateName 
        @templateName = templateName
      else if @config.defaultTemplate?
        @templateName = @config.defaultTemplate
      else
        throw new Error "Usage: jumpstart [project-name] [template-name]"
    -> @getValues = (varNames) =>
          values = _.extend _.object(varNames, []), @config.globals, autoValues
          missingVarNames = (name for name, value of values when not value?)
          resolveValues(missingVarNames)
            .then (extraValues) -> 
              log printValues _.extend values, extraValues
              values
    -> @templateDirs = ("#{path}/jumpstart-#{@templateName}/template" for path in [cwd,containingDir])
    -> @templateDir = detectSeries @templateDirs, fsExists
    -> throw new Error "Cannot find template in #{templateDirs.join ", or "}." unless @templateDir
    -> log "Using template #{@templateDir}."
    -> @creatingProject = createProject targetDir, @templateDir, @getValues
    -> log "Created #{@creatingProject.targetPaths.length} files in #{targetDir}."
  ]

# setDefault = (name, value) ->
#   getConfig(config).then (config) ->
#     config.defaults[name] = value
#     writeConfig config, next
# 
# writeConfig = (config) ->
#   @findConfigFilePath.then (path) ->
#     @log "Writing config to #{path}."
#     writeFile path, JSON.stringify config