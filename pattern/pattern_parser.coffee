LoggerNameConverter = require("./pattern_convert").LoggerNameConverter
TimeConverter = require("./pattern_convert").TimeConverter
NewLineConverter = require("./pattern_convert").NewLineConverter
LevelConverter = require("./pattern_convert").LevelConverter
ProcessIdConverter = require("./pattern_convert").ProcessIdConverter
LiteralPatternConverter = require("./pattern_convert").LiteralPatternConverter

FormattingInfo = require("./formatting_info").FormattingInfo

STATE = {
	LITERAL_STATE : 1,
	CONVERTER_STATE : 2,
	MIN_STATE : 3,
	MAX_STATE : 4,
	DOT_STATE : 5
}
# convertType mapping to Converter class
RULES = {
	"c" : LoggerNameConverter,
	"d" : TimeConverter,
	"n" : NewLineConverter,
	"p" : LevelConverter,
	"t" : ProcessIdConverter
}
ESCAPE_CHAR = "%"
NOOP = ()->
DEBUG = (msg)->
	console.log("[debug]:#{msg}")

class PatternParser
	constructor : ()->

	parse : (pattern, patternConverters, formattingInfos)->
		@_pattern  = pattern
		@_currentLiteral = []
		@_patternLength = pattern.length
		# array to receive pattern converters
		@_patternConverters = patternConverters
		# array to receive field specifiers corresponding to pattern converters.
		@_formattingInfos = formattingInfos

		@_state = STATE.LITERAL_STATE
		@_index = 0
		context = {}
		context.formattingInfo = FormattingInfo.getDefaultFormattingInfo()

		while @_index < @_patternLength
			# receive a char and enter into finite-state machine
			context.c = @_pattern.charAt(@_index++)

			switch @_state
				when STATE.LITERAL_STATE then @_stateLiteral(context)

				when STATE.CONVERTER_STATE then @_stateConvert(context)

				when STATE.MIN_STATE then @_stateMin(context)

				when STATE.DOT_STATE then @_stateDot(context)

				when STATE.MAX_STATE then @_stateMax(context)

				else NOOP()

		return

	# literal scan
	_stateLiteral : (context)->
		_char = context.c
		if @_index == @_patternLength
			@_currentLiteral.push(_char)
		else if _char == ESCAPE_CHAR
			# get next char
			switch @_pattern.charAt(@_index)
				when ESCAPE_CHAR then @_currentLiteral.push(_char);@_index++
				else
				# clean up @_currentLiteral，enter into convert state
					if @_currentLiteral.length != 0
						@_patternConverters.push(new LiteralPatternConverter(@_currentLiteral.join("")))
						@_formattingInfos.push(FormattingInfo.getDefaultFormattingInfo())
					@_currentLiteral = []
					# append %
					@_currentLiteral.push(_char)
					@_state = STATE.CONVERTER_STATE
		else
			@_currentLiteral.push(_char)
		return

	# enter into convert state when context.c started with %
	_stateConvert : (context)->
		_char = context.c
		@_currentLiteral.push(_char)
		switch _char
		#
			when '-' then context.formattingInfo = new FormattingInfo(true, context.formattingInfo.minLength,context.formattingInfo.maxLength);
			when '.' then @_state = STATE.DOT_STATE
			else
				if @_isDigit(_char)
					_tmp = context.formattingInfo
					context.formattingInfo = new FormattingInfo(_tmp.leftAlign, _char - '0', _tmp.maxLength);
					@_state = STATE.MIN_STATE
				else
					@finalizeConverter(_char, context.formattingInfo)
					@_state = STATE.LITERAL_STATE
					context.formattingInfo = FormattingInfo.getDefaultFormattingInfo()
					@_currentLiteral = []
		return

	_stateMin : (context)->
		_char = context.c
		@_currentLiteral.push(_char)
		if @_isDigit(_char)
			_tmp = context.formattingInfo
			context.formattingInfo = new FormattingInfo(_tmp.leftAlign, (_tmp.minLength * 10) + (_char - '0'), _tmp.maxLength);
		else if _char == '.'
			@_state = STATE.DOT_STATE
		else
			# generate converter
			@finalizeConverter(_char, context.formattingInfo)
			@_state = STATE.LITERAL_STATE
			context.formattingInfo = FormattingInfo.getDefaultFormattingInfo()
			@_currentLiteral = []
		return

	_stateDot : (context)->
		_char = context.c
		@_currentLiteral.push(_char)
		if @_isDigit(_char)
			_tmp = context.formattingInfo
			context.formattingInfo = new FormattingInfo(_tmp.leftAlign, _tmp.minLength, _char - '0');
			@_state = STATE.MAX_STATE
		else
			# throw error
			console.error("Error occured in position #{@_index} was expecting digit, instead got char #{_char}")
			@_state = STATE.LITERAL_STATE
		return

	_stateMax : (context)->
		_char = context.c
		@_currentLiteral.push(_char)
		if @_isDigit(_char)
			_tmp = context.formattingInfo
			context.formattingInfo = new FormattingInfo(_tmp.leftAlign, _tmp.minLength, (_tmp.maxLength * 10) + (_char - '0'))
		else
			@finalizeConverter(_char, context.formattingInfo)
			@_state = STATE.LITERAL_STATE
			context.formattingInfo = FormattingInfo.getDefaultFormattingInfo()
			@_currentLiteral = []
		return

	_isDigit : (c)->
		c >= '0' and c <= '9'

	_isWord : (c)->
		(c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')

	###
        Processes a format specifier sequence.

		@param c initial character of format specifier.
		@param index current position in conversion pattern.
		@param formattingInfo current field specifier.
		@return position after format specifier sequence.
	###
	finalizeConverter : (c, formattingInfo)->
		_converterChars = []
		@extractConverter(c, _converterChars)
		#TODO converterId and converterName
		converterId = _converterChars.join("")
		options = []

		@extractOptions(options)

		_patternConverter = @createConverter(converterId, options)

		if _patternConverter == null
			msg = null

			if converterId == null or converterId.length == 0
				msg = "Empty conversion specifier starting at position #{converterId}"
			else
				msg = "Unrecognized conversion specifier #{converterId} starting at position #{converterId}"

			console.error("error:#{msg}")
			@_patternConverters.push(new LiteralPatternConverter(@_currentLiteral.join("")))
			@_formattingInfos.push(FormattingInfo.getDefaultFormattingInfo())
		else
			@_patternConverters.push(_patternConverter)
			@_formattingInfos.push(formattingInfo)

			if @_currentLiteral.length > 0
				@_patternConverters.push(new LiteralPatternConverter(@_currentLiteral.join("")))
				@_formattingInfos.push(FormattingInfo.getDefaultFormattingInfo())

		@_currentLiteral = []
		return

	###
        Extract the converter identifier found at position i

        After this function returns, the variable i will point to the
		first char after the end of the converter identifier.

		If i points to a char which is not a character acceptable at the
		start of a unicode identifier, the value null is returned.

        @param lastChar last processed character.
		@param pattern format string.
		@param index current index into pattern format.
		@param @converterChars array to receive conversion specifier.
		@return position in pattern after converter.
	###
	extractConverter : (lastChar, converterChars)->
		# When this method is called, lastChar points to the first character of the
		# conversion word. For example:
		# For "%hello"     lastChar = 'h'
		# For "%-5hello"   lastChar = 'h'
		# return i if lastChar is word？?
		return if not @_isWord(lastChar)
		converterChars.push(lastChar)
		while (_tmp = @_pattern.charAt(@_index))? and @_index < @_pattern.length and (@_isWord(_tmp) or @_isDigit(_tmp))
			converterChars.push(_tmp)
			@_currentLiteral.push(_tmp)
			@_index++
		return

	###
        Extract converter options.

        @param pattern conversion pattern.
        @param index start of options in pattern.
        @param options array to receive extracted options
        @return position in pattern after options
	###
	extractOptions : (options)->
		breakFlag = false
		while @_index < @_pattern.length and @_pattern.charAt(@_index) == '{' and not breakFlag
			end = @_pattern.indexOf('}', @_index)
			if end == -1
				breakFlag = true
			else
				r = @_pattern.substring(@_index + 1, end)
				options.push(r)
				@_index = end + 1
		return

	createConverter : (converterId, options)->
		converterName = converterId
		converterClass = null
		i = converterId.length
		while i > 0 and not converterClass?
			converterName = converterName.substring(0, i)
			if not converterClass? and RULES != null
				converterClass = RULES[converterName]
			i--
		if not converterClass?
			console.error("Unrecognized format specifier #{converterId}")
		@_currentLiteral.splice(0, @_currentLiteral.length - (converterId.length - converterName.length))
		if converterClass?
			return new converterClass(options)
		else
			null

exports.PatternParser = PatternParser