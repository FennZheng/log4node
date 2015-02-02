SimpleLayout = require('../layout/simple_layout').SimpleLayout
LayoutAttachable =
	setLayout : (layout)->
		if "SimpleLayout" == layout
			@layout = new SimpleLayout
		return
	format : (level, msg)->
		if @layout
			msg = @layout.format(level, msg)
		msg

exports.LayoutAttachable = LayoutAttachable