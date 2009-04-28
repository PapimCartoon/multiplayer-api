// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/ErrorHandler.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.utils.Dictionary;
	import flash.utils.getTimer;
		
public final class ErrorHandler
{
	public function toString():String { // we put in the traces new ErrorHandler()
		return getOngoingTimers();
	}
	public static function getOngoingTimers():String {
		var res:Array = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

		res.push("My stack traces:");	
		res.push( getStackTraces() );
		res.push("\n");
					
		res.push("My ongoingIntervals:");
		for each (var arr1:Array in ongoingIntervals) {
			res.push( "\t"+JSON.stringify(arr1) );
		}
		res.push("\n");
		res.push("My ongoingTimeouts:\n");

// This is a AUTOMATICALLY GENERATED! Do not change!

		for each (var arr2:Array in ongoingTimeouts) {
			res.push( "\t"+JSON.stringify(arr2) );
		}
		res.push("\n");		
		return res.join("\n");
	}
	public static function getStackTraces():String {
		return "\t"+my_stack_trace.join(",\n\t");
	}
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	// returns the bug_id (or -1 if we already reported an error)
	private static var ErrorReport_LOG:Logger = new Logger("ErrorReport",10);
	public static function alwaysTraceAndSendReport(msg:String, args:Object):int {
		ErrorReport_LOG.log([msg, args]);
		return sendReport(msg);
	}
	
	/**
	 * Error handling should be done in one central place.

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * In flash however there is a lot of asynchronous code in:
	 *  setTimeout
	 *  setInterval
	 *  addEventListener and removeEventListener
	 *  and if you have code on keyframes.
	 * Use the methods here below instead of the AS3 version, because	 
	 * all these methods should be wrapped with catch clauses.
	 * 
	 * If your code has try&catch, then in the catch use handleError.
	 * 

// This is a AUTOMATICALLY GENERATED! Do not change!

	 */ 
	private static var ongoingIntervals:Dictionary = new Dictionary();//also printed in traces
	private static var ongoingTimeouts:Dictionary = new Dictionary();//also printed in traces	
	public static function myTimeout(zoneName:String, func:Function, milliseconds:int):Object {
		var timeout_id:Object;
		var newFunc:Function = 
				function (...args):void { 
					modifyOngoing(false, true, zoneName, timeout_id, "myTimeout ticked",milliseconds);
					func.apply(null,args);
				};

// This is a AUTOMATICALLY GENERATED! Do not change!

		timeout_id = AS3_vs_AS2.unwrappedSetTimeout(zoneName, newFunc, milliseconds);
		modifyOngoing(true, true, zoneName, timeout_id, "myTimeout set", milliseconds);
		return timeout_id;			
	}
	public static function myInterval(zoneName:String, func:Function, milliseconds:int):Object {
		var interval_id:Object = AS3_vs_AS2.unwrappedSetInterval(zoneName, func, milliseconds);
		modifyOngoing(true, false, zoneName, interval_id, "myInterval set", milliseconds);
		return interval_id;		
	}
	public static function myClearTimeout(zoneName:String, id:Object):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		modifyOngoing(false, true, zoneName, id, "myTimeout cleared", -1);
		AS3_vs_AS2.unwrappedClearTimeout(zoneName, id);			
	}
	public static function myClearInterval(zoneName:String, id:Object):void {
		modifyOngoing(false, false, zoneName, id, "myInterval cleared", -1);
		AS3_vs_AS2.unwrappedClearInterval(zoneName, id);			
	}		
	private static var LOG:Logger = new Logger("myTimeouts",10);
	private static function modifyOngoing(isAdd:Boolean, isTimeout:Boolean, zoneName:String, id:Object, reason:String, milliseconds:int):void {
		var arr:Object = isTimeout ? ongoingTimeouts : ongoingIntervals;

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (isAdd) {
			StaticFunctions.assert(arr[id]==null, "Internal error! already added id=",[id]);
			arr[id] = [zoneName, milliseconds];
		} else {
			var info:Array = arr[id];
			StaticFunctions.assert(info!=null && info[0]==zoneName, "there is no such zoneName!",["reason=",reason, " zoneName=",zoneName," info=", info]);
			milliseconds = info[1];
			delete arr[id];
		}			
		LOG.log([reason, zoneName, id, milliseconds]);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
				
	
	private static var my_stack_trace:Array = [];
	public static function wrapWithCatch(zoneName:String, func:Function):Function {
		var longerName:String = zoneName; //Extra stack traces are not needed because we use zoneName for all events:  +(my_stack_trace.length==0 ? "" : " with first stacktrace: {\n"+my_stack_trace[0]+"\n}");
		return function (...args):void { 
			catchErrors(longerName,func,args);
		};
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static var ZONE_LOGGER_SIZE:int = 6;
	private static var ZONE_LOGGERS:Object/*String->Logger*/ = {};
	public static function catchErrors(zoneName:String, func:Function, args:Array):Object {
		var res:Object = null;		
		
		var toInsert:Object = [zoneName,"t:",getTimer(),"args=",args]; // I couldn't find a way to get the function name (describeType(func) only returns that the method is a closure)
		my_stack_trace.push(toInsert);
		var logger:Logger = ZONE_LOGGERS[zoneName];
		if (logger==null) {
			logger = new Logger("CATCH-"+zoneName,ZONE_LOGGER_SIZE);

// This is a AUTOMATICALLY GENERATED! Do not change!

			ZONE_LOGGERS[zoneName] = logger;
		}
		logger.log("ENTERED");
		
		var wasError:Boolean = false;			
		try {		
			res = func.apply(null, args); 
		} catch (err:Error) { handleError(err, args); }
			
		logger.log("EXITED");

// This is a AUTOMATICALLY GENERATED! Do not change!

			
		var poped:Object = my_stack_trace.pop(); 
			// I tried to do the pop inside a "finally" clause (to handle correctly cases with exceptions), 
			//but I got "undefined" errors:
			//		undefined
			//			at come2play_as3.util::General$/stackTrace()
			//			at come2play_as3.util::General$/catchErrors() 
		if (!didReportError && toInsert!=poped) 
			alwaysTraceAndSendReport("BAD stack behaviour (multithreaded flash?)", [my_stack_trace, toInsert, poped]);
		return res;				

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function handleError(err:Error, obj:Object):void {
		alwaysTraceAndSendReport("handleError: "+AS3_vs_AS2.error2String(err),[" catching-arguments=",obj]);
	}	

	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var didReportError:Boolean = false; // we report only 1 error (usually 1 error leads to others)
	// If the container has a bug, then it adds the traces of the game, reports to ASP, and send to java. 
	// If the game has a bug, then it sends DoAllFoundHacker (which cause the container to send a bug report)  
	public static var SEND_BUG_REPORT:Function = null; 

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static function sendReport(errStr:String):int {
		if (didReportError) return -1;
		didReportError = true;
		
		var bug_id:int = StaticFunctions.random(1, 10000000);	
		
		try {	
			var err:Error = new Error();
			var stackTraces:String = AS3_vs_AS2.myGetStackTrace(err); // null in the release version
			if (stackTraces!=null) ErrorReport_LOG.log(["Catching point stack trace=",err]);

// This is a AUTOMATICALLY GENERATED! Do not change!

							
			ErrorReport_LOG.log(["sendReport for error=", errStr," SEND_BUG_REPORT=",SEND_BUG_REPORT]);
			
			var errMessage:String = 
				(stackTraces==null ? "" : "AAAA (with stack trace) ")+ // so I will easily find them in our "errors page"
				"Revision="+StaticFunctions.getRevision()+": "+
				errStr;
			
			if (SEND_BUG_REPORT!=null)
				SEND_BUG_REPORT(bug_id, errMessage);	

// This is a AUTOMATICALLY GENERATED! Do not change!

				
			// we should show the error after we call sendMultipartImage (so we send the image without the error window)
			if (SHOULD_SHOW_ERRORS) {
				var msg:String = "ERROR "+errMessage+"\n\ntraces:\n\n"+StaticFunctions.getTraces();
				AS3_vs_AS2.showError(msg);
				StaticFunctions.setClipboard(msg);
			}		
		} catch (err:Error) {
			AS3_vs_AS2.showError("!!!!!ERROR!!!! in sendReport:"+AS3_vs_AS2.error2String(err));
		}			

// This is a AUTOMATICALLY GENERATED! Do not change!

		return bug_id;
	}
}
}
