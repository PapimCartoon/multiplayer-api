	import come2play_as2.util.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI 
	{
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = "42";
		
		private static var someMovieClip:MovieClip;
		public static function error(msg:String):Void {
			var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg;
			System.setClipboard(msg);
			AS3_vs_AS2.showError(someMovieClip, msg);
			trace("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"+msg+"\n\n\n\n\n\n\n\n\n");
		}
		public static function throwError(msg:String):Void {
			error("Throwing an error with message="+msg+"." + (!AS3_vs_AS2.isAS3 ? "" :  "The error was thrown in this location="+AS3_vs_AS2.error2String(new Error())));
			throw new Error(msg);
		}		
		public static function assert(val:Boolean, args:Array):Void {
			if (!val) BaseGameAPI.throwError("Assertion failed with arguments: "+args.join(" , "));
		}
		public static function getDoChanelString(sPrefix:String):String {
			return "DO_CHANEL_"+sPrefix;
		}
		public static function getGotChanelString(sPrefix:String):String {
			return "GOT_CHANEL_"+sPrefix;
		}
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var hackerUserId:Number = -1;
		private var sDoChanel:String;
		private var sGotChanel:String;
		
		//Constructor
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			try{
				someMovieClip = _someMovieClip;
				var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(someMovieClip);
				var sPrefix:String = parameters["prefix"];
				if (sPrefix==null) sPrefix = parameters["?prefix"];
				if (sPrefix==null) {
					trace("WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally.\n\n\n\n\n\n");
					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;
					new SinglePlayerEmulator(_someMovieClip);
				}
				if (!(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) { //it is not necessarily a number 
					trace("calling a javascript function that should return the random fixed id");
					var jsResult:Object = ExternalInterface.call(sPrefix);
					sPrefix = ''+jsResult;
				}
				
				lcUser = new LocalConnection();
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				sDoChanel = getDoChanelString(sPrefix);
				sGotChanel = getGotChanelString(sPrefix);
				trace("Board connects on channel="+sGotChanel);
				lcUser.connect(sGotChanel);
			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		
        private function passError(inFunctionName:String, err:Error):Void {
        	try{
				error("Error occurred when calling "+inFunctionName+", the error is="+AS3_vs_AS2.error2String(err));
				gotError(inFunctionName, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				error("Another error occurred when calling gotError("+inFunctionName+","+AS3_vs_AS2.error2String(err)+"). The new error is="+AS3_vs_AS2.error2String(err2));
			}
        }
		public function gotError(inFunctionName:String, err:Error):Void {
			sendMessage( new API_DoAllFoundHacker(hackerUserId, "Got error inFunctionName="+inFunctionName+" err="+AS3_vs_AS2.error2String(err)) );
		}
        private function sendMessage(msg:API_Message):Void {
        	trace('sendMessage: '+msg);        						  
			try{
				lcUser.send(sDoChanel, "localconnection_callback", msg.methodName, msg.parameters);  
			}catch(err:Error) { 
				passError(msg.methodName, err);
			}        	
        }
        private function gotMessage(msg:API_Message):Void {
        	trace("gotMessage: "+msg);
    		if (msg instanceof API_GotStateChanged) {
    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
    			hackerUserId = serverEntry.storedByUserId;
    		}
    		if (!AS3_vs_AS2.hasOwnProperty(this,msg.methodName)) return
    		var func:Function = this[msg.methodName] /*as Function*/;
			if (func==null) return;
			func.apply(this, msg.parameters);        	
        }
        public function localconnection_callback(methodName:String, parameters:Array/*Object*/):Void {
        	try{
        		gotMessage(API_Message.createMessage(methodName, parameters));        		
			} catch(err:Error) { 
				passError(methodName, err);
			} finally {
				sendMessage( new API_DoFinishedCallback(methodName) );
			}
        }
	}
