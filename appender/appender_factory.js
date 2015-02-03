// Generated by CoffeeScript 1.3.3
(function() {
  var APPENDER_TYPE, ConsoleAppender, MemoryAppender, RollingFileAppender, SentryAppender, getAppender, memoryLogFactory, _appenderStore, _initAppender;

  memoryLogFactory = require('../memory_log_factory');

  RollingFileAppender = require('./rolling_file_appender').RollingFileAppender;

  MemoryAppender = require('./memory_appender').MemoryAppender;

  ConsoleAppender = require('./console_appender').ConsoleAppender;

  SentryAppender = require('./sentry_appender').SentryAppender;

  memoryLogFactory = require('../memory_log_factory');

  APPENDER_TYPE = {
    'ConsoleAppender': ConsoleAppender,
    'MemoryAppender': MemoryAppender,
    'RollingFileAppender': RollingFileAppender,
    'SentryAppender': SentryAppender
  };

  _appenderStore = {};

  getAppender = function(root, logName, name, conf) {
    var appenderConf, appenderObj;
    appenderObj = _appenderStore[name];
    if (!appenderObj) {
      appenderConf = conf.appenders[name];
      if (!appenderConf) {
        throw new Error('getAppender error: unknown appender name:' + name);
      }
      return _initAppender(root, logName, name, appenderConf);
    }
  };

  _initAppender = function(root, logName, name, conf) {
    var appenderObj, _ref;
    if (!name) {
      throw new Error('AppenderFactory initAppender error: missing appender name');
    }
    if (!APPENDER_TYPE[conf.type]) {
      throw new Error('AppenderFactory initAppender error: unknown type' + conf.type);
    }
    if ((conf.properties != null) && !(conf.properties.root != null)) {
      conf.properties.root = root;
    }
    appenderObj = new APPENDER_TYPE[conf.type](conf.properties);
    if (conf.type === 'MemoryAppender') {
      memoryLogFactory.addAppender(logName, appenderObj);
    }
    if (((_ref = conf.properties) != null ? _ref.layout : void 0) != null) {
      appenderObj.setLayout(conf.properties.layout);
    }
    return appenderObj;
  };

  exports.getAppender = getAppender;

}).call(this);
