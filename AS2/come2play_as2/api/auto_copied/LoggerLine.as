	
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.LoggerLine
	{
		private static var CURR_TRACE_ID:Number = 0;
		public static var LINE_INDENT:Number = 0;
		
		public var maxLen:Number;
		public var traceId:Number;
		public var traceTime:Number;
		public var loggerName:String;
		public var obj:Object;
		public var indent:Number;
		
		public function LoggerLine(maxLen:Number, loggerName:String,obj:Object) {
			traceId = ++CURR_TRACE_ID;
			traceTime = getTimer();
			indent = LINE_INDENT;
			this.maxLen = maxLen;
			this.loggerName = loggerName;
			this.obj = obj;
		}
	}
