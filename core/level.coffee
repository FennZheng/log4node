# support levels
LevelAble =
	_log : (level, msg)->
		throw new Error("LevelAble _log(level,msg) has no imp!")
	trace : (msg)->
		@_log('trace', msg)
		return
	debug : (msg)->
		@_log('debug', msg)
		return
	info : (msg)->
		@_log('info', msg)
		return
	warn : (msg)->
		@_log('warn', msg)
		return
	error : (msg)->
		@_log('error', msg)
		return

# support tools api
LevelUtil =
	LEVELS : {
		'all': 1
		'trace': 2
		'debug': 3
		'info': 4
		'warn': 5
		'error': 6
		'off': 99
	}
	# constants pool
	'DEFAULT_LEVEL': 'info'
	validate : (level)->
		if @LEVELS[level]
			return true
		return false
	isError : (level)->
		return true if level == 'error'
		return false
	isDebug : (level)->
		return true if level == 'debug'
		return false
	isLevelAllowed: (confLevel, callLevel)->
		if @LEVELS[confLevel] <= @LEVELS[callLevel]
			return true
		return false



exports.LevelAble = LevelAble
exports.LevelUtil = LevelUtil