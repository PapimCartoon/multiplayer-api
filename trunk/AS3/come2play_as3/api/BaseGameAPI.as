package come2play_as3.api {
	import come2play_as3.util.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.system.System;
	import flash.utils.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
	public class BaseGameAPI 
	{
		// See method ClientGameAPI.got_user_info
		public static const USER_INFO_KEY_name:String = "name";
		public static const USER_INFO_KEY_avatar_url:String = "avatar_url";
		public static const USER_INFO_KEY_supervisor:String = "supervisor";
		public static const USER_INFO_KEY_credibility:String = "credibility";
		public static const USER_INFO_KEY_game_rating:String = "game_rating";
		
		// See method ClientGameAPI.got_general_info
		public static const GENERAL_INFO_KEY_logo_swf_full_url:String = "logo_swf_full_url";
		
		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = "42";
		
		private static var someMovieClip:MovieClip;
		public static function error(msg:String):void {
			var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg;
			System.setClipboard(msg);
			AS3_vs_AS2.showError(someMovieClip, msg);
			trace("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"+msg+"\n\n\n\n\n\n\n\n\n");
		}
		public static function throwError(msg:String):void {
			error("Throwing an error with message="+msg+"." + (!AS3_vs_AS2.isAS3 ? "" :  "The error was thrown in this location="+AS3_vs_AS2.error2String(new Error())));
			throw new Error(msg);
		}		
		public static function assert(val:Boolean, args:Array):void {
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
		private var hacker_user_id:int = -1;
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
				if (!(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) { //it is not necessarily a number (in InfoContainer we concatenate two numbers using '_')
					trace("calling a javascript function that should return the random fixed id");
					var js_result:Object = ExternalInterface.call(sPrefix);
					sPrefix = ''+js_result;
				}
				
				lcUser = new LocalConnection();
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				sDoChanel = getDoChanelString(sPrefix);
				sGotChanel = getGotChanelString(sPrefix);
				trace("Board connected on channel="+sGotChanel);
				lcUser.connect(sGotChanel);
			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		
        private function passError(in_function_name:String, err:Error):void {
        	try{
				error("Error occurred when calling "+in_function_name+", the error is="+AS3_vs_AS2.error2String(err));
				got_error(in_function_name, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				error("Another error occurred when calling got_error("+in_function_name+","+AS3_vs_AS2.error2String(err)+"). The error is="+AS3_vs_AS2.error2String(err2));
			}
        }
        protected function sendMessage(msg:API_Message):void {
        	sendDoOperation(msg.methodName, msg.parameters);        	
        }
        protected function sendDoOperation(methodName:String, parameters:Array/*Object*/):void {
			trace("sendOperation on channel="+sDoChanel+' for methodName='+methodName+' parameters='+parameters);		  
			try{
				lcUser.send(sDoChanel, "localconnection_callback", methodName, parameters);  
			}catch(err:Error) { 
				passError(methodName, err);
			}      	
        }
        private function getFunction(methodName:String):Function {
        	if (!AS3_vs_AS2.hasOwnProperty(this,methodName)) return null;
			return this[methodName] as Function;
        }
		private function safeApplyFunction(methodName:String, args:Array):Object {			
			var func:Function = getFunction(methodName);
			if (func==null) return null;
			return func.apply(this, args);
		}

        public function localconnection_callback(methodName:String, parameters:Array/*Object*/):void {
        	try{
        		var api_msg:API_Message = API_Message.createMessage(methodName, parameters);
        		trace("got localconnection_callback api_msg="+api_msg);
        		if (api_msg is API_GotStoredState) {
        			var store_state_msg:API_GotStoredState = api_msg as API_GotStoredState;
        			hacker_user_id = store_state_msg.userId;
        		}
        		var params:Array = api_msg.parameters;	
				safeApplyFunction(methodName, params);
			} catch(err:Error) { 
				passError(methodName, err);
			} finally {
				sendMessage( new API_DoFinishedCallback(methodName) );
			}
        }

		
		// In case of an error, you should probably call do_client_protocol_error_with_description
		// You should be very careful not to throw any exceptions in got_error, because they are silently ignored	
		public function got_error(in_function_name:String, err:Error):void {
			sendMessage( new API_DoAllFoundHacker(hacker_user_id, AS3_vs_AS2.error2String(err)) );
		}

	}
}