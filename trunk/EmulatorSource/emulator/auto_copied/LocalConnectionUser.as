// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/LocalConnectionUser.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import emulator.auto_generated.*;
	
	import flash.display.*;
	import flash.external.*;
	import flash.net.*;
	 
	public class LocalConnectionUser
	{		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = ""+StaticFunctions.random(1,10000);
		

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		}		
		public static function getPrefixFromString(sPrefix:String):String {
			if (sPrefix!=null && !(sPrefix.charAt(0)>='0' && sPrefix.charAt(0)<='9')) { //it is not necessarily a number 
				trace("calling a javascript function that should return the random fixed id");
				var jsResult:Object = ExternalInterface.call(sPrefix);
				sPrefix = ''+jsResult;
			}
			return sPrefix;
		}
				

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var sSendChanel:String;
		
		//Constructor
		public function LocalConnectionUser(_someMovieClip:MovieClip, isServer:Boolean, sPrefix:String) {
			try{
				API_LoadMessages.useAll();	
				StaticFunctions.someMovieClip = _someMovieClip;

// This is a AUTOMATICALLY GENERATED! Do not change!

				if (sPrefix==null) {
					myTrace(["WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally."]);
					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;
				}				
				lcUser = new LocalConnection();
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				var sDoChanel:String = getDoChanelString(sPrefix);
				var sGotChanel:String = getGotChanelString(sPrefix);
				var sListenChannel:String = 

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

			StaticFunctions.storeTrace([AS3_vs_AS2.getClassName(this),": ",msg]);
		}
		
        protected function getErrorMessage(withObj:Object, err:Error):String {
        	return "Error occurred when passing "+JSON.stringify(withObj)+", the error is="+AS3_vs_AS2.error2String(err);
        }
        private function passError(withObj:Object, err:Error):void {
        	showError(getErrorMessage(withObj,err));        	
        }
        

// This is a AUTOMATICALLY GENERATED! Do not change!

        public function gotMessage(msg:API_Message):void {}
        
        public function sendMessage(msg:API_Message):void {
        	myTrace(['sendMessage: ',msg]);
        	if (msg is API_DoRegisterOnServer)
        		AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.reallySendMessage,msg),100);
        	else
        		reallySendMessage(msg);
        }
        private function reallySendMessage(msg:API_Message):void {        						  

// This is a AUTOMATICALLY GENERATED! Do not change!

			try{
				AS3_vs_AS2.checkObjectIsSerializable(msg);
				lcUser.send(sSendChanel, "localconnection_callback", msg);  
			}catch(err:Error) { 
				passError(msg, err);
			}        	
        }
        
        public function localconnection_callback(msgObj:Object):void {
        	try{

// This is a AUTOMATICALLY GENERATED! Do not change!

        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);
        		var msg:API_Message = deserializedMsg as API_Message;
        		if (msg==null) throwError("msgObj="+JSON.stringify(msgObj)+" is not an API_Message");
        		
        		myTrace(['gotMessage: ',msg]);
        		gotMessage(msg);
			} catch(err:Error) { 
				passError(msgObj, err);
			} 
        }

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
