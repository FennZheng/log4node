AbstractAppender = require('./abstract_appender').AbstractAppender
Sentry = require('../extends/sentry').Sentry
LevelUtil = require('../core/level').LevelUtil
util = require('util')


class SentryAppender extends AbstractAppender
	constructor : (props)->
		@_disbale = false
		@_sentry = new Sentry(props.dsn, props.disable)
		return
	# Override

	append : (loggerName, level, msgs)->
		return if not LevelUtil.validate(level)
		@_sentry.sendMsg(loggerName, level, msgs)
		return


exports.SentryAppender = SentryAppender
