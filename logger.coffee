LevelAble = require('./core/level').LevelAble
LevelUtil = require('./core/level').LevelUtil
Module = require('./core/module').Module
AppenderFactory = require('./appender/appender_factory')

class Logger extends Module
	@include LevelAble

	constructor : (root, conf, fullConf)->
		@_appenderList = []
		@_name = ""
		@_disable = false
		@_level = LevelUtil.DEFAULT_LEVEL

		if conf.name
			@_name = conf.name

		if conf.disable is true
			@_disable = true

		# set logger level
		@_setLevel(conf, fullConf)

		# init _appenderList
		for name in conf.appenderRefs
			appenderObj = AppenderFactory.getAppender(root, @_name, name, fullConf)
			if appenderObj
				@_appenderList.push appenderObj
		return

	# Override
	_log : (level, msg)->
		if @_disable then return
		if LevelUtil.isLevelAllowed(@_level, level)
			for appender in @_appenderList
				appender.append(@_name, level, msg)
		return

	# set logger level
	_setLevel : (loggerConf, fullConf)->
		loggerLevel = loggerConf.level
		rootLevel = fullConf.level
		if loggerLevel?
			if LevelUtil.validate(loggerLevel)
				@_level = loggerLevel
			else
				throw new Error("logger name: #{loggerConf.name} init error cause by unknown logger level:"+loggerLevel)
		else if rootLevel?
			if LevelUtil.validate(rootLevel)
				@_level = rootLevel
			else
				throw new Error("logger name: #{loggerConf.name} init error cause by unknown root level:"+rootLevel)


exports.Logger = Logger
