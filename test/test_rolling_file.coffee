#Author: 梁志
#Copyright 2005-, Funshion Online Technologies Ltd. All Rights Reserved
#版权 2005-，北京风行在线技术有限公司 所有版权保护
#This is UNPUBLISHED PROPRIETARY SOURCE CODE of Funshion Online Technologies Ltd.
#the contents of this file may not be disclosed to third parties, copied or
#duplicated in any form, in whole or in part, without the prior written
#permission of Funshion Online Technologies Ltd.
#这是北京风行在线技术有限公司未公开的私有源代码。本文件及相关内容未经风行在线技术有
#限公司事先书面同意，不允许向任何第三方透露，泄密部分或全部 也不允许任何形式的私自备份.

# purpose: 单元测试，测试Logger模块的各个函数
require 'should'
getLogTimeStamp = require('../appender/rolling_file_appender.js').getLogTimeStamp

describe 'getLogTimeStamp', ->
	describe 'test interval of 1day', ->
		it 'test timestamp of 00:00:00, should 00:00:00', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 1, new Date('2013-04-09 00:00:00'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
		it 'test timestamp of 07:59:59, should 00:00:00', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 1, new Date('2013-04-09 07:59:59'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
		it 'test timestamp of 08:00:00, should 000000', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 1, new Date('2013-04-09 08:00:00'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
		it 'test timestamp of 23:59:59', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 1, new Date('2013-04-09 23:59:59'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
		
	describe 'test interval of 0.5days', ->
		it 'test timestamp of 00:00:00', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 0.5, new Date('2013-04-09 00:00:00'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
			
		it 'test timestamp of 07:59:59', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 0.5, new Date('2013-04-09 07:59:59'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
			
		it 'test timestamp of 08:00:00', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 0.5, new Date('2013-04-09 08:00:00'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
			
		it 'test timestamp of 11:59:59', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 0.5, new Date('2013-04-09 11:59:59'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409000000')
			
		it 'test timestamp of 12:00:00', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 0.5, new Date('2013-04-09 12:00:00'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409120000')
			
		it 'test timestamp of 23:59:59', ->
			stamp1 = getLogTimeStamp(86400 * 1000 * 0.5, new Date('2013-04-09 23:59:59'))
			stamp1 = (new Date(stamp1)).format('yyyyMMddHHmmss')
			stamp1.should.equal('20130409120000')

