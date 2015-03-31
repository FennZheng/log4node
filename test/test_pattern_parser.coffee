require 'should'
PatternParser = require("../pattern/pattern_parser").PatternParser
timeRegex = /^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/

describe 'PatternParser:parse', ->
	describe 'test %d', ->
		patternConverts = []
		formattingInfos = []
		parser = new PatternParser()
		it '%d{yyyy-mm-dd hh:mm:ss}', ->
			parser.parse("%d{yyyy-MM-dd HH:mm:ss}", patternConverts, formattingInfos)
			patternConverts.length.should.equal(1)
			formattingInfos.length.should.equal(1)
			context = {}
			context.out = ""
			patternConverts[0].format(context)
			timeRegex.test(context.out).should.equal(true)