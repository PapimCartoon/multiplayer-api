package come2play_as3.api.auto_copied
{
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.*;
	import flash.external.*;
	import flash.net.*;
	import flash.system.System;
	
	// IMPORTANT: this class is automatically copied to the emulator and to the container, so make changes only in the API 
	public class LocalConnectionUser
	{
		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = "42";
		
		private static var someMovieClip:MovieClip;
		public static function error(msg:String):void {
			var msg:String = "An ERRRRRRRRRRROR occurred:\n"+msg;
			System.setClipboard(msg);
			AS3_vs_AS2.showError(someMovieClip, msg);
			trace("\n\n\n"+msg+"\n\n\n");
		}
		public static function throwError(msg:String):void {
			error("Throwing an error with message="+msg+"." + (!AS3_vs_AS2.isAS3 ? "" :  "The error was thrown in this location="+AS3_vs_AS2.error2String(new Error())));
			throw new Error(msg);
		}		
		public static function assert(val:Boolean, args:Array):void {
			if (!val) throwError("Assertion failed with arguments: "+args.join(" , "));
		}
		public static function getDoChanelString(sPrefix:String):String {
			return "DO_CHANEL_"+sPrefix;
		}
		public static function getGotChanelString(sPrefix:String):String {
			return "GOT_CHANEL_"+sPrefix;
		}
		public static function getPrefixFromFlashVars(_someMovieClip:MovieClip):String {
			var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
			var sPrefix:String = parameters["prefix"];
			if (sPrefix==null) sPrefix = parameters["?prefix"];
			return getPrefixFromString(sPrefix);
		}		
		public static function getPrefixFromString(sPrefix:String):String {
			if (sPrefix!=null && !(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) { //it is not necessarily a number 
				trace("calling a javascript function that should return the random fixed id");
				var jsResult:Object = ExternalInterface.call(sPrefix);
				sPrefix = ''+jsResult;
			}
			return sPrefix;
		}
				
		
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var sSendChanel:String;
		
		//Constructor
		public function LocalConnectionUser(_someMovieClip:MovieClip, isServer:Boolean, sPrefix:String) {
			try{
				someMovieClip = _someMovieClip;
				if (sPrefix==null) {
					trace("WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally.\n\n\n\n\n\n");
					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;
				}				
				lcUser = new LocalConnection();
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				var sDoChanel:String = getDoChanelString(sPrefix);
				var sGotChanel:String = getGotChanelString(sPrefix);
				var sListenChannel:String = 
					isServer ? sDoChanel : sGotChanel;
				sSendChanel = 
					!isServer ? sDoChanel : sGotChanel;				
				myTrace(": LocalConnection listens on channel="+sListenChannel+" and sends on "+sSendChanel);
				lcUser.connect(sListenChannel);
			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		private function myTrace(msg:String):void {
			trace(AS3_vs_AS2.getClassName(this)+": "+msg);
		}
		
        private function passError(withObj:Object, err:Error):void {
        	try{
				error("Error occurred when passing "+JSON.stringify(withObj)+", the error is="+AS3_vs_AS2.error2String(err));
				gotError(withObj, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				error("Another error occurred when calling gotError. The new error is="+AS3_vs_AS2.error2String(err2));
			}
        }
		public function gotError(withObj:Object, err:Error):void {}
        
        public function gotMessage(msg:API_Message):void {}
        
        public function sendMessage(msg:API_Message):void {
        	myTrace('sendMessage: '+msg);        						  
			try{
				lcUser.send(sSendChanel, "localconnection_callback", msg);  
			}catch(err:Error) { 
				passError(msg, err);
			}        	
        }
        
        public function localconnection_callback(msgObj:Object):void {
        	try{
        		myTrace("localconnection_callback: "+JSON.stringify(msgObj));
        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);
        		var msg:API_Message = deserializedMsg as API_Message;
        		if (msg==null) throw new Error("msgObj is not an API_Message");
        		gotMessage(msg);
			} catch(err:Error) { 
				passError(msgObj, err);
			} 
        }
	}
}