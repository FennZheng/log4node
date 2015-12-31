require("../lib/date.js")
os = require('os')
EOL = os.EOL || '\n'

class LiteralPatternConverter
	constructor : (str)->
		@_content = str

	format : (context)->
		context.out += @_content

class LoggerNameConverter
	constructor : (options)->
		# %c{2} 其中2为options，表示显示长度
		if options? and options.length > 0
			@_length = options[0]
		else
			@_length = -1

	format : (context)->
		if @_length > 0
			context.out += context.loggerName.substring(0, @_length)
		else
			context.out += context.loggerName
		return

class TimeConverter
	_formatStr = "yyyy-MM-dd HH:mm:ss.S"
	constructor : (options)->
		if options? and options.length > 0
			_formatStr = options[0]

	format : (context)->
		context.out += new Date().format(_formatStr)
		return

class NewLineConverter
	constructor : (options)->

	format : (context)->
		context.out += EOL
		return

class LevelConverter
	constructor : (options)->

	format : (context)->
		context.out += context.level
		return

class ProcessIdConverter
	constructor : (options)->

	format : (context)->
		if process.pid?
			context.out += process.pid
		else
			context.out += '-'
		return

class HostConverter
	constructor : (options)->

	format : (context)->
		context.out += os.hostname()
		return

exports.LiteralPatternConverter = LiteralPatternConverter
exports.LoggerNameConverter = LoggerNameConverter
exports.TimeConverter = TimeConverter
exports.NewLineConverter = NewLineConverter
exports.LevelConverter = LevelConverter
exports.ProcessIdConverter = ProcessIdConverter
exports.HostConverter = HostConverter