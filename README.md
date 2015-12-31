# log4node
Log4node - The Logging Framework for NodeJS

##1、Architecture

image is coming..

##2、Appender

###2.1、ConsoleAppender

```
conf = {
    "root": "",
    "level": "all",
    "appenders":{
        "consoleAppender":{
            "type":"ConsoleAppender",
            "properties":{
                "layout":{
                    "name":"SimpleLayout",
                    #可配置显示loggerName，pid，时间，应用的hosts（os）
                    "shows":["loggerName","pid","time","hosts"]
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
### 8ns
start = new Date().getTime()
i = 100000
while i-- > 0
    logger.trace("fileeeee")
end = new Date().getTime()
console.log(end-start)
###
logger.trace("fileeeee")
logger.debug("field1 field2 ...\n")
logger.info("field1 field2 ...")
logger.log("field1 field2 ...")
logger.warn("field1 field2 ...")
logger.error("field1111")
logger.error(["field1", "fields2", "fields3"])
```

###2.2、MemoryAppender

```
conf = {
    "root": "",
    "level": "all",
    "appenders":{
        "memoryAppender":{
            "type":"MemoryAppender"
        }
    },
    "loggers": [
    {
        "name": "example",
        "appenderRefs": [
            "memoryAppender"
        ]
    }
  ]
}

funLog = require('../index.js')
memoryManager = funLog.memoryLogManager
funLog.initLogger(conf)
logger = funLog.getLogger("example")
logger.log("field1 field2 ...\n")
logger.log(["field1", "fields2", "fields3"])
result = memoryManager.getAllLogs()
console.log("getAllLogs")
console.log(result)
memoryManager.clearAll()
result = memoryManager.getAllLogs()
console.log("after clearAll")
console.log(result)

```

###2.3、SentryAppender

```
conf = {
    "root": "",
    "appenders":{
        "sentryAppender": {
            "disable": false,
            "type": "SentryAppender",
            "properties":{
                "dsn": "http://716fd68bdb634e7f8dc74da88179bed3:97700c0f6eb940cea28492062face182@192.168.16.14:9000//7"
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
                #"consoleAppender"
            ]
        }
    ]
}
funLog = require('../index.js')
funLog.initLogger(conf)
logger = funLog.getLogger("example")
#ok debug instead
#logger.trace("trace field2 ...")
#ok
#logger.debug("debug field1 field2 ...")
#ok
#logger.info("info field2 ...")
#ok
#logger.warn("info field2 ...")
#ok three records
#logger.log(["log field1", "fields2", "fields3"])
#ok info instead
#logger.error("error field1 field2 ...\n")
#ok error instead
#logger.fatal("error field1 field2 ...\n")
i = 200000 #3534
start = new Date().getTime()
while i-- > 1
    logger.error("test throw Error")
end = new Date().getTime()
console.log((end - start))
```

###2.4、RollingFileAppender

```
conf = {
    "root": "",
    "level": "all",
    "appenders":{
        "rollingFileAppender":{
            "type":"RollingFileAppender",
            "properties": {
                "root": "/tmp/",
                "logFilePattern": "example-%s.log",
                "datePattern": "yyyyMMdd-HHmm",
                "interval": 120
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
funLog = require('../index.js')
funLog.initLogger(conf)
logger = funLog.getLogger("example")
count = 0
t = setInterval(()->
    logger.log(["field1", "fields2", "fields3"])
    if ++count is 500
        clearInterval(t)
,1000)
```

##3、Features

###3.1、PatternLayout

PatternConverter start with %：
+c: logger name，length can be config like %c{2}，its means logger name only output 2 。
+d: date，format like this: %d{HH:mm:ss.S}
+n: line break
+p: log level
+t: process id
+h: host name
+m: message, if there is not this config, message will be appended to record
+%%: output %

FormattingInfo：
%-min.max-c
- 表示格式化部分的对齐方式，出现在左侧表示左对齐，出现在右侧表示右对齐，对齐后剩余部分填充空格
min 表示格式化部分的最小长度
max 表示格式化部分的最大长度
例如：%-2.5c