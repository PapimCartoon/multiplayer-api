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
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	 
	public class LocalConnectionUser
	{

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static var VERSION_FOR_TRACE:int = 7;
		public static var REVIEW_USER_ID:int = -1; // special userId that is used for reviewing games
		public static var IS_LOCAL_CONNECTION_UDERSCORE:Boolean = false;		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = ""+StaticFunctions.random(1,10000);
		public static var MILL_WAIT_BEFORE_DO_REGISTER:int = 500;
		public static var MILL_AFTER_ALLOW_DOMAINS:int = 500;
		public static var DO_TRACE:Boolean = true;
		public static var AGREE_ON_PREFIX:Boolean = true;
		public static var ALLOW_DOMAIN:String = "*";
		public static function showError(msg:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

			StaticFunctions.showError(msg);
		}
		public static function throwError(msg:String):void {
			StaticFunctions.throwError(msg);
		}		
		public static function assert(val:Boolean, args:Array):void {
			if (!val) StaticFunctions.assert(false, args);
		}

		// I added the "_" on purpose because of different domains issues, see: http://livedocs.adobe.com/flex/gumbo/langref/flash/net/LocalConnection.html

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function getDoChanelString(sRandomPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_DO_CHANEL_"+sRandomPrefix;
			return "DO_CHANEL_"+sRandomPrefix;
		}
		public static function getGotChanelString(sRandomPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_GOT_CHANEL_"+sRandomPrefix;
			return "GOT_CHANEL_"+sRandomPrefix;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function getInitChanelString(sPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_INIT_CHANEL_"+sPrefix;
			return "INIT_CHANEL_"+sPrefix;
		}
		public static function getPrefixFromFlashVars(_someMovieClip:DisplayObjectContainer):String {
			var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
			var sPrefix:String = parameters["prefix"];
			if (sPrefix==null) sPrefix = parameters["?prefix"];
			return getPrefixFromString(sPrefix);

// This is a AUTOMATICALLY GENERATED! Do not change!

		}		
		public static function getPrefixFromString(sPrefix:String):String {			
			return sPrefix;
		}
				
		
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var lcInit:LocalConnection;
		private var sSendChanel:String;

// This is a AUTOMATICALLY GENERATED! Do not change!

		private var sInitChanel:String;
		private var isServer:Boolean;
		private var randomPrefix:String;
		private var sendPrefixIntervalId:uint;
		private var connectionMade:Boolean;
		public var verifier:ProtocolVerifier;
		public var _shouldVerify:Boolean;
		//Constructor
		public function LocalConnectionUser(_someMovieClip:DisplayObjectContainer, isServer:Boolean, sPrefix:String,shouldVerify:Boolean) {
			

// This is a AUTOMATICALLY GENERATED! Do not change!

				if (!isServer) // in the container we apply the reflection in RoomLogic (e.g., for a room we do not have a localconnection) 
					StaticFunctions.performReflectionFromFlashVars(_someMovieClip);
				connectionMade = false;
				StaticFunctions.allowDomains();	
				StaticFunctions.storeTrace(["VERSION_FOR_TRACE=",VERSION_FOR_TRACE]);
				_shouldVerify=shouldVerify;
				AS3_vs_AS2.registerNativeSerializers();
				API_LoadMessages.useAll();	
				verifier = new ProtocolVerifier();
				this.isServer = isServer;

// This is a AUTOMATICALLY GENERATED! Do not change!

				StaticFunctions.storeTrace(["ProtocolVerifier=",verifier]);
				StaticFunctions.someMovieClip = _someMovieClip;
				if (sPrefix==null) {
					myTrace(["WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally."]);
					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;
				}
				sInitChanel = getInitChanelString(sPrefix);		
				if(MILL_AFTER_ALLOW_DOMAINS == 0){
					buildConnection();
				}else{

// This is a AUTOMATICALLY GENERATED! Do not change!

					AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this,this.buildConnection),MILL_AFTER_ALLOW_DOMAINS);	
				}			
		}
		
		private function buildConnection():void{
			try{
				if(AGREE_ON_PREFIX){
					lcInit = createLocalConnection()
					AS3_vs_AS2.addStatusListener(lcInit, this, ["localconnection_init"],  AS3_vs_AS2.delegate(this, this.connectionHandler));
					if(isServer){

// This is a AUTOMATICALLY GENERATED! Do not change!

						randomPrefix = String(StaticFunctions.random(1,1000000));
						myTrace(["Attempting to send the randomPrefix with which LocalConnections will communicate... randomPrefix=",randomPrefix])
						localconnection_init(randomPrefix);
						sendPrefixIntervalId = setInterval(AS3_vs_AS2.delegate(this, this.sendPrefix),MILL_WAIT_BEFORE_DO_REGISTER);
					}else{
						myTrace(["started listening to stuff on ",sInitChanel])
						lcInit.connect(sInitChanel);	
					}	
				}else{
					localconnection_init(sInitChanel)

// This is a AUTOMATICALLY GENERATED! Do not change!

				}	

			}catch (err:Error) { 
				passError("Constructor",err);
			}
			
		}
		
		private function connectionHandler(isSuccess:Boolean):void {
			myTrace(["connectionHandler sending random prefix isSuccess: "+isSuccess]);

// This is a AUTOMATICALLY GENERATED! Do not change!

			if ((isSuccess) || (connectionMade)) {
				connectionMade = true		
				clearInterval(sendPrefixIntervalId);
			}
		}

		public function myTrace(msg:Array):void {	
			if(DO_TRACE)			
				StaticFunctions.storeTrace([AS3_vs_AS2.getClassName(this),": ",msg]);
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		
        protected function getErrorMessage(withObj:Object, err:Error):String {
        	return "Error occurred when passing "+JSON.stringify(withObj)+", the error is=\n\t\t"+AS3_vs_AS2.error2String(err);
        }
        private function passError(withObj:Object, err:Error):void {
        	showError(getErrorMessage(withObj,err));        	
        }
        
        public function gotMessage(msg:API_Message):void {}
        

// This is a AUTOMATICALLY GENERATED! Do not change!

       
        public function sendMessage(msg:API_Message):void {
        	if (msg is API_DoRegisterOnServer){
        		if (lcUser != null)
        			reallySendMessage(msg);
        		else
        			AS3_vs_AS2.myTimeout(AS3_vs_AS2.delegate(this, this.sendMessage,msg),MILL_WAIT_BEFORE_DO_REGISTER);	
        	} else {
        		reallySendMessage(msg);
        	}

// This is a AUTOMATICALLY GENERATED! Do not change!

        }
        private function sendPrefix():void {  				  
			try{
				myTrace(["sent randomPrefix on ",sInitChanel," randomPrefix sent is:",randomPrefix," Is server: ",isServer]);	
				lcInit.send(sInitChanel, "localconnection_init", randomPrefix);  
			}catch(err:Error) { 				
				passError("prefix error,prefix :"+randomPrefix, err);
			}        	
        }
        private function reallySendMessage(msg:API_Message):void {  				  

// This is a AUTOMATICALLY GENERATED! Do not change!

			try{
        		myTrace(['sendMessage: ',msg]);      		
				AS3_vs_AS2.checkObjectIsSerializable(msg);
        		verify(msg, true);     		
				lcUser.send(sSendChanel, "localconnection_callback", msg.toObject());  
			}catch(err:Error) { 
				passError(msg, err);
			}        	
        }
        private function verify(msg:API_Message, isSend:Boolean):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

        	if (!_shouldVerify) return;
        	if (isServer!=isSend)
    			verifier.msgFromGame(msg);
    		else
    			verifier.msgToGame(msg);        	
        }  
        private function createLocalConnection():LocalConnection{
        	var lc:LocalConnection = new LocalConnection();
        	if(StaticFunctions.ALLOW_DOMAINS != null)
				lc.allowDomain(StaticFunctions.ALLOW_DOMAINS)

// This is a AUTOMATICALLY GENERATED! Do not change!

			myTrace(["locoal connection Domain",lc.domain])	
			return lc;
        }
        public function localconnection_init(sRandomPrefix:String):void {
        	if (StaticFunctions.DID_SHOW_ERROR) return;
        	try{
        		myTrace(["got sRandomPrefix",sRandomPrefix,isServer]);
        		if (!isServer)
        			lcInit.close();
        		lcUser = createLocalConnection()

// This is a AUTOMATICALLY GENERATED! Do not change!

				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				var sDoChanel:String = getDoChanelString(sRandomPrefix);
				var sGotChanel:String = getGotChanelString(sRandomPrefix);
				var sListenChannel:String = 
					isServer ? sDoChanel : sGotChanel;
				sSendChanel = 
					!isServer ? sDoChanel : sGotChanel;				
				myTrace(["LocalConnection listens on channel=",sListenChannel," and sends on ",sSendChanel]);
				lcUser.connect(sListenChannel);

// This is a AUTOMATICALLY GENERATED! Do not change!

			} catch(err:Error) { 
				passError("local connection init",err);
			} 
        }
                   
        public function localconnection_callback(msgObj:Object):void {
        	if (StaticFunctions.DID_SHOW_ERROR) return;
        	var msg:API_Message = null;
        	try{
        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);

// This is a AUTOMATICALLY GENERATED! Do not change!

        		msg = /*as*/deserializedMsg as API_Message;
        		if (msg==null) throwError("msgObj="+JSON.stringify(msgObj)+" is not an API_Message");
        		
        		myTrace(['gotMessage: ',msg]);
        		verify(msg, false);
        		gotMessage(msg);
			} catch(err:Error) { 
				passError(msg==null ? msgObj : msg, err);
			} 
        }

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
