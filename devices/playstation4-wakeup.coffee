module.exports = (env) ->

  Promise = env.require 'bluebird'

  class Playstation4Wakeup extends env.devices.ButtonsDevice

    constructor: (@config, @plugin) ->
      @name = @config.name
      @id = @config.id

      super(@config)

    buttonPressed: (buttonId) ->
      for b in @config.buttons
        if b.id is buttonId
          @emit 'button', b.id
          return

    destroy: () ->
      for b in @config.buttons
        if b.stateTopic
          @plugin.mqttclient.unsubscribe(b.stateTopic)
      super()
