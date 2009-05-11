	
/**
 * Important: a logger is never garbage-collected!!!
 * After you created a logger, it is put in a static array,
 * and when getTraces is called, all the traces from all the loggers
 * are combined into a single time-line.
 * 
 * IMPORTANT for AS2:
 * We use static Loggers:
 * static var LOG:Logger = new Logger(...)
 * Therefore, to prevent init cycles, the class Logger must not use any other class
 * (e.g., JSON or StaticFunctions!)
 * It creates crazy weird bugs in AS2 (but not in AS3)
 */ 
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.Logger
{
	public static var ALL_LOGGERS:Array = [];
	public static var MAX_LOGGERS_NUM:Number = 500;
		
	// Be careful that the traces will not grow too big to send to the java (limit of 1MB, enforced in Bytes2Object)
	public static var MAX_TRACES:Object = {};
	
	
	private var name:String;
	private var maxTraces:Number;
	private var traces:Array/*LoggerLine*/ = [];
	public function Logger(name:String, maxTraces:Number) {
		this.name = name;
		this.maxTraces = MAX_TRACES[name]!=null ? int(MAX_TRACES[name]) : maxTraces;
		ALL_LOGGERS.push(this);
		if (ALL_LOGGERS.length>MAX_LOGGERS_NUM) throw new Error("Passed MAX_LOGGERS_NUM! ALL_LOGGERS="+ALL_LOGGERS);
	}
	public function toString():String { return "Logger "+name; }
	
	public static var MAX_TRACE_LEN:Number = 10000;	//10KB
	public static var MAX_HUGE_LEN:Number 	= 500000;	//500KB
	
	// the game traces are a single huge traceline
	public function hugeLog(/*InAS3: ...args*/):Void { var args:Array = arguments.slice(0); 
		limitedLog(MAX_HUGE_LEN,args);		
	}
	public function log(/*InAS3: ...args*/):Void { var args:Array = arguments.slice(0); 
		limitedLog(MAX_TRACE_LEN,args);
	}
	public function limitedLog(maxTraceLen:Number, obj:Object):Void {
		if (maxTraces<=0) return;
			 
		var traceLine:LoggerLine = new LoggerLine(maxTraceLen,name,obj);
		limitedPush(traces, traceLine , maxTraces); // we discard old traces
	}
	public static function limitedPush(arr:Array, element:Object, maxSize:Number):Void {
		if (arr.length>=maxSize) arr.shift(); // we discard old elements (in a queue-like manner)
		arr.push(element);
	}	
	public function getMyTraces():Array/*LoggerLine*/ {
		return traces;
	}
}
