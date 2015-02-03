conf = {
	"root": "",
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
		}
	},
	"loggers":[
		{
			"name": "example",
			"level": "all",
			"appenderRefs": [
				"sentryAppender",
				"consoleAppender"
			]
		}
	]
}

log = require('../index.js')
log.initLogger(conf)
logger = log.getLogger("example")

#ok 变成info
#logger.trace("trace field2 ...")
#ok
#logger.debug("debug field1 field2 ...")
#ok
#logger.info("info field2 ...")
#ok 变成info
#logger.warn("info field2 ...")
#ok 三条记录
#logger.log(["log field1", "fields2", "fields3"])
#ok
logger.error("error field1 field2 ...\n")

