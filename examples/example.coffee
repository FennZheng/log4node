conf = {
	"root": "",
	"level": "debug",
	"appenders":{
		"sentryAppender": {
			"disable": false,
			"type": "SentryAppender",
			"properties":{
				"dsn": "#{dsn}"
			}
		},
		"consoleAppender":{
			"type":"ConsoleAppender",
			"properties":{
				"layout":"SimpleLayout"
			}
		},
		"example1RollingFileAppender":{
			"type":"RollingFileAppender"
			"properties":{
				"root": "/tmp/",
				"logFilePattern": "example1-%s.log",
				"datePattern": "yyyyMMdd",
				"interval": 1200
			}
		},
		"deliverRollingFileAppender":{
			"type":"RollingFileAppender"
			"properties":{
				"root": "/tmp/",
				"logFilePattern": "example2-%s.log",
				"datePattern": "yyyyMMdd",
				"interval": 1200
			}
		}
	},
	"loggers":[
		{
			"name": "example1",
			"level": "off",
			"appenderRefs": [
				"sentryAppender",
				"consoleAppender",
				"example1RollingFileAppender"
			]
		},
		{
			"name": "deliver",
			"level": "debug",
			"appenderRefs": [
				"sentryAppender",
				"consoleAppender",
				"example2RollingFileAppender"
			]
		}
	]
}

log = require('../index.js')
log.initLogger(conf)
logger1 = log.getLogger("example1")
logger2 = log.getLogger("example2")


logger1.trace("trace info field2 ...\n")
logger1.debug("debug field1 field2 ...\n")
logger1.info("info field2 ...\n")
logger1.warn("info field2 ...\n")
logger1.log(["log field1", "fields2", "fields3"])
logger1.error("error field1 field2 ...\n")

logger2.trace("trace info field2 ...\n")
logger2.debug("debug field1 field2 ...\n")
logger2.info("info field2 ...\n")
logger2.warn("info field2 ...\n")
logger2.log(["log field1", "fields2", "fields3"])
logger2.error("error field1 field2 ...\n")
