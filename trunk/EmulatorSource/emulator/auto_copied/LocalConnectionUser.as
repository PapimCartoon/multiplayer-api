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
		public static var REVIEW_USER_ID:int = -1; // special userId that is used for reviewing games		
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
		public static function getInitChanelString(sPrefix:String):String {
			return "INIT_CHANEL_"+sPrefix;
		}
		public static function getPrefixFromFlashVars(_someMovieClip:DisplayObjectContainer):String {
			var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);

// This is a AUTOMATICALLY GENERATED! Do not change!

			var sPrefix:String = parameters["prefix"];
			if (sPrefix==null) sPrefix = parameters["?prefix"];
			return getPrefixFromString(sPrefix);
		}		
		public static function getPrefixFromString(sPrefix:String):String {			
			return sPrefix;
		}
				
		
		// we use a LocalConnection to communicate with the container

// This is a AUTOMATICALLY GENERATED! Do not change!

		private var lcUser:LocalConnection; 
		private var lcInit:LocalConnection;
		private var sSendChanel:String;
		private var sInitChanel:String;
		private var isServer:Boolean;
		private var prefix:String;
		public var verifier:ProtocolVerifier;
		public var _shouldVerify:Boolean;
		//Constructor
		public function LocalConnectionUser(_someMovieClip:DisplayObjectContainer, isServer:Boolean, sPrefix:String,shouldVerify:Boolean) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			try{
				_shouldVerify=shouldVerify;
				AS3_vs_AS2.registerNativeSerializers();
				API_LoadMessages.useAll();	
				verifier = new ProtocolVerifier();
				this.isServer = isServer;
				StaticFunctions.storeTrace(["ProtocolVerifier=",verifier]);
				StaticFunctions.someMovieClip = _someMovieClip;
				if (sPrefix==null) {
					myTrace(["WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally."]);

// This is a AUTOMATICALLY GENERATED! Do not change!

					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;
				}	
				lcInit = new LocalConnection();
				sInitChanel = getInitChanelString(sPrefix);
				AS3_vs_AS2.addStatusListener(lcInit, this, ["localconnection_init"],  AS3_vs_AS2.delegate(this, this.connectionHandler));
				if(isServer){
					myTrace(["started sending stuff"])
					prefix = String(Math.floor(Math.random()*1000000));
					localconnection_init(prefix) 
					AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendPrefix),(MILL_WAIT_BEFORE_DO_REGISTER));

// This is a AUTOMATICALLY GENERATED! Do not change!

				}else{
					myTrace(["started listening to stuff on ",sInitChanel])
					lcInit.connect(sInitChanel);	
				}		

			}catch (err:Error) { 
				passError("Constructor",err);
			}
		}
		private function connectionHandler(isSuccess:Boolean):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

			myTrace(["connectionHandler isSuccess : ",isSuccess])
			if(isSuccess){
				//localconnection_init(prefix) 	
			}else{
				AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendPrefix),(MILL_WAIT_BEFORE_DO_REGISTER*10));
			}
		}

		public function myTrace(msg:Array):void {			
			StaticFunctions.storeTrace([AS3_vs_AS2.getClassName(this),": ",msg]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		
        protected function getErrorMessage(withObj:Object, err:Error):String {
        	return "Error occurred when passing "+JSON.stringify(withObj)+", the error is=\n\t\t"+AS3_vs_AS2.error2String(err);
        }
        private function passError(withObj:Object, err:Error):void {
        	showError(getErrorMessage(withObj,err));        	
        }
        
        public function gotMessage(msg:API_Message):void {}

// This is a AUTOMATICALLY GENERATED! Do not change!

        
        public static var MILL_WAIT_BEFORE_DO_REGISTER:int = 100;
        public function sendMessage(msg:API_Message):void {
        	myTrace(['sendMessage: ',msg]);      		
        	if (msg is API_DoRegisterOnServer){
        		if(lcUser != null)
        			reallySendMessage(msg);
        		else
        			AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendMessage,msg),MILL_WAIT_BEFORE_DO_REGISTER);	
        	}else{

// This is a AUTOMATICALLY GENERATED! Do not change!

        		trace("realy send doregister")
        		reallySendMessage(msg);
        	}
        }
        private function sendPrefix():void {  				  
			try{
				myTrace(["sent prefix on ",sInitChanel," prefix sent is:",prefix,isServer]);	
				lcInit.send(sInitChanel, "localconnection_init", prefix);  
			}catch(err:Error) { 
				

// This is a AUTOMATICALLY GENERATED! Do not change!

				passError("prefix error,prefix :"+prefix, err);
			}        	
        }
        private function reallySendMessage(msg:API_Message):void {  				  
			try{
				AS3_vs_AS2.checkObjectIsSerializable(msg);
        		verify(msg, true);     		
				lcUser.send(sSendChanel, "localconnection_callback", msg.toObject());  
			}catch(err:Error) { 
				passError(msg, err);

// This is a AUTOMATICALLY GENERATED! Do not change!

			}        	
        }
        private function verify(msg:API_Message, isSend:Boolean):void {
        	if (!_shouldVerify) return;
        	if (isServer!=isSend)
    			verifier.msgFromGame(msg);
    		else
    			verifier.msgToGame(msg);        	
        }  
        public function localconnection_init(sPrefix:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

        	if (StaticFunctions.DID_SHOW_ERROR) return;
        	try{
        		myTrace(["got prefix",sPrefix,isServer]);
        		if(!isServer)
        			lcInit.close();
        		lcUser = new LocalConnection();
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				var sDoChanel:String = getDoChanelString(sPrefix);
				var sGotChanel:String = getGotChanelString(sPrefix);

// This is a AUTOMATICALLY GENERATED! Do not change!

				var sListenChannel:String = 
					isServer ? sDoChanel : sGotChanel;
				sSendChanel = 
					!isServer ? sDoChanel : sGotChanel;				
				myTrace(["LocalConnection listens on channel=",sListenChannel," and sends on ",sSendChanel]);
				lcUser.connect(sListenChannel);
			} catch(err:Error) { 
				passError("local connection init",err);
			} 
        }

// This is a AUTOMATICALLY GENERATED! Do not change!

                   
        public function localconnection_callback(msgObj:Object):void {
        	if (StaticFunctions.DID_SHOW_ERROR) return;
        	trace("realy got doregister")
        	var msg:API_Message = null;
        	try{
        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);
        		msg = /*as*/deserializedMsg as API_Message;
        		if (msg==null) throwError("msgObj="+JSON.stringify(msgObj)+" is not an API_Message");
        		

// This is a AUTOMATICALLY GENERATED! Do not change!

        		myTrace(['gotMessage: ',msg]);
        		verify(msg, false);
        		gotMessage(msg);
			} catch(err:Error) { 
				passError(msg==null ? msgObj : msg, err);
			} 
        }
	}
}
