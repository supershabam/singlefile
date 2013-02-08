singlefile = require "../index"

describe "singlefile", ->
  describe "the wrapped function", ->
    it "should be passed just the callback function", (done)->
      fn = (cb)->
        arguments.should.be.length 1
        cb()
      wrapped = singlefile(fn)
      wrapped ->
        done()
    it "should be passed 3 arguments and the callback", (done)->
      p1 = "hi there"
      p2 = {oh: "yeah"}
      p3 = 2
      fn = (param1, param2, param3, cb)->
        param1.should.equal p1
        param2.should.equal p2
        param3.should.equal p3
        cb()
      wrapped = singlefile(fn)
      wrapped p1, p2, p3, ->
        done()

  describe "the callback function", ->
    it "should return 0 arguments", (done)->
      fn = (cb)->
        cb()
      wrapped = singlefile(fn)
      wrapped ->
        arguments.should.be.length 0
        done()

    it "should return 3 arguments", (done)->
      p1 = "hi there"
      p2 = {oh: "yeah"}
      p3 = 2
      fn = (cb)->
        cb(p1, p2, p3)
      wrapped = singlefile(fn)
      wrapped (param1, param2, param3)->
        param1.should.equal p1
        param2.should.equal p2
        param3.should.equal p3
        done()

  describe "flow", ->
   it "should execute cache loader only once", (done)->
    loadCount = 0
    _config = null
    getConfig = (cb)->
      return cb(null, _config) if _config?

      loadConfig = ->
        _config = {oh: "yeah"}
        loadCount = loadCount + 1
        cb(null, _config)

      setTimeout loadConfig, 50

    wrapped = singlefile(getConfig)
    wrapped (err, config)->
      config.should.eql {oh: "yeah"}
      loadCount.should.equal 1
    wrapped (err, config)->
      config.should.eql {oh: "yeah"}
      loadCount.should.equal 1
      done()



