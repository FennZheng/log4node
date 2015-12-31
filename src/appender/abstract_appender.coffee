LayoutAttachable = require('../core/layout_attachable').LayoutAttachable
LevelAble = require('../core/level').LevelAble
Module = require('../core/module').Module

class AbstractAppender extends Module
	@include LayoutAttachable
	@include LevelAble
	# override
	append : (loggerName, level, msg)->
		throw new Error("no appender override append!")

exports.AbstractAppender = AbstractAppender