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
		
public final class ErrorHandler
{
	public function toString():String { // we put in the traces new ErrorHandler()
		return getOngoingTimers();
	}
	public static function getOngoingTimers():String {
		var res:Array = [];
		res.push("ERROR REPORT FROM:");

// This is a AUTOMATICALLY GENERATED! Do not change!

		res.push(ERROR_REPORT_PREFIX);
		res.push("My stack traces:");	
		res.push( getStackTraces() );
		res.push("\n");
					
		res.push("My ongoingIntervals:");
		for each (var arr1:Array in ongoingIntervals) {
			res.push( "\t"+JSON.stringify(arr1) );
		}
		res.push("\n");

// This is a AUTOMATICALLY GENERATED! Do not change!

		res.push("My ongoingTimeouts:\n");
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
	public static function alwaysTraceAndSendReport(msg:String, args:Object):int {
		StaticFunctions.alwaysTrace([msg, args]);
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
		var newFunc:Function = wrapWithCatch(zoneName, 
				function (/*<InAS3>*/...args/*</InAS3>*/):void  { 
					modifyOngoing(false, true, zoneName, timeout_id, "myTimeout ticked",milliseconds);
					func.apply(null, 
						/*<InAS3>*/args/*</InAS3>*/

// This is a AUTOMATICALLY GENERATED! Do not change!

						/*<InAS2>arguments</InAS2>*/
					);
				});
		timeout_id = AS3_vs_AS2.unwrappedSetTimeout(zoneName, newFunc, milliseconds);
		modifyOngoing(true, true, zoneName, timeout_id, "myTimeout set", milliseconds);
		return timeout_id;			
	}
	public static function myInterval(zoneName:String, func:Function, milliseconds:int):Object {
		var interval_id:Object = AS3_vs_AS2.unwrappedSetInterval(zoneName, wrapWithCatch(zoneName, func), milliseconds);
		modifyOngoing(true, false, zoneName, interval_id, "myInterval set", milliseconds);

// This is a AUTOMATICALLY GENERATED! Do not change!

		return interval_id;		
	}
	public static function myClearTimeout(zoneName:String, id:Object):void {
		modifyOngoing(false, true, zoneName, id, "myTimeout cleared", -1);
		AS3_vs_AS2.unwrappedClearTimeout(zoneName, id);			
	}
	public static function myClearInterval(zoneName:String, id:Object):void {
		modifyOngoing(false, false, zoneName, id, "myInterval cleared", -1);
		AS3_vs_AS2.unwrappedClearInterval(zoneName, id);			
	}		

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static var TRACE_TIMERS:Boolean = true;
	private static function modifyOngoing(isAdd:Boolean, isTimeout:Boolean, zoneName:String, id:Object, reason:String, milliseconds:int):void {
		var arr:Object = isTimeout ? ongoingTimeouts : ongoingIntervals;
		if (isAdd) {
			StaticFunctions.assert(arr[id]==null, ["Internal error! already added id=",id]);
			arr[id] = [zoneName, milliseconds];
		} else {
			var info:Array = arr[id];
			StaticFunctions.assert(info!=null && info[0]==zoneName, ["Trying to ",reason, " zoneName=",zoneName," but there is no such zoneName! info=", info]);
			milliseconds = info[1];

// This is a AUTOMATICALLY GENERATED! Do not change!

			delete arr[id];
		}			
		if (TRACE_TIMERS) StaticFunctions.tmpTrace([reason, zoneName, id, milliseconds]);
	}
				
	
	private static var my_stack_trace:Array = [];
	public static function wrapWithCatch(zoneName:String, func:Function):Function {
		var longerName:String = zoneName+(my_stack_trace.length==0 ? "" : " with first stacktrace: {\n"+my_stack_trace[0]+"\n}");
		return function (/*<InAS3>*/...args/*</InAS3>*/):void { 

// This is a AUTOMATICALLY GENERATED! Do not change!

			catchErrors(longerName, func, 
					/*<InAS3>*/args/*</InAS3>*/
					/*<InAS2>arguments</InAS2>*/
				);
		};
	}	
	public static function catchErrors(zoneName:String, func:Function, args:Array):Object {
		var res:Object = null;		
		
		var stack_trace_len:int = my_stack_trace.length;

// This is a AUTOMATICALLY GENERATED! Do not change!

		my_stack_trace.push(["args=",args," zoneName=",zoneName]); // I couldn't find a way to get the function name (describeType(func) only returns that the method is a closure)
		
		var wasError:Boolean = false;			
		try {		
			res = func.apply(null, args); 
		} catch (err:Error) { handleError(err, args); }	
			
		my_stack_trace.pop(); 
			// I tried to do the pop inside a "finally" clause (to handle correctly cases with exceptions), 
			//but I got "undefined" errors:

// This is a AUTOMATICALLY GENERATED! Do not change!

			//		undefined
			//			at come2play_as3.util::General$/stackTrace()
			//			at come2play_as3.util::General$/catchErrors() 
		if (!didReportError && my_stack_trace.length!=stack_trace_len) 
			alwaysTraceAndSendReport("BAD stack behaviour", my_stack_trace);
		return res;				
	}
	public static var ERROR_REPORT_PREFIX:String = "DISTRIBUTION"; // where did the error come from?
	public static function handleError(err:Error, obj:Object):void {
		alwaysTraceAndSendReport("handleError: "+AS3_vs_AS2.error2String(err),[" catching-arguments=",obj]);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}	

	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var didReportError:Boolean = false; // we report only 1 error (usually 1 error leads to others)
	// If the container has a bug, then it adds the traces of the game, reports to ASP, and send to java. 
	// If the game has a bug, then it sends DoAllFoundHacker (which cause the container to send a bug report)  
	public static var SEND_BUG_REPORT:Function = null; 
	private static function sendReport(errStr:String):int {
		if (didReportError) return -1;
		didReportError = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		var bug_id:int = StaticFunctions.random(1, 10000000);	
		
		try {	
			var err:Error = new Error();
			var stackTraces:String = AS3_vs_AS2.myGetStackTrace(err); // null in the release version
			if (stackTraces!=null) StaticFunctions.alwaysTrace(["Catching point stack trace=",err]);
							
			StaticFunctions.alwaysTrace(["sendReport for error=", errStr," SEND_BUG_REPORT=",SEND_BUG_REPORT]);
			

// This is a AUTOMATICALLY GENERATED! Do not change!

			var errMessage:String = 
				(stackTraces==null ? "" : "AAAA (with stack trace) ")+ // so I will easily find them in our "errors page"
				"Revision="+StaticFunctions.getRevision()+": "+
				ERROR_REPORT_PREFIX + " " +
				errStr;
			
			if (SEND_BUG_REPORT!=null)
				SEND_BUG_REPORT(bug_id, errMessage);	
				
			// we should show the error after we call sendMultipartImage (so we send the image without the error window)

// This is a AUTOMATICALLY GENERATED! Do not change!

			if (SHOULD_SHOW_ERRORS) {
				var msg:String = "ERROR "+errMessage+" traces="+StaticFunctions.getTraces();
				AS3_vs_AS2.showError(msg);
				StaticFunctions.setClipboard(msg);
			}		
		} catch (err:Error) {
			AS3_vs_AS2.showError("!!!!!ERROR!!!! in sendReport:"+AS3_vs_AS2.error2String(err));
		}			
		return bug_id;
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}
