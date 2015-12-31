SimpleLayout = require('../layout/simple_layout').SimpleLayout
PatternLayout = require('../layout/pattern_layout').PatternLayout

LayoutAttachable =
	setLayout : (layout)->
		if "SimpleLayout" == layout.name
			@layout = new SimpleLayout(layout.shows)
		else if "PatternLayout" == layout.name
			@layout = new PatternLayout(layout.conversionPattern)
		return
	format : (loggerName, level, msg)->
		if @layout
			msg = @layout.format(loggerName, level, msg)
		msg

exports.LayoutAttachable = LayoutAttachable