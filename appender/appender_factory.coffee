memoryLogFactory = require('../memory_log_factory')
RollingFileAppender = require('./rolling_file_appender').RollingFileAppender
MemoryAppender = require('./memory_appender').MemoryAppender
ConsoleAppender = require('./console_appender').ConsoleAppender
SentryAppender = require('./sentry_appender').SentryAppender
memoryLogFactory = require('../memory_log_factory')


APPENDER_TYPE = {
	'ConsoleAppender': ConsoleAppender
	'MemoryAppender': MemoryAppender
	'RollingFileAppender': RollingFileAppender
	'SentryAppender': SentryAppender
}

_appenderStore = {}

# lazy init
getAppender = (root, logName, name, conf)->
	appenderObj = _appenderStore[name]
	if not appenderObj
		appenderConf = conf.appenders[name]
		if not appenderConf
			throw new Error('getAppender error: unknown appender name:'+name)
		_initAppender(root, logName, name, appenderConf)

_initAppender = (root, logName, name, conf)->
	if not name
		throw new Error('AppenderFactory initAppender error: missing appender name')
	if not APPENDER_TYPE[conf.type]
		throw new Error('AppenderFactory initAppender error: unknown type'+conf.type)

	#set conf root
	if conf.properties? and not conf.properties.root?
		conf.properties.root = root

	appenderObj =  new APPENDER_TYPE[conf.type](conf.properties)

	# set layout
	if conf.properties?.layout?
		appenderObj.setLayout(conf.properties.layout)
	appenderObj


exports.getAppender = getAppender