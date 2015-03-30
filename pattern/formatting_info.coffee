
class FormattingInfo
	# length = 8
	SPACES = ['','','','','','','',''].join("")

	constructor : (leftAlign, minLength, maxLength)->
		@leftAlign = leftAlign;
		@minLength = minLength;
		@maxLength = maxLength;

	# Adjust the content of the buffer based on the specified lengths and alignment
	# @param fieldStart start of field in buffer
	# @param string to be modified
	format : (fieldStart, out)->
		# 实际长度
		_result = ""
		_rawLength = out.length - fieldStart

		if _rawLength > @maxLength
			# cut off
			_result = out.slice(0, fieldStart + @maxLength + 1)

		else if _rawLength < @minLength
			# 左对齐 填充右边
			if @leftAlign
				_fieldEnd = out.length

				_blankLength = (fieldStart + @minLength) - _fieldEnd
				_result = out

				while(_blankLength-- > 0)
					_result += ' '
			else
				# 右对齐 填充左边
				_padLength = @minLength - _rawLength
				# [0 -> fieldStart] copy to _tmp
				_result = out.slice(0, fieldStart)
				# batch append
				while(_padLength >= 8)
					_result += SPACES
					_padLength -= 8
				while(_padLength-- > 0)
					_result += " "
				_result = _result + out.slice(fieldStart, out.length)
		_result

FormattingInfo.getDefaultFormattingInfo = ()->
	new FormattingInfo(false, 0, 999999)

exports.FormattingInfo = FormattingInfo

