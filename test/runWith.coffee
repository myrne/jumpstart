runWith = require "../lib/runWith"
path = require "path"
rimraf = require "rimraf"

logged = []

goodOptions = require "../fixtures/goodOptions"

describe "runWith", ->
  it "fails when not providing options object.", ->
    runWith().then (-> throw new Error "Function should have failed."), (err) -> # swallow error
    
  it "fails when providing empty object.", ->
    runWith({}).then (-> throw new Error "Function should have failed."), (err) -> # swallow error
  it "works when providing good options", ->
    runWith(goodOptions)
  after (next) ->
    rimraf path.resolve(goodOptions.cwd, goodOptions.inputs[0]), next