conf = {
	"root": "/tmp/",
	"level": "all",
	"appenders":{
		"rollingFileAppender":{
			"type":"RollingFileAppender",
			"properties": {
				"logFilePattern": "example-%s.log",
				"datePattern": "yyyyMMdd-HHmm",
				"interval": 1200
			}
		}
	},
	"loggers": [
		{
			"name": "example",
			"appenderRefs": [
				"rollingFileAppender"
			]
		}
	]
}
log = require('../index.js')
log.initLogger(conf)
logger = log.getLogger("example")

logger.trace("trace info field2 ...\n")
logger.debug("debug field1 field2 ...\n")
logger.info("info field2 ...\n")
logger.warn("info field2 ...\n")
logger.log(["log field1", "fields2", "fields3"])
logger.error("error field1 field2 ...\n")
