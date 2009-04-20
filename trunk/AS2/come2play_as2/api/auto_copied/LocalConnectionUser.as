	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	 
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.LocalConnectionUser
	{
		public static var REVIEW_USER_ID:Number = -1; // special userId that is used for reviewing games
		public static var IS_LOCAL_CONNECTION_UDERSCORE:Boolean = false;		
		public static var DEFAULT_LOCALCONNECTION_PREFIX:String = ""+AS3_vs_AS2.convertToInt(10000*Math.random());
		public static var MILL_WAIT_BEFORE_DO_REGISTER:Number = 500;
		public static var TRACE_RETRY:Boolean = false;	
		
		public static var MILL_AFTER_ALLOW_DOMAINS:Number = 500;
		public static var AGREE_ON_PREFIX:Boolean = true;
		public static var ALLOW_DOMAIN:String = "*";
		public static function showError(msg:String):Void {
			StaticFunctions.showError(msg);
		}
		public static function throwError(msg:String):Void {
			StaticFunctions.throwError(msg);
		}		
		public static function assert(val:Boolean, name:String, args:Array):Void {
			if (!val) StaticFunctions.assert(false, name, args);
		}

		// I added the "_" on purpose because of different domains issues, see: http://livedocs.adobe.com/flex/gumbo/langref/flash/net/LocalConnection.html
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
		public static function getInitChanelString(sPrefix:String):String {
			if(IS_LOCAL_CONNECTION_UDERSCORE)
				return "_INIT_CHANEL_"+sPrefix;
			return "INIT_CHANEL_"+sPrefix;
		}
		public static function getLoaderInfoParameter(_someMovieClip:MovieClip, param:String):String {
			return AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip)[param];
		}
		public static function getPrefixFromFlashVars(_someMovieClip:MovieClip):String {
			var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(_someMovieClip);
			var sPrefix:String = parameters["prefix"];
			if (sPrefix==null) sPrefix = parameters["?prefix"];
			return getPrefixFromString(sPrefix);
		}		
		public static function getPrefixFromString(sPrefix:String):String {			
			return sPrefix;
		}
		
		
		/**
		 * In AS3 it is more efficient to use direct method calls then to use LocalConnection.
		 * If the game is loaded with the parameter "prefix=usingAS3"
		 * using method calls instead of LocalConnection in AS3.
		 * We still must serialize and deserialize because the API_* classes are different.
		 */ 
		public static var SINGLETON:LocalConnectionUser = null;
		public static var USING_AS3_PREFIX:String = "usingAS3";
		public static var AS3_RECEIVER_CLASS_NAME:String = "come2play_as2.auto_copied::LocalConnectionUser"; // set using reflection
		public function trySendMessageUsingAS3(msg:Object):String {
			var xlass:Object/*Class*/;
			try {
				xlass = AS3_vs_AS2.getClassByName(AS3_RECEIVER_CLASS_NAME);
			} catch (e:Error) {
				// , because container or game were not loaded yet
				return "class not found";
			}
			var singleton:Object = xlass["SINGLETON"];
			if (singleton==null) return "singleton is null"; 
			// NOTE that singleton of the other class is not 
			// 	come2play_as2.api.auto_copied.LocalConnectionUser
			// but it is
			// 	come2play_as2.auto_copied.LocalConnectionUser
			// So you cannot cast it to LocalConnectionUser
			ErrorHandler.catchErrors("trySendMessageUsingAS3", singleton.localconnection_callback, [msg]);
			return null;
		}
		
				
		
		// we use a LocalConnection to communicate with the container
		private var lcUser:LocalConnection; 
		private var lcInit:LocalConnection;
		private var sSendChanel:String;
		private var sInitChanel:String;
		private var isContainer:Boolean;
		private var randomPrefix:String;
		private var sendPrefixInterval:MyInterval;
		private var handShakeMade:Boolean = false;
		public var verifier:ProtocolVerifier;
		public var _shouldVerify:Boolean;
		private var isUsingAS3:Boolean;
		//Constructor
		public function LocalConnectionUser(_someMovieClip:MovieClip, isContainer:Boolean, sPrefix:String,shouldVerify:Boolean) {
			try {
				this.isUsingAS3 = sPrefix==USING_AS3_PREFIX;
							
				if (!isContainer) // in the container we apply the reflection in RoomLogic (e.g., for a room we do not have a localconnection) 
					StaticFunctions.performReflectionFromFlashVars(_someMovieClip);
				StaticFunctions.allowDomains();
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
				}
				
				if (!isUsingAS3) {			
					sInitChanel = getInitChanelString(sPrefix);		
					if (MILL_AFTER_ALLOW_DOMAINS == 0){
						buildConnection();
					}else{
						ErrorHandler.myTimeout("buildConnection",AS3_vs_AS2.delegate(this,this.buildConnection),MILL_AFTER_ALLOW_DOMAINS);	
					}					
				} else {
					// in AS3 we prefer to use direct method calls (using the static SINGLETON member), 
					// instead of LocalConnection (which has size limitations)
					// putting a value in SINGLETON means that the init is done (so it must be done after API_LoadMessages) 
					StaticFunctions.assert(SINGLETON==null,"You can create a LocalConnectionUser only once!",[]);
					SINGLETON = this;
					
					madeConnection();
				}

			} catch (err:Error) {
				ErrorHandler.handleError(err, this);
			}	
		}
		
		private function buildConnection():Void{
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

			}catch (err:Error) { 
				failedConnect = true;
				ErrorHandler.myTimeout("buildLocalConnection", AS3_vs_AS2.delegate(this,this.buildConnection),1000);
			}
			if(!failedConnect) madeConnection();
			
		}
		private function madeConnection():Void {}
		
		private function connectionHandler(isSuccess:Boolean):Void {
			myTrace(["Depracated connectionHandler sending random prefix isSuccess: "+isSuccess,"my_user_prefix ",sInitChanel]);
		}

		private static var LC_LOG:Logger = new Logger("LocalConnection",10);
		public function myTrace(msg:Array):Void {	
			LC_LOG.log([AS3_vs_AS2.getClassName(this),": ",msg]);
		}
		
        private function getErrorMessage(withObj:Object, err:Error):String {
        	return "Error occurred when passing "+JSON.stringify(withObj)+", the error is=\n\t\t"+AS3_vs_AS2.error2String(err);
        }
        
        public function gotMessage(msg:API_Message):Void {}
        
       
		private static var SENT_LOG:Logger = new Logger("SENT_MSG",50);
        public function sendMessage(msg:API_Message):Void {
        	SENT_LOG.log(msg);      		
			AS3_vs_AS2.checkObjectIsSerializable(msg);
    		verify(msg, true);    		     	
			retrySendMsg(msg);
        }
        private function retrySendMsg(msg:API_Message):Void {
    		var serializedMsg:Object = msg.toObject();
        	var res:String = trySendMessage( serializedMsg );
        	if (res==null) return;
        	if (TRACE_RETRY) 
				StaticFunctions.storeTrace(["sendMessageUsing failed because:",res]);
			assert(/*is*/msg instanceof API_DoRegisterOnServer, "Only DoRegisterOnServer can fail! res=",[res," msg=", msg]);
			ErrorHandler.myTimeout("RetrySendDoRegisterOnServer", AS3_vs_AS2.delegate(this,this.retrySendMsg, msg), MILL_WAIT_BEFORE_DO_REGISTER);			        	
        }
        private function trySendMessage(msg:Object):String { 
        	return isUsingAS3 ?	
        		trySendMessageUsingAS3(msg) : 
        		trySendMessageUsingLocalConnection(msg);
        }
        private function trySendMessageUsingLocalConnection(msg:Object):String {  
        	if (!handShakeMade) return "Did not finish handshake yet"; 
        	if (lcUser == null)	return "lcUser is still null";			  
			try{        			
				lcUser.send(sSendChanel, "localconnection_callback", msg);  
			}catch(err:Error) { 
				ErrorHandler.handleError(err,msg);
			}        	
			return null;
        }
        private function sendPrefix():Void {  				  
			try{
				myTrace(["sent randomPrefix on ",sInitChanel," randomPrefix sent is:",randomPrefix," Is server: ",isContainer]);	
				lcInit.send(sInitChanel, "localconnection_init", randomPrefix);  
			}catch(err:Error) { 				
				ErrorHandler.handleError(err, ["prefix error,prefix :",randomPrefix]);
			}        	
        }
        private function sendHandShakeDoRegister():Void{
        	try{
        		lcUser.send(sSendChanel, "localconnection_callback",API_DoRegisterOnServer.create());  
        	}catch(err:Error){
        		ErrorHandler.myTimeout("sendHandShakeDoRegister", AS3_vs_AS2.delegate(this,this.sendHandShakeDoRegister),1000);
        	}
        }
        private function verify(msg:API_Message, isSend:Boolean):Void {
        	if (!_shouldVerify) return;
        	if (isContainer!=isSend)
    			verifier.msgFromGame(msg);
    		else
    			verifier.msgToGame(msg);        	
        }  
        private function createLocalConnection():LocalConnection{
        	var lc:LocalConnection = new LocalConnection();
        	if(StaticFunctions.ALLOW_DOMAINS != null)
				lc.allowDomain(StaticFunctions.ALLOW_DOMAINS)
			myTrace(["local connection Domain",lc.domain])	
			return lc;
        }
        public function localconnection_init(sRandomPrefix:String):Void {
        	if (ErrorHandler.didReportError) return;
        	if (lcUser != null) return;
        	try{
        		myTrace(["Container? :",isContainer,"got sRandomPrefix=",sRandomPrefix," on sInitChanel=",sInitChanel]);
        		lcUser = createLocalConnection()
				AS3_vs_AS2.addStatusListener(lcUser, this, ["localconnection_callback"]);
				
				var sDoChanel:String = getDoChanelString(sRandomPrefix);
				var sGotChanel:String = getGotChanelString(sRandomPrefix);
				var sListenChannel:String = 
					isContainer ? sDoChanel : sGotChanel;
				sSendChanel = 
					!isContainer ? sDoChanel : sGotChanel;				
				myTrace(["Container? :",isContainer,"LocalConnection listens on channel=",sListenChannel," and sends on ",sSendChanel]);
				lcUser.connect(sListenChannel);
				if(isContainer)	sendHandShakeDoRegister();
			} catch(err:Error) { 
				ErrorHandler.handleError(err,"local connection init");
			} 
        }
                   
		private static var GOT_LOG:Logger = new Logger("GOT_MSG",50);
        public function localconnection_callback(msgObj:Object):Void {
        	if (ErrorHandler.didReportError) return;
        	var msg:API_Message = null;
        	try {
        		var deserializedMsg:Object = SerializableClass.deserialize(msgObj);
        		msg = API_Message(deserializedMsg);
        		if (msg==null) throwError("msgObj="+JSON.stringify(msgObj)+" is not an API_Message");
        		
        		if (!isUsingAS3) {
	        		if((msg instanceof API_DoRegisterOnServer) && (!handShakeMade)){
	        			handShakeMade = true;
		        		if(isContainer){	
		        			lcInit.close();	
		        		}else{
		        			sendPrefixInterval.clear();
		        			return;
		        		}
	        		}
	        	}
	    		GOT_LOG.log(msg);
	    		verify(msg, false);
	    		gotMessage(msg);
			} catch(err:Error) { 
				ErrorHandler.handleError(err, msg==null ? msgObj : msg);
			} 
        }  
	
		public static function getMsgNum(currentCallback:API_Message):Number {
			var msgNum:Number = -666;
	    	if (currentCallback instanceof API_GotMatchStarted) msgNum = (API_GotMatchStarted(currentCallback)).msgNum;
	    	if (currentCallback instanceof API_GotMatchEnded) msgNum = (API_GotMatchEnded(currentCallback)).msgNum;
	    	if (currentCallback instanceof API_GotStateChanged) msgNum = (API_GotStateChanged(currentCallback)).msgNum;
	    	return msgNum;
	 	}			
	}
