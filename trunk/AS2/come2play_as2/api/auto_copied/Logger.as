	
/**
 * Important: a logger is never garbage-collected!!!
 * After you created a logger, it is put in a static array,
 * and when getTraces is called, all the traces from all the loggers
 * are combined into a single time-line.
 */ 
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.Logger
{
	private static var ALL_LOGGERS:Array = [];
	public static var MAX_LOGGERS_NUM:Number = 500;
	public static var TRACE_PREFIX:String = ""; // because in flashlog you see traces of many users and it is all mixed 
		
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
	
	// todo: add "unlimitedTrace" or add the size of each trace line
	public static var MAX_TRACE_LEN:Number = 10000;	//10KB
	public static var MAX_HUGE_LEN:Number 	= 500000;	//500KB
	public static var MAX_TOTAL:Number 	= 2000000;	//2000KB
	
	// the game traces are a single huge traceline
	public function hugeLog(...args):Void {
		limitedLog(MAX_HUGE_LEN,args);		
	}
	public function log(...args):Void {
		limitedLog(MAX_TRACE_LEN,args);
	}
	public function limitedLog(maxTraceLen:Number, obj:Object):Void {
		try {
			if (maxTraces<=0) return;
			 
			var traceLine:LoggerLine = new LoggerLine(maxTraceLen,name,obj);
			StaticFunctions.limitedPush(traces, traceLine , maxTraces); // we discard old traces
			if (StaticFunctions.SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + " " + name+":\t" + traceLine.toString());
		} catch (err:Error) {
			if (StaticFunctions.SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + "\n\n\n\n\n\n\n\n\n\n\n\nERROR!!!!!!!!!!!!!!!!!!!!!!! err="+AS3_vs_AS2.error2String(err)+"\n\n\n\n\n\n\n\n\n\n\n");
		}
	}
	public function getMyTraces():String {
		return arrToString(traces,MAX_TOTAL);
	}
	
	private static var keyTraces:Array = [];	
	public static var RANDOM_PREFIX:String = "Rnd"+int(100+Math.random()*900)+": ";
	
	public static function getTraces():String {
		return getTracesOfLoggers(ALL_LOGGERS,MAX_TOTAL);
	}
	public static function getTracesOfLoggers(loggers:Array/*Logger*/, maxTotal:Number):String {		
		var res:Array/*LoggerLine*/ = [];
		var p65:Number=0; for (var i65:String in loggers) { var logger:Logger = loggers[loggers.length==null ? i65 : p65]; p65++;
			res.push.apply(null,logger.traces);
		}		
		// I sort the traces		
		res.sort(function (arg1:LoggerLine, arg2:LoggerLine):Number {
			return arg1.traceId - arg2.traceId;
		});
		return arrToString(res, maxTotal);
	}

	private static function arrToString(arr:Array/*LoggerLine*/, maxTotal:Number):String {			
		var res:Array = new Array();
		var len:Number = 0;
		// the latest traces are the most important
		for (var i:Number = arr.length-1; i>=0; i--) {
			var line:LoggerLine = arr[i];
			var s:String = line.toString();
			len += s.length;
			if (len>=maxTotal) break;
			res.push(s); 
		}
		res.reverse();
		return "["+res.join(",\n")+"]";
	}

}
