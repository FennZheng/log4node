# purpose: unit test for FormattingInfo:format（leftAlign, minLength，maxLength), full path test.

require 'should'
FormattingInfo = require("../pattern/formatting_info").FormattingInfo

describe 'formattingInfo:format', ->
	describe 'test minWidth and leftAlign', ->
		it 'FormattingInfo(leftAlign = true, minLength = 10, maxLength = 999999)', ->
			formattingInfo = new FormattingInfo(true, 10, 999999)
			it 'format (fieldStart = 2, out = "123456")', ->
				out = formattingInfo.format(2, "123456")
				out.length.should.equal(12)
				out.should.equal('123456    ')

	describe 'test minWidth and rightAlign', ->
		it 'FormattingInfo(leftAlign = false, minLength = 10, maxLength = 999999)', ->
			formattingInfo = new FormattingInfo(false, 10, 999999)
			it 'format (fieldStart = 2, out = "123456")', ->
				out = formattingInfo.format(2, "123456")
				out.length.should.equal(12)
				out.should.equal('12      3456')

	describe 'test maxWidth', ->
		it 'FormattingInfo(leftAlign = true, minLength = 10, maxLength = 999999)', ->
			formattingInfo = new FormattingInfo(true, 10, 999999)
			it 'format (fieldStart = 2, out = "123456789")', ->
				out = formattingInfo.format(2, "123456789")
				out.length.should.equal(8)
				out.should.equal('12345678')