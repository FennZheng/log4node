AbstractAppender = require('./abstract_appender').AbstractAppender
LevelUtil = require('../core/level').LevelUtil
util = require('util')


class ConsoleAppender extends AbstractAppender
	constructor : (params)->
		return

	append : (loggerName, level, msg)->
		if util.isArray(msg)
			msg = msg.join(',')+'\n'
		else
			msg += '\n'
		# do layout
		msg = @format?(loggerName, level, msg)
		if LevelUtil.isError(level)
			process.stderr.write(msg)
		else
			process.stdout.write(msg)
		return

exports.ConsoleAppender = ConsoleAppender