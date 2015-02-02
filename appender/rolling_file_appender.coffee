fs = require('fs')
path = require('path')
util = require ('util')
AbstractAppender = require("./abstract_appender").AbstractAppender

require('../lib/date.js')

class RollingFileAppender extends AbstractAppender
	constructor : (params)->
		@root           = path.normalize(params.root)
		@logFilePattern = params.logFilePattern
		@datePattern    = params.datePattern
		@interval       = params.interval * 1000
		@logFD          = null
		@expectTime     = 0
		return
	# Override
	# 特殊字符替换列表
	# specialChars ={',':'","'}
	append : (loggerName, level, msg)->
		@openExpectLogFile()
		# 扩展功能：参数可以为字符串数组，目的是为统一替换特殊字符，自动加换行符
		if util.isArray(msg)
			msg = msg.join(',')+'\n'
		sb = new Buffer(msg)
		fs.write(@logFD, sb, 0, sb.length, null, (err)->
			if err? then throw err
		)
		return

RollingFileAppender.prototype.openExpectLogFile = ()->
	curTime = getLogTimeStamp(@interval)
	if curTime isnt @expectTime
		@expectTime = curTime
		if !@logFD
			@rotateLogFileSync(curTime)
		else
			@rotateLogFile(curTime)
	return
		
#第一次打开日志文件
RollingFileAppender.prototype.rotateLogFileSync = (time) ->
	logFile = @getLogFilename(time)
	logDir = @getLogDir(time)
	if not fs.existsSync logDir
		try
			fs.mkdirSync logDir, '775'
		catch err
			if err.code isnt "EEXIST"
				throw err
	try
		if @logFD
			fs.closeSync @logFD
		@logFD = fs.openSync logFile, 'a', '664'
	catch err
		throw err
	return

#滚动日志文件
RollingFileAppender.prototype.rotateLogFile = (time) ->
	logFile = @getLogFilename(time)
	logDir = @getLogDir(time)
	#FIXME 应修改为异步
	if not fs.existsSync logDir
		try
			fs.mkdirSync logDir, '775'
		catch err
			if err.code  isnt "EEXIST"
				throw err
	@openLogFile logFile
	return

RollingFileAppender.prototype.openLogFile = (logFile)->
	self = @
	fs.open logFile, 'a', '664', (err, fd)->
		if err?
			throw err
		tmpFD = self.logFD
		self.logFD = fd
		if tmpFD?
			fs.close tmpFD, (err)->
				if err?
					throw err
	return

RollingFileAppender.prototype.getLogDir = (time)->
	logTime = if time? then new Date(time) else new Date()
	return path.join(@root, logTime.format('yyyyMMdd'))
	
RollingFileAppender.prototype.getLogFilename = (time)->
	logTime = if time? then new Date(time) else new Date()
	dayString = logTime.format("yyyyMMdd")
	return path.join(@root, dayString, util.format(@logFilePattern, logTime.format(@datePattern)))
	
exports.getLogTimeStamp = getLogTimeStamp = (interval, time)->
	theTime = if time? then time else new Date()
	
	localTime = theTime.getTime()
	localTime -= theTime.getTimezoneOffset()*60*1000
	localTime = parseInt(localTime / interval) * interval
	localTime += theTime.getTimezoneOffset()*60*1000
	return localTime

exports.RollingFileAppender = RollingFileAppender