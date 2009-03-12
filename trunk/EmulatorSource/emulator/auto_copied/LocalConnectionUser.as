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
		public static var IS_LOCAL_CONNECTION_UDERSCORE:Boolean = false;		

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = ""+StaticFunctions.random(1,10000);
		public static var MILL_WAIT_BEFORE_DO_REGISTER:int = 500;
		public static var MILL_AFTER_ALLOW_DOMAINS:int = 500;
		public static var DO_TRACE:Boolean = true;
		public static var AGREE_ON_PREFIX:Boolean = true;
		public static var ALLOW_DOMAIN:String = "*";
		public static function showError(msg:String):void {
			StaticFunctions.showError(msg);
		}
		public static function throwError(msg:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

			StaticFunctions.throwError(msg);
		}		
		public static function assert(val:Boolean, args:Array):void {
			if (!val) StaticFunctions.assert(false, args);
		}

		// I added the "_" on purpose because of different domains issues, see: http://livedocs.adobe.com/flex/gumbo/langref/flash/net/LocalConnection.html
		public static function getDoChanelString(sRandomPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_DO_CHANEL_"+sRandomPrefix;

// This is a AUTOMATICALLY GENERATED! Do not change!

			return "DO_CHANEL_"+sRandomPrefix;
		}
		public static function getGotChanelString(sRandomPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_GOT_CHANEL_"+sRandomPrefix;
			return "GOT_CHANEL_"+sRandomPrefix;
		}
		public static function getInitChanelString(sPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_INIT_CHANEL_"+sPrefix;

// This is a AUTOMATICALLY GENERATED! Do not change!

			return "INIT_CHANEL_"+sPrefix;
		}
		public static function getPrefixFromFlashVars(_someMovieClip:DisplayObjectContainer):String {
			var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
			var sPrefix:String = parameters["prefix"];
			if (sPrefix==null) sPrefix = parameters["?prefix"];
			return getPrefixFromString(sPrefix);
		}		
		public static function getPrefixFromString(sPrefix:String):String {			
			return sPrefix;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
				
		
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var lcInit:LocalConnection;
		private var sSendChanel:String;
		private var sInitChanel:String;
		private var isContainer:Boolean;
		private var randomPrefix:String;

// This is a AUTOMATICALLY GENERATED! Do not change!

		private var sendPrefixInterval:MyInterval;
		private var handShakeMade:Boolean = false;
		public var verifier:ProtocolVerifier;
		public var _shouldVerify:Boolean;
		//Constructor
		public function LocalConnectionUser(_someMovieClip:DisplayObjectContainer, isContainer:Boolean, sPrefix:String,shouldVerify:Boolean) {
			
				if (!isContainer) // in the container we apply the reflection in RoomLogic (e.g., for a room we do not have a localconnection) 
					StaticFunctions.performReflectionFromFlashVars(_someMovieClip);
				StaticFunctions.allowDomains();	

// This is a AUTOMATICALLY GENERATED! Do not change!

				_shouldVerify=shouldVerify;
				AS3_vs_AS2.registerNativeSerializers();
				API_LoadMessages.useAll();	
				verifier = new ProtocolVerifier();
				this.isContainer = isContainer;
				StaticFunctions.storeTrace(["ProtocolVerifier=",verifier]);
				StaticFunctions.someMovieClip = _someMovieClip;
				if (sPrefix==null) {
					myTrace(["WARNING: didn't find 'prefix' in the loader info parameters. Probably because you are doing testing locally."]);
					sPrefix = DEFAULT_LOCALCONNECTION_PREFIX;

// This is a AUTOMATICALLY GENERATED! Do not change!

				}
				sInitChanel = getInitChanelString(sPrefix);		
				if (MILL_AFTER_ALLOW_DOMAINS == 0){
					buildConnection();
				}else{
					ErrorHandler.myTimeout("buildConnection",AS3_vs_AS2.delegate(this,this.buildConnection),MILL_AFTER_ALLOW_DOMAINS);	
				}			
		}
		
		private function buildConnection():void{

// This is a AUTOMATICALLY GENERATED! Do not change!

			var failedConnect:Boolean = false;
			try{
				if(AGREE_ON_PREFIX){
					if(lcInit == null){
						lcInit = createLocalConnection()
						AS3_vs_AS2.addStatusListener(lcInit, this, ["localconnection_init"],  AS3_vs_AS2.delegate(this, this.connectionHandler));
					}
					if(!isContainer){
						randomPrefix = String(StaticFunctions.random(1,1000000));
						myTrace(["Game Attempting to send the randomPrefix with which LocalConnections will communicate. . . randomPrefix=",randomPrefix])

// This is a AUTOMATICALLY GENERATED! Do not change!

						localconnection_init(randomPrefix);
						sendPrefixInterval = new MyInterval( "sendLocalConnectionPrefix" );
						sendPrefixInterval.start( AS3_vs_AS2.delegate(this, this.sendPrefix),MILL_WAIT_BEFORE_DO_REGISTER);
					}else{
						myTrace(["Container started listening to stuff on ",sInitChanel])
						lcInit.connect(sInitChanel);	
					}	
				}else{
					localconnection_init(sInitChanel)
				}	

// This is a AUTOMATICALLY GENERATED! Do not change!


			}catch (err:Error) { 
				failedConnect = true;
				ErrorHandler.myTimeout("buildLocalConnection", AS3_vs_AS2.delegate(this,this.buildConnection),1000);
				//passError("Constructor",err);
			}
			if(!failedConnect) madeConnection();
			
		}
		protected function madeConnection():void {}

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		private function connectionHandler(isSuccess:Boolean):void {
			myTrace(["Depracated connectionHandler sending random prefix isSuccess: "+isSuccess,"my_user_prefix ",sInitChanel]);
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
        
        public function gotMessage(msg:API_Message):void{}
        
       

// This is a AUTOMATICALLY GENERATED! Do not change!

        public function sendMessage(msg:API_Message):void {
        	if (msg is API_DoRegisterOnServer){
        		if ((handShakeMade) && (lcUser != null))
        			reallySendMessage(msg);
        		else
        			ErrorHandler.myTimeout("SendDoRegisterOnServer",AS3_vs_AS2.delegate(this, this.sendMessage,msg),MILL_WAIT_BEFORE_DO_REGISTER);	
        	} else {
        		reallySendMessage(msg);
        	}
        }

// This is a AUTOMATICALLY GENERATED! Do not change!

        private function sendPrefix():void {  				  
			try{
				myTrace(["sent randomPrefix on ",sInitChanel," randomPrefix sent is:",randomPrefix," Is server: ",isContainer]);	
				lcInit.send(sInitChanel, "localconnection_init", randomPrefix);  
			}catch(err:Error) { 				
				passError("prefix error,prefix :"+randomPrefix, err);
			}        	
        }
        private function reallySendMessage(msg:API_Message):void {  				  
			try{

// This is a AUTOMATICALLY GENERATED! Do not change!

        		myTrace(['sendMessage: ',msg]);      		
				AS3_vs_AS2.checkObjectIsSerializable(msg);
        		verify(msg, true);     		
				lcUser.send(sSendChanel, "localconnection_callback", msg.toObject());  
			}catch(err:Error) { 
				passError(msg, err);
			}        	
        }
        private function sendHandShakeDoRegister():void{
        	try{

// This is a AUTOMATICALLY GENERATED! Do not change!

        		lcUser.send(sSendChanel, "localconnection_callback",API_DoRegisterOnServer.create());  
        	}catch(err:Error){
        		ErrorHandler.myTimeout("sendHandShakeDoRegister", AS3_vs_AS2.delegate(this,this.sendHandShakeDoRegister),1000);
        	}
        }
        private function verify(msg:API_Message, isSend:Boolean):void {
        	if (!_shouldVerify) return;
        	if (isContainer!=isSend)
    			verifier.msgFromGame(msg);
    		else

// This is a AUTOMATICALLY GENERATED! Do not change!

    			verifier.msgToGame(msg);        	
        }  
        private function createLocalConnection():LocalConnection{
        	var lc:LocalConnection = new LocalConnection();
        	if(StaticFunctions.ALLOW_DOMAINS != null)
				lc.allowDomain(StaticFunctions.ALLOW_DOMAINS)
			myTrace(["local connection Domain",lc.domain])	
			return lc;
        }
        public function localconnection_init(sRandomPrefix:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

        	if (ErrorHandler.didReportError) return;
        	if (lcUser != null) return;
        	try{
        		myTrace(["Container? :",isContainer,"got sRandomPrefix=",sRandomPrefix," on sInitChanel=",sInitChanel]);
        		lcUser = createLocalConnection()
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				var sDoChanel:String = getDoChanelString(sRandomPrefix);
				var sGotChanel:String = getGotChanelString(sRandomPrefix);
				var sListenChannel:String = 

// This is a AUTOMATICALLY GENERATED! Do not change!

					isContainer ? sDoChanel : sGotChanel;
				sSendChanel = 
					!isContainer ? sDoChanel : sGotChanel;				
				myTrace(["Container? :",isContainer,"LocalConnection listens on channel=",sListenChannel," and sends on ",sSendChanel]);
				lcUser.connect(sListenChannel);
				if(isContainer)	sendHandShakeDoRegister();
			} catch(err:Error) { 
				passError("local connection init",err);
			} 
        }

// This is a AUTOMATICALLY GENERATED! Do not change!

                   
        public function localconnection_callback(msgObj:Object):void {
        	if (ErrorHandler.didReportError) return;
        	var msg:API_Message = null;
        	try{
        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);
        		msg = /*as*/deserializedMsg as API_Message;
        		if (msg==null) throwError("msgObj="+JSON.stringify(msgObj)+" is not an API_Message");
        		
        		myTrace(['gotMessage: ',msg]);

// This is a AUTOMATICALLY GENERATED! Do not change!

        		if((msg is API_DoRegisterOnServer) && (!handShakeMade)){
        			handShakeMade = true;
	        		if(isContainer){	
	        			lcInit.close();	
	        		}else{
	        			sendPrefixInterval.clear();
	        			return;
	        		}
        		}
        		verify(msg, false);

// This is a AUTOMATICALLY GENERATED! Do not change!

        		gotMessage(msg);
			} catch(err:Error) { 
				passError(msg==null ? msgObj : msg, err);
			} 
        }        
	
		public static function getMsgNum(currentCallback:API_Message):int {
			var msgNum:int = -666;
	    	if (currentCallback is API_GotMatchStarted) msgNum = (/*as*/currentCallback as API_GotMatchStarted).msgNum;
	    	if (currentCallback is API_GotMatchEnded) msgNum = (/*as*/currentCallback as API_GotMatchEnded).msgNum;

// This is a AUTOMATICALLY GENERATED! Do not change!

	    	if (currentCallback is API_GotStateChanged) msgNum = (/*as*/currentCallback as API_GotStateChanged).msgNum;
	    	return msgNum;
	 	}			
	}
}
