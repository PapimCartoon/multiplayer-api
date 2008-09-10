package come2play_as3.api.auto_copied
{
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.*;
	import flash.external.*;
	import flash.net.*;
	 
	public class LocalConnectionUser
	{		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = ""+StaticFunctions.random(1,10000);
		public static var SHOULD_CALL_TRACE:Boolean = true;
		
		public static function showError(msg:String):void {
			StaticFunctions.showError(msg);
		}
		public static function throwError(msg:String):void {
			StaticFunctions.throwError(msg);
		}		
		public static function assert(val:Boolean, args:Array):void {
			if (!val) StaticFunctions.assert(false, args);
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
				API_LoadMessages.useAll();	
				StaticFunctions.someMovieClip = _someMovieClip;
				if (sPrefix==null) {
					myTrace(["WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally."]);
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
				myTrace(["LocalConnection listens on channel=",sListenChannel," and sends on ",sSendChanel]);
				lcUser.connect(sListenChannel);
			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		public function myTrace(msg:Array):void {
			if (SHOULD_CALL_TRACE) trace(AS3_vs_AS2.getClassName(this)+": "+JSON.stringify(msg));
		}
		
        private function passError(withObj:Object, err:Error):void {
        	try{
				showError("Error occurred when passing "+JSON.stringify(withObj)+", the error is="+AS3_vs_AS2.error2String(err));
				gotError(withObj, err);
			} catch (err2:Error) { 
				// to avoid an infinite loop, I can't call passError again.
				showError("Another error occurred when calling gotError. The new error is="+AS3_vs_AS2.error2String(err2));
			}
        }
		public function gotError(withObj:Object, err:Error):void {}
        
        public function gotMessage(msg:API_Message):void {}
        
        public function sendMessage(msg:API_Message):void {
        	myTrace(['sendMessage: ',msg]);
        	if (msg is API_DoRegisterOnServer)
        		AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.reallySendMessage,msg),100);
        	else
        		reallySendMessage(msg);
        }
        private function reallySendMessage(msg:API_Message):void {        						  
			try{
				AS3_vs_AS2.checkObjectIsSerializable(msg);
				lcUser.send(sSendChanel, "localconnection_callback", msg);  
			}catch(err:Error) { 
				passError(msg, err);
			}        	
        }
        
        public function localconnection_callback(msgObj:Object):void {
        	try{
        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);
        		var msg:API_Message = deserializedMsg as API_Message;
        		if (msg==null) throwError("msgObj="+JSON.stringify(msgObj)+" is not an API_Message");
        		
        		myTrace(['gotMessage: ',msg]);
        		gotMessage(msg);
			} catch(err:Error) { 
				passError(msgObj, err);
			} 
        }
	}
}