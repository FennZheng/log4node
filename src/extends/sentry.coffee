LevelUtil = require('../core/level').LevelUtil
raven = require('raven')
util = require('util')

class Sentry

	constructor : (dsn,disable)->
		@_client = new raven.Client(dsn)
		@_disable = disable
		return

	sendMsg : (loggerName, level, msgs)->
		if @_disable
			return
		if util.isArray msgs
			for msg in msgs
				@_send(loggerName, level, msg)
		else
			@_send(loggerName, level, msgs)
		return

	# sentry 只有debug，info，error三个级别, 不识别的level会被当成error
	_send : (loggerName, level, msg)->
		if LevelUtil.isError(level)
			@_client.captureError(msg, {
				level: "error",
				logger: loggerName
			})
		else if LevelUtil.isDebug(level)
			@_client.captureMessage(msg, {
				level: "debug",
				logger: loggerName
			})
		else
			@_client.captureMessage(msg, {
				level: "info",
				logger: loggerName
			})
		return

	getInstance: (dsn, disable)->
		return new Sentry(dsn, disable)

exports.Sentry = Sentry