conf = {
	"root": "",
	"level": "all",
	"appenders":{
		"consoleAppender":{
			"type":"ConsoleAppender",
			"properties":{
				"layout":{
					"name":"PatternLayout",
					"conversionPattern":"%-20.10c{7} %d{yyyy-MM-dd HH:mm:ss.S} [pid-%t] %p %n"
				}
			}
		}
	},
	"loggers": [
		{
			"name": "example",
			"appenderRefs": [
				"consoleAppender"
			]
		}
	]
}

funLog = require('../index.js')
funLog.initLogger(conf)
logger = funLog.getLogger("example")

logger.trace("fileeeee")
logger.debug("field1 field2 ...")
logger.info("field1 field2 ...")
logger.log("field1 field2 ...")
logger.warn("field1 field2 ...")
logger.error("field1111")
logger.error(["field1", "fields2", "fields3"])