Logger = require('./logger').Logger
loggerMap = {}

exports.getLogger = (name)->
	return loggerMap[name]

exports.initLogger = (confArray)->
	root = confArray.root
	for loggerConf in confArray.loggers
		logger = new Logger(root, loggerConf, confArray)
		loggerMap[loggerConf.name] = logger
	return
