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
	
public final class Logger
{
	private static var ALL_LOGGERS:Array = [];
	public static var MAX_LOGGERS_NUM:int = 200;
	public static var TRACE_PREFIX:String = ""; // because in flashlog you see traces of many users and it is all mixed 
		
	// Be careful that the traces will not grow too big to send to the java (limit of 1MB, enforced in Bytes2Object)
	public static var MAX_TRACES:Object = {};

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	private static var CURR_TRACE_ID:int = 0;
	
	private var name:String;
	private var maxTraces:int;
	private var traces:Array = [];
	public function Logger(name:String, maxTraces:int) {
		this.name = name;
		this.maxTraces = MAX_TRACES[name]!=null ? int(MAX_TRACES[name]) : maxTraces;
		ALL_LOGGERS.push(this);

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (ALL_LOGGERS.length>MAX_LOGGERS_NUM) throw new Error("Passed MAX_LOGGERS_NUM!");
	}
	public function toString():String { return "Logger "+name; }
	
	public function log(/*<InAS3>*/...obj/*</InAS3>*/  /*<InAS2>*obj:Object*</InAS2>*/):void {
		try {
			if (maxTraces<=0) return;
			 
			var traceLine:Array = [++CURR_TRACE_ID, "t:", getTimer(), name, obj];
			StaticFunctions.limitedPush(traces, traceLine , maxTraces); // we discard old traces

// This is a AUTOMATICALLY GENERATED! Do not change!

			if (StaticFunctions.SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + " " + name+":\t" + JSON.stringify(traceLine));
		} catch (err:Error) {
			if (StaticFunctions.SHOULD_CALL_TRACE) trace(RANDOM_PREFIX+TRACE_PREFIX + "\n\n\n\n\n\n\n\n\n\n\n\nERROR!!!!!!!!!!!!!!!!!!!!!!! err="+AS3_vs_AS2.error2String(err)+"\n\n\n\n\n\n\n\n\n\n\n");
		}
	}
	
	private static var keyTraces:Array = [];	
	public static var RANDOM_PREFIX:String = "Rnd"+int(100+Math.random()*900)+": ";
	public static function getTraces():String {
		var res:Array = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

		for each (var logger:Logger in ALL_LOGGERS) {
			res.push.apply(null,logger.traces);
		}		
		// I sort the traces		
		res.sort(function (arg1:Array, arg2:Array):int {
			return arg1[0] - arg2[0];
		});
		return arrToString(res,",\n");
	}
	private static function arrToString(s:Object, sep:String):String {			

// This is a AUTOMATICALLY GENERATED! Do not change!

		var arr:Array = new Array();
		var isArr:Boolean = AS3_vs_AS2.isArray(s);			
		for(var o:String in s) {
			arr.push((isArr ? "" : o+"=")+JSON.stringify(s[o]));
		}
		return "["+arr.join(sep)+"]";
	}

}
}
