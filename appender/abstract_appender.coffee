LayoutAttachable = require('../core/layout_attachable').LayoutAttachable
LevelAble = require('../core/level').LevelAble
Module = require('../core/module').Module

class AbstractAppender extends Module
	@include LayoutAttachable
	@include LevelAble
	# 提供给appender覆盖
	append : (loggerName, level, msg)->
		throw new Error("append in null")

exports.AbstractAppender = AbstractAppender