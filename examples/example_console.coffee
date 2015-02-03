conf = {
	"root": "",
	"level": "off",
	"appenders":{
		"consoleAppender":{
			"type":"ConsoleAppender",
			"properties":{
				"layout":"SimpleLayout"
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
log = require('../index.js')
log.initLogger(conf)
logger = log.getLogger("example")

logger.trace("fileeeee")
logger.debug("field1 field2 ...")
logger.info("field1 field2 ...")
logger.log("field1 field2 ...")
logger.warn("field1 field2 ...")
logger.error("field1111")
logger.error(["field1", "fields2", "fields3"])