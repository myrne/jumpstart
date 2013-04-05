fs = require "fs"
async = require "async"
readdir = require "recursive-readdir"
ncp = require "ncp"
easytable = require "easy-table"

module.exports = class ProjectCreator
  constructor: (@config = {}, @resolveValues) ->
    @config.defaults = {} unless @config.defaults
  
  createProject: (targetDir, templateName, next) ->
    @findTemplateDir templateName, (err, templateDir) =>
      return next err if err
      return fs.exists targetDir, (targetExists) =>
        return next new Error "Target directory #{targetDir} already exist." if targetExists
        @log "Will make new project in #{targetDir}."
        return readdir templateDir, (err, paths) =>
          return next err if err
          # @log "Collecting placeholder names in #{templateDir}."
          return collectPlacholderNames paths, (err, varNames) =>
            return next err if err
            values = makeValues varNames, @config.defaults, targetDir, templateName
            missingVarNames = (name for name, value of values when value is null)
            @resolveValues missingVarNames, (err, resolvedValues) =>
              return next err if err
              values[name] = value for name, value of resolvedValues
              @logValues values
              @log "Copying template files to #{targetDir}."    
              return ncp templateDir, targetDir, (err) =>
                return next err if err
                return readdir targetDir, (err, targetPaths) =>
                  return next err if err
                  @log "Applying values to template files."
                  return applyValues targetPaths, values, (err) ->
                    return next err if err
                    return renameFiles targetDir, next
  
  findTemplateDir: (templateName, next) ->
    @log "Searching for template #{templateName}."
    searchPaths = [process.cwd(),@getContainingDirectory()]
    dirs = ("#{searchPath}/jumpstart-#{templateName}/template" for searchPath in searchPaths)
    tryDir = (path, next) =>
      @log "Trying #{path}"
      fs.exists path, next
    async.detectSeries dirs, tryDir, (path) =>
      return next new Error "Cannot find template #{templateName}." unless path
      @log "Using template #{path}."
      return next null, path

  getContainingDirectory: ->
    location = __dirname.split("/")
    location.pop()
    location.pop()
    location.join "/"

  log: (msg) ->
    console.log msg
  
  logValues: (values) ->
    @log ""
    @log "VALUES TO BE USED"
    @log "================="
    @log easytable.printObj sortValues values

makeValues = (varNames, defaults, targetDir, templateName) ->
  values = {}
  for varName in varNames
    values[varName] = if defaults[varName] then defaults[varName] else null 
  values["target-dir"] = targetDir
  values["template-name"] = templateName
  values["current-year"] = new Date().getFullYear()
  values

renameFiles = (targetDir, next) ->
  renames =
    "package.jumpstart.json": "package.json" # so npm won't complain about invalid syntax because of placeholders
    "gitignore.jumpstart": ".gitignore" # .gitignore is not included when packaged by npm
    "npmignore.jumpstart": ".npmignore" # will be included, possibly overwrites the original .npmignore
    "tm_properties.jumpstart": ".npmignore" # so the textmate properties won't apply to the template dir itself
  renameFile = (relativePath, next) ->
    currentPath = "#{targetDir}/#{relativePath}"
    newPath = "#{targetDir}/#{renames[relativePath]}"
    fs.exists currentPath, (exists) ->
      return next null unless exists
      console.log "Renaming #{currentPath} to #{newPath}"
      return fs.rename currentPath, newPath, next
  async.forEach Object.keys(renames), renameFile, next

sortValues = (values) ->
  names = (name for name, value of values).sort()
  sortedValues = {}
  sortedValues[name] = values[name] for name in names
  sortedValues

collectPlacholderNames = (paths, next) ->
  varNames = []
  collectVars = (path, next) ->
    fs.readFile path, (err, contents) ->
      return next err if err
      if matches = contents.toString().match  /---([A-z]+(-[A-z]+)*?)---/g
        for match in matches
          varName = match.substring 3,match.length-3
          varNames.push varName if varNames.indexOf varName is -1
      return next null
  async.forEach paths, collectVars, (err) ->
    return next err if err
    return next null, varNames
    
applyValues = (paths, values, next) ->
  replacements = {} 
  replacements["---#{name}---"] = value for name, value of values
  applyValuesToFile = (path, next) ->
    fs.readFile path, (err, contents) ->
      contents = multiReplace contents, replacements
      fs.writeFile path, contents, next
  async.forEach paths, applyValuesToFile, next

multiReplace = (string, replacements) ->
  string = string.toString()
  string = string.replace new RegExp(original, "g"), replacement for original, replacement of replacements
  string