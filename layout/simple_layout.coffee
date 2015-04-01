Layout = require('./layout').Layout
util = require('util')
os = require('os')

class SimpleLayout extends Layout

	@isLoggerNameShow = false
	@isPidShow = false
	@isTimeShow = false
	@isHostsShow = false

	constructor : (shows)->
		if util.isArray(shows)
			for item in shows
				switch item
					when "loggerName" then @isLoggerNameShow = true
					when "time" then @isTimeShow = true
					when "pid" then @isPidShow = true
					when "hosts" then @isHostsShow = true
		return
	#override
	format : (loggerName, level, msg)->
		@buildHeader(loggerName)+"["+level.toUpperCase()+"]#{msg}"

	buildHeader : (loggerName)->
		header = ""
		if @isHostsShow
			header += "["+os.hostname()+"]"
		if @isTimeShow
			d = new Date(new Date().getTime());
			header += "["+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds()+"."+d.getMilliseconds()+"]"
		if @isPidShow
			header += "[pid-"+process.pid+"]"
		if @isLoggerNameShow
			header += "["+loggerName+"]"
		header

exports.SimpleLayout = SimpleLayout