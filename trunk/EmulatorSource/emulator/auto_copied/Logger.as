// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/Logger.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.utils.getTimer;
	
/**
 * Important: a logger is never garbage-collected!!!
 * After you created a logger, it is put in a static array,
 * and when getTraces is called, all the traces from all the loggers
 * are combined into a single time-line.
 * 
 * IMPORTANT for AS2:
 * We use static Loggers:

// This is a AUTOMATICALLY GENERATED! Do not change!

 * static var LOG:Logger = new Logger(...)
 * Therefore, to prevent init cycles, the class Logger must not use any other class
 * (e.g., JSON or StaticFunctions!)
 * It creates crazy weird bugs in AS2 (but not in AS3)
 */ 
public final class Logger
{
	public static var ALL_LOGGERS:Array = [];
	public static var MAX_LOGGERS_NUM:int = 500;
	public static var TRACE_PREFIX:String = ""; // because in flashlog you see traces of many users and it is all mixed 

// This is a AUTOMATICALLY GENERATED! Do not change!

		
	// Be careful that the traces will not grow too big to send to the java (limit of 1MB, enforced in Bytes2Object)
	public static var MAX_TRACES:Object = {};
	
	
	private var name:String;
	private var maxTraces:int;
	private var traces:Array/*LoggerLine*/ = [];
	public function Logger(name:String, maxTraces:int) {
		this.name = name;

// This is a AUTOMATICALLY GENERATED! Do not change!

		this.maxTraces = MAX_TRACES[name]!=null ? int(MAX_TRACES[name]) : maxTraces;
		ALL_LOGGERS.push(this);
		if (ALL_LOGGERS.length>MAX_LOGGERS_NUM) throw new Error("Passed MAX_LOGGERS_NUM! ALL_LOGGERS="+ALL_LOGGERS);
	}
	public function toString():String { return "Logger "+name; }
	
	// todo: add "unlimitedTrace" or add the size of each trace line
	public static var MAX_TRACE_LEN:int = 10000;	//10KB
	public static var MAX_HUGE_LEN:int 	= 500000;	//500KB
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	// the game traces are a single huge traceline
	public function hugeLog(...args):void {
		limitedLog(MAX_HUGE_LEN,args);		
	}
	public function log(...args):void {
		limitedLog(MAX_TRACE_LEN,args);
	}
	public function limitedLog(maxTraceLen:int, obj:Object):void {
		if (maxTraces<=0) return;
			 

// This is a AUTOMATICALLY GENERATED! Do not change!

		var traceLine:LoggerLine = new LoggerLine(maxTraceLen,name,obj);
		limitedPush(traces, traceLine , maxTraces); // we discard old traces
	}
	public static function limitedPush(arr:Array, element:Object, maxSize:int):void {
		if (arr.length>=maxSize) arr.shift(); // we discard old elements (in a queue-like manner)
		arr.push(element);
	}	
	public function getMyTraces():Array/*LoggerLine*/ {
		return traces;
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}
