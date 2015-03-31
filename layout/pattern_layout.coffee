###
PatternConverter definition , started with %:
	c
		logger name. %c{length}
	d
		time. %d{HH:mm:ss.S}
	n
		new line
	p
		msg level
	t
		process id
    h
        host name
	%
        print % if %%

FormattingInfo definition：
    %-min.max-c
    - : align，left align when it appeared in left, right align when it appeared in right
	min : min length for formatting part
    max : max length for formatting part
	example：%-2.5c
###

PatternParser = require("../pattern/pattern_parser").PatternParser

Layout = require('./layout').Layout

class PatternLayout extends Layout
	constructor : (pattern)->
		@_pattern = pattern
		@_converters = []
		# formattingInfos
		@_patternFields = []
		new PatternParser().parse(@_pattern, @_converters, @_patternFields)

	format : (loggerName, level, msg)->
		#TODO use context or package it into LoggerEvent
		context = {}
		context.level = level
		context.loggerName = loggerName
		context.out = ""
		for i in [0..@_converters.length-1]
			# converter format 前的index
			_fieldStart = context.out.length
			@_converters[i].format(context)
			if i < @_patternFields.length and @_patternFields[i]?
				context.out = @_patternFields[i].format(_fieldStart, context.out)
		msg = context.out + msg

exports.PatternLayout = PatternLayout