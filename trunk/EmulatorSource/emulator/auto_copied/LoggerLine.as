// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/LoggerLine.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.utils.getTimer;
	
	public final class LoggerLine
	{
		private static var CURR_TRACE_ID:int = 0;
		
		public var maxLen:int;
		public var traceId:int;
		public var traceTime:int;
		public var loggerName:String;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public var obj:Object;
		
		public function LoggerLine(maxLen:int, loggerName:String,obj:Object) {
			traceId = ++CURR_TRACE_ID;
			traceTime = getTimer();
			this.maxLen = maxLen;
			this.loggerName = loggerName;
			this.obj = obj;
		}
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
