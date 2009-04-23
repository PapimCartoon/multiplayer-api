	
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.LoggerLine
	{
		private static var CURR_TRACE_ID:Number = 0;
		
		public var maxLen:Number;
		public var traceId:Number;
		public var traceTime:Number;
		public var loggerName:String;
		public var obj:Object;
		
		public function LoggerLine(maxLen:Number, loggerName:String,obj:Object) {
			traceId = ++CURR_TRACE_ID;
			traceTime = getTimer();
			this.maxLen = maxLen;
			this.loggerName = loggerName;
			this.obj = obj;
		}
		public function toString():String {
			var line:String = "id="+traceId+"\tt="+traceTime+"\t"+loggerName+"\t"+JSON.stringify(obj);
			return StaticFunctions.cutString(line, maxLen); 
		}
	}
