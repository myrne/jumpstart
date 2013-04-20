easytable = require "easy-table"
{pairs,object,sortBy} = require "underscore"

module.exports = (values) ->
  """
  
  
  VALUES TO BE USED
  =================
  #{easytable.printObj object sortBy pairs(values), 0}
  """