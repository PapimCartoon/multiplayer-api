package come2play_as3.api.auto_copied
{
	import flash.utils.getTimer;
	
/**
 * Important: a logger is never garbage-collected!!!
 * After you created a logger, it is put in a static array,
 * and when getTraces is called, all the traces from all the loggers
 * are combined into a single time-line.
 */ 
public final class Logger
{
	private static var ALL_LOGGERS:Array = [];
	public static var MAX_LOGGERS_NUM:int = 500;
	public static var TRACE_PREFIX:String = ""; // because in flashlog you see traces of many users and it is all mixed 
		
	// Be careful that the traces will not grow too big to send to the java (limit of 1MB, enforced in Bytes2Object)
	public static var MAX_TRACES:Object = {};
	
	private static var CURR_TRACE_ID:int = 0;
	
	private var name:String;
	private var maxTraces:int;
	private var traces:Array = [];
	public function Logger(name:String, maxTraces:int) {
		this.name = name;
		this.maxTraces = MAX_TRACES[name]!=null ? int(MAX_TRACES[name]) : maxTraces;
		ALL_LOGGERS.push(this);
		if (ALL_LOGGERS.length>MAX_LOGGERS_NUM) throw new Error("Passed MAX_LOGGERS_NUM! ALL_LOGGERS="+ALL_LOGGERS);
	}
	public function toString():String { return "Logger "+name; }
	
	public function log(/*<InAS3>*/...obj/*</InAS3>*/  /*<InAS2>obj:Object</InAS2>*/):void {
		try {
			if (maxTraces<=0) return;
			 
			var traceLine:Array = [++CURR_TRACE_ID, "t:", getTimer(), name, obj];
			StaticFunctions.limitedPush(traces, traceLine , maxTraces); // we discard old traces
			if (StaticFunctions.SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + " " + name+":\t" + JSON.stringify(traceLine));
		} catch (err:Error) {
			if (StaticFunctions.SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + "\n\n\n\n\n\n\n\n\n\n\n\nERROR!!!!!!!!!!!!!!!!!!!!!!! err="+AS3_vs_AS2.error2String(err)+"\n\n\n\n\n\n\n\n\n\n\n");
		}
	}
	public function getMyTraces():String {
		return arrToString(traces,MAX_PER_STRING,MAX_TOTAL);
	}
	
	private static var keyTraces:Array = [];	
	public static var RANDOM_PREFIX:String = "Rnd"+int(100+Math.random()*900)+": ";
	
	public static function getTraces():String {
		return getTracesOfLoggers(ALL_LOGGERS,MAX_PER_STRING,MAX_TOTAL);
	}
	public static function getTracesOfLoggers(loggers:Array/*Logger*/, maxPerString:int, maxTotal:int):String {		
		var res:Array = [];
		for each (var logger:Logger in loggers) {
			res.push.apply(null,logger.traces);
		}		
		// I sort the traces		
		res.sort(function (arg1:Array, arg2:Array):int {
			return arg1[0] - arg2[0];
		});
		return arrToString(res, maxPerString, maxTotal);
	}
	public static var MAX_PER_STRING:int 	= 20000;	//20KB
	public static var MAX_TOTAL:int 		= 2000000;	//2000KB
	private static function arrToString(arr:Array, maxPerString:int, maxTotal:int):String {			
		var res:Array = new Array();
		var len:int = 0;
		// the latest traces are the most important
		for (var i:int = arr.length-1; i>=0; i--) {
			var s:String = StaticFunctions.cutString(JSON.stringify(arr[i]), maxPerString);
			len += s.length;
			if (len>=maxTotal) break;
			res.push(s); 
		}
		res.reverse();
		return "["+res.join(",\n")+"]";
	}

}
}