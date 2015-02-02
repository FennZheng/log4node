Layout = require('./layout').Layout

class SimpleLayout extends Layout
	format : (level, msg)->
		"["+level.toUpperCase()+"]"+"#{msg}"

exports.SimpleLayout = SimpleLayout