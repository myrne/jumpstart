runWith = require "../lib/runWith"
path = require "path"

logged = []

goodOptions = require "../fixtures/goodOptions"

describe "runWith", ->
  it "fails when not providing options object.", ->
    try
      runWith()
    catch error
      return
    throw new Error "Function should have failed."
  it "fails when providing empty object.", ->
    try
      runWith {}
    catch error
      return
    throw new Error "Function should have failed."
  it "works when providing good options", (next) ->
    runWith(goodOptions)
      .then (memo) ->
        console.log "success"
        console.log memo
        next null
      .then null, (err) ->
        next err