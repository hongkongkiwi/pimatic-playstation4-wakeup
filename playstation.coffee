module.exports = (env) ->
  # ##Dependencies
  util = require 'util'
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'

  deviceTypes = {}
  for device in [
    'playstation4-wakup'
  ]
    # convert kebap-case to camel-case notation with first character capitalized
    className = device.replace /(^[a-z])|(\-[a-z])/g, ($1) -> $1.toUpperCase().replace('-','')
    deviceTypes[className] = require('./devices/' + device)(env)

  # ##The PingPlugin
  class PlaystationPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      @deviceCount = 0

      deviceConfigDef = require("./device-config-schema")

      for className, classType of deviceTypes
        env.logger.debug "Registering device class #{className}"
        @framework.deviceManager.registerDeviceClass(className, {
          configDef: deviceConfigDef[className],
          createCallback: (config, lastState) =>
            @deviceCount++
            return new classType(config, @, lastState)
        })

      # @framework.deviceManager.registerDeviceClass("PingPresence", {
      #   configDef: deviceConfigDef.PingPresence,
      #   createCallback: (config, lastState) =>
      #     device = new PingPresence(config, lastState, @deviceCount)
      #     @deviceCount++
      #     return device
      # })

      # @framework.deviceManager.on('discover', (eventData) =>
      #   interfaces = @listInterfaces()
      #   # ping all devices in each net:
      #   maxPings = 513
      #   pingCount = 0
      #   interfaces.forEach( (iface, ifNum) =>
      #     @framework.deviceManager.discoverMessage(
      #       'pimatic-ping', "Scanning #{iface.address}/24"
      #     )
      #     base = iface.address.match(/([0-9]+\.[0-9]+\.[0-9]+\.)[0-9]+/)[1]
      #     i = 1
      #     while i < 256
      #       do (i) =>
      #         if pingCount > maxPings then return
      #         address = "#{base}#{i}"
      #         sessionId = ((process.pid + (256*(ifNum+1)) + i) % 65535)
      #         session = ping.createSession(
      #           networkProtocol: ping.NetworkProtocol.IPv4
      #           packetSize: 16
      #           retries: 3
      #           sessionId: sessionId
      #           timeout: eventData.time
      #           ttl: 128
      #         )
      #         session.pingHost(address, (error, target) =>
      #           session.close()
      #           unless error
      #             dns.reverse(address, (error, hostnames) =>
      #               displayName = (
      #                 if hostnames? and hostnames.length > 0 then hostnames[0] else address
      #               )
      #               config = {
      #                 class: 'PingPresence',
      #                 name: displayName,
      #                 host: displayName
      #               }
      #               @framework.deviceManager.discoveredDevice(
      #                 'pimatic-ping', "Presence of #{displayName}", config
      #               )
      #             )
      #         )
      #       i++
      #       pingCount++
      #     if pingCount > maxPings
      #       @framework.deviceManager.discoverMessage(
      #         'pimatic-ping', "Could not ping all networks, max ping cound reached."
      #       )
      #   )
      # )

  playstationPlugin = new PlaystationPlugin

  # For testing...
  #playstationPlugin.PingPresence = PingPresence

  return playstationPlugin
