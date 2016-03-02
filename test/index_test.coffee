Path = require('path')
Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'DNSimple', ->
  user = robot = adapter =  null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', true, 'Hubot')

    robot.adapter.on 'connected', ->

      process.env.HUBOT_DEPLOY_RANDOM_REPLY = 'sup-dude'

      require('../index') robot

      userInfo =
        name: 'ys'
        room: '#zf-promo'

      user = robot.brain.userForId('1', userInfo)

      adapter = robot.adapter

      done()

    robot.run()

  afterEach ->
    robot.server.close()
    robot.shutdown()

