import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.ErrorHandler
{
	public function toString():String { // we put in the traces new ErrorHandler()
		return getOngoingTimers();
	}
	public static function getOngoingTimers():String {
		var res:Array = [];
		res.push("My stack traces:");	
		res.push( my_stack_trace.join(",\n") );
		res.push("\n");
					
		res.push("My ongoingIntervals:");
		var p13:Number=0; for (var i13:String in ongoingIntervals) { var arr1:Array = ongoingIntervals[ongoingIntervals.length==null ? i13 : p13]; p13++;
			res.push( "\t"+JSON.stringify(arr1) );
		}
		res.push("\n");
		res.push("My ongoingTimeouts:\n");
		var p18:Number=0; for (var i18:String in ongoingTimeouts) { var arr2:Array = ongoingTimeouts[ongoingTimeouts.length==null ? i18 : p18]; p18++;
			res.push( "\t"+JSON.stringify(arr2) );
		}
		res.push("\n");		
		return res.join("\n");
	}
	
	
	// returns the bug_id (or -1 if we already reported an error)
	public static function alwaysTraceAndSendReport(msg:String, args:Object):Number {
		StaticFunctions.alwaysTrace([msg, args]);
		return sendReport(msg);
	}
	private static var error_report_url:String = null; // on LocalHost I don't want to send bug reports, so I throw an error instead
	public static function setErrorReportUrl(url_parameters:Object):Void {		
		error_report_url = url_parameters["error_report_url"];
	}
	public static function getErrorReportUrl():String { return error_report_url; }
	public static function testSendErrorImage():Void {	
		// I want to test reporting an error even on localhost
		T.initI18n({},{isSendErrorImage:true});
		ErrorHandler.setErrorReportUrl({error_report_url: "http://facebook.come2play.com/shared/flex_object/error_report.asp"});
    	ErrorHandler.alwaysTraceAndSendReport("User chose to send BugReport!", "BUG DESCRIPTION");
	}	
	/**
	 * Error handling should be done in one central place.
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
	 */ 
	private static var ongoingIntervals:Object = {};//also printed in traces
	private static var ongoingTimeouts:Object = {};//also printed in traces	
	public static function myTimeout(zoneName:String, func:Function, milliseconds:Number):Number {
		var timeout_id:Number;
		var newFunc:Function = wrapWithCatch(zoneName, 
				function (/*<InAS3>...args</InAS3>*/):Void  { 
					modifyOngoing(false, true, zoneName, timeout_id, "myTimeout ticked",milliseconds);
					func.apply(null, 
						/*<InAS3>args</InAS3>*/
						/*<InAS2>*/arguments/*</InAS2>*/
					);
				});
		timeout_id = AS3_vs_AS2.unwrappedSetTimeout(newFunc, milliseconds);
		modifyOngoing(true, true, zoneName, timeout_id, "myTimeout set", milliseconds);
		return timeout_id;			
	}
	public static function myInterval(zoneName:String, func:Function, milliseconds:Number):Number {
		var interval_id:Number = AS3_vs_AS2.unwrappedSetInterval(wrapWithCatch(zoneName, func), milliseconds);
		modifyOngoing(true, false, zoneName, interval_id, "myInterval set", milliseconds);
		return interval_id;		
	}
	public static function myClearTimeout(zoneName:String, id:Number):Void {
		modifyOngoing(false, true, zoneName, id, "myTimeout cleared", -1);
		AS3_vs_AS2.unwrappedClearTimeout(id);			
	}
	public static function myClearInterval(zoneName:String, id:Number):Void {
		modifyOngoing(false, false, zoneName, id, "myInterval cleared", -1);
		AS3_vs_AS2.unwrappedClearInterval(id);			
	}		
	public static var TRACE_TIMERS:Boolean = true;
	private static function modifyOngoing(isAdd:Boolean, isTimeout:Boolean, zoneName:String, id:Number, reason:String, milliseconds:Number):Void {
		var arr:Object = isTimeout ? ongoingTimeouts : ongoingIntervals;
		if (isAdd) {
			StaticFunctions.assert(arr[id]==null, ["Internal error! already added id=",id]);
			arr[id] = [zoneName, milliseconds];
		} else {
			var info:Array = arr[id];
			StaticFunctions.assert(info!=null && info[0]==zoneName, ["Trying to ",reason, " zoneName=",zoneName," but there is no such zoneName! info=", info]);
			milliseconds = info[1];
			delete arr[id];
		}			
		if (TRACE_TIMERS) StaticFunctions.tmpTrace([reason, zoneName, id, milliseconds]);
	}
				
	
	private static var my_stack_trace:Array = [];
	private static function stackTrace(zoneName:String, func:Function, args:Array):Object {
		var res:Object = null;			
		
		var stack_trace_len:Number = my_stack_trace.length;
		my_stack_trace.push([zoneName, args]); // I couldn't find a way to get the function name (describeType(func) only returns that the method is a closure)
		
		var wasError:Boolean = false;
		res = func.apply(null, args); 
		my_stack_trace.pop(); 
			// I tried to do the pop inside a "finally" clause (to handle correctly cases with exceptions), 
			//but I got "undefined" errors:
			//		undefined
			//			at come2play_as2.util::General$/stackTrace()
			//			at come2play_as2.util::General$/catchErrors() 
		if (!didReportError && my_stack_trace.length!=stack_trace_len) 
			alwaysTraceAndSendReport("BAD stack behaviour", my_stack_trace);
		return res;		
	}			
	public static function wrapWithCatch(zoneName:String, func:Function):Function {
		return function (/*<InAS3>...args</InAS3>*/):Void { 
			catchErrors(zoneName, func, 
					/*<InAS3>args</InAS3>*/
					/*<InAS2>*/arguments/*</InAS2>*/
				);
		};
	}	
	public static function catchErrors(zoneName:String, func:Function, args:Array):Object {
		var res:Object = null;			
		try {
			res = stackTrace(zoneName, func, args);
		} catch (err:Error) { handleError(err, args); }		
		return res; 			
	}
	public static function handleError(err:Error, obj:Object):Void {
		try {
			var stackTraces:String = AS3_vs_AS2.myGetStackTrace(err); // null in the release version
			var errStr:String = 
				(stackTraces==null ? "" : "AAAA (with stack trace) ")+ // so I will easily find them in our "errors page"
				AS3_vs_AS2.error2String(err)+
				(stackTraces==null ? "" :
					"\n\tStackTrace="+stackTraces+
					"\n\tCatching point stack trace="+AS3_vs_AS2.myGetStackTrace(new Error()));
			var errMsg:Array = ["\n\n\n\n\n\n\n\n\n\n\n\n\n\nERROR OCCURRED: catching-arguments: ",
				obj,"\n",
				errStr];
			alwaysTraceAndSendReport(errStr, errMsg);
		} catch (err:Error) {
			if (error_report_url==null) throw err;
			StaticFunctions.alwaysTrace(["Error occurred in handleError, err=",err]);				
		}		
	}	

	public static var SHOULD_SHOW_ERRORS:Boolean = true;
	public static var flash_url:String;
	public static var didReportError:Boolean = false; // we report only 1 error (usually 1 error leads to others)
	public static var SEND_BUG_REPORT:Function = null; // to send the bug report to the java as well
	private static function sendReport(errStr:String):Number {
		if (didReportError) return -1;
		didReportError = true;
		StaticFunctions.alwaysTrace(["sendReport to url=",error_report_url," for error=", errStr," SEND_BUG_REPORT=",SEND_BUG_REPORT]);
		var bug_id:Number = StaticFunctions.random(1, 10000000);
		var errMessage:String = "Revision="+StaticFunctions.getRevision()+": "+errStr;
		var flashTraces:String = StaticFunctions.getTraces();
				
		
		// we might have errors in the XML, so I want to get <error_report_url> from the URL (not the XML)  
		if (error_report_url==null) {
			throw new Error("Reporting an error: "+errStr);
		} else {
			try {
				AS3_vs_AS2.sendToURL( 
						{errMessage: errMessage, 
						 url: flash_url, 
						 traces: flashTraces,
						 bug_id: bug_id
						 },
					error_report_url);
				if (T.custom("isSendErrorImage",false))
					AS3_vs_AS2.sendMultipartImage(bug_id);
			} catch (err:Error) {
				StaticFunctions.alwaysTrace(["!!!!!ERROR!!!! in sendReport:",err]);
			}						
		}	
		// we should show the error after we call sendMultipartImage (so we send the image without the error window)
		if (SHOULD_SHOW_ERRORS) {
			var msg:String = "ERROR "+errMessage+" traces="+flashTraces;
			AS3_vs_AS2.showError(msg);
			StaticFunctions.setClipboard(msg);
		}	
		if (SEND_BUG_REPORT!=null)
			SEND_BUG_REPORT(bug_id, errMessage, flashTraces);	
		return bug_id;
	}
}
