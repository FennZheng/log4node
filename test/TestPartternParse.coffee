PatternParser = require("../pattern/pattern_parser").PatternParser
#TODO add mocha
patternConverts = []
formattingInfos = []
parser = new PatternParser()
#TODO %c{2} %d{HH:mm:ss,SSS} {} 参数有效，但是会显示出参数？
#TODO %-min.max -表示左对齐 min表示最小宽度 max表示最大宽度
parser.parse("%-2.3c{2} %d{yyyy-MM-dd} [%t]] %p %n", patternConverts, formattingInfos)
console.log("patternConverts length #{patternConverts.length}, detail:"+JSON.stringify(patternConverts))
console.log("formattingInfos length #{formattingInfos.length}, detail:"+JSON.stringify(formattingInfos))

msg = "hahahahahahaha"

context = {}
context.loggerName = "exampleLogger"
context.level = "info"
context.out = ""
for convert in patternConverts
	console.log("convert name :"+convert.__proto__.constructor.name)
	if convert?
		convert.format(context)

console.log(context.out)