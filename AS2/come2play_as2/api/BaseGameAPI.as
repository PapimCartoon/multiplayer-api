	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends LocalConnectionUser 
	{        
		private static var ANIMATIONS_LOG:Logger = new Logger("ANIMATIONS",20);
		public static var ERROR_DO_ALL:String = "You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted, gotMatchEnded, or gotRequestStateCalculation.";
		public static var GAME_USE_KEYBOARD:Boolean = true;
		
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var serverStateMiror:ObjectDictionary;
		private var currentCallback:API_Message = null;
		private var hackerUserId:Number = -1;
		private var runningAnimations:Array/*String*/ = [];
		private var keys:Array;
		private var singlePlayerEmulator:SinglePlayerEmulator;
		
		private static var ALL_LOG:Logger = new Logger("BaseGameAPI",10);
		private static var KEYBOARD_LOG:Logger = new Logger("KEYBOARD",20);
		
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, getPrefixFromFlashVars(_someMovieClip),true);	
			ALL_LOG.hugeLog(this);
			ErrorHandler.SEND_BUG_REPORT = AS3_vs_AS2.delegate(this, this.sendBugReport);
			if (GAME_USE_KEYBOARD) 
				AS3_vs_AS2.addKeyboardListener(_someMovieClip, AS3_vs_AS2.delegate(this,this.keyPressed));
			if (originalPrefix==null) 
				singlePlayerEmulator = new SinglePlayerEmulator(_someMovieClip); // to prevent garbage collection
			//come2play_as2.api::BaseGameAPI.abc = 666
		}
		private function sendBugReport(bug_id:Number, errMessage:String):Void {
				// we take the traces in the container in AS3 by calling come2play_as2.api::StaticFunctions.getTraces()
				// in AS2, I limit the traces to 10KB because LocalConnection has a limit of 40KB for messages.
			if (!AS3_vs_AS2.isAS3)
				errMessage = errMessage + StaticFunctions.cutString(StaticFunctions.getTraces(),10000); 
			sendMessage( API_DoAllFoundHacker.create(hackerUserId,errMessage) ); 
		}
		public function toString():String {
			var output:Array/*String*/ = [];
			output.push("Server State(client side) : \n\n");					
			var serverEntries:Array/*ServerEntry*/ = new Array();
			if(serverStateMiror!=null){
				var p52:Number=0; for (var i52:String in serverStateMiror.allValues) { var serverEntry:ServerEntry = serverStateMiror.allValues[serverStateMiror.allValues.length==null ? i52 : p52]; p52++;
					serverEntries.push(serverEntry);
					output.push(serverEntry.toString() + "\n");
				}
			}
			
			output.push("Custom Data:\n\n"+getTAsArray().join("\n"));
			var currentPlayers:CurrentPlayers = verifier.getCurrentPlayers();
			var gotMatchStarted:API_GotMatchStarted = API_GotMatchStarted.create(0,currentPlayers.getAllPlayerIds(),currentPlayers.getFinishedPlayerIds(),serverEntries)
			return "\n\nBaseGameAPI:"+
				"\nrunningAnimations="+runningAnimations+
				"\ncurrentCallback="+currentCallback+
				"\nmsgsInTransaction="+JSON.stringify(msgsInTransaction)+
				"\n\ngotMatchStarted : \n\n"+JSON.stringify(gotMatchStarted)+
				"\n"+output.join("");					
		}
		
		private function keyPressed(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void
		{
			KEYBOARD_LOG.log("is_key_down=",is_key_down,"charCode=",charCode,"keyCode=",keyCode,"keyLocation=",keyLocation,"altKey=",altKey,"ctrlKey=",ctrlKey,"shiftKey=",shiftKey);
			
			if((shiftKey) && (ctrlKey) && (altKey) && (is_key_down) && T.custom("ENABLE COMMANDS",true) ) {
				if('G'.charCodeAt(0) == charCode)
				{	
					AS3_vs_AS2.showMessage(StaticFunctions.getTraces(), "traces");
				}
				if('E'.charCodeAt(0) == charCode) {
					// testing throwing an error	
					throw new Error("Testing throwing an error!");
				}
			}
			if (!T.custom(API_Message.CUSTOM_INFO_KEY_isFocusInChat,false) &&
				!T.custom(API_Message.CUSTOM_INFO_KEY_isPause,false))
				 {				 	
					var keyBoardEvent:API_GotKeyboardEvent = API_GotKeyboardEvent.create(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey)					
					dispatchMessage(keyBoardEvent);
				 }
				
		}
		private function getTAsArray():Array/*InfoEntry*/
		{
			var infoEntries:Array/*InfoEntry*/ = new Array();
			var custom:Object = T.getCustom();
			for(var str:String in custom)
				infoEntries.push(InfoEntry.create(str,custom[str]))
			return infoEntries;
		}
		public function getMyUserId():Number {
			return AS3_vs_AS2.as_int(T.custom(API_Message.CUSTOM_INFO_KEY_myUserId,0));
		}
		/**
		 * If your overriding 'got' methods will throw an Error,
		 * 	then hackerUserId will be declared as a hacker.
		 * We automatically set hackerUserId to storedByUserId 
		 * 	whenever receiving gotStateChanged,
		 * 	however, when the state changes after doAllReveal then
		 * 	storedByUserId is -1, so your code should call setMaybeHackerUserId.
		 */
		
		public function setMaybeHackerUserId(hackerUserId:Number):Void {
			this.hackerUserId = hackerUserId;			
		}
		/** 
		 * A transaction starts when the server calls
		 * 	a 'got' method (e.g., gotStateChanged).
		 * The transaction normally ends when your overriding 'got' method returns.
		 * However, if you start animations, 
		 * 	then the transaction continues until all the animation will end.
		 * A transaction must be ended after X seconds (see ProtocolVerifier.MAX_ANIMATION_MILLISECONDS),
		 * so make sure your animations are short (less than 5 seconds).
		 * 
		 * You may call doAll methods if and only if you are inside a transaction,
		 * and doStoreState if and only if you are not inside a transaction.
		 * 
		 * Animations may be displayed only inside a transaction.
		 */		 
        public function animationStarted(animationName:String):Void {
        	checkInsideTransaction();
        	ANIMATIONS_LOG.log(["Started:",animationName]);
        	runningAnimations.push(animationName);        	
        }
        public function animationEnded(animationName:String):Void {
        	checkInsideTransaction();
        	ANIMATIONS_LOG.log(["Ended:",animationName]);
        	var wasRemoved:Boolean = StaticFunctions.removeElement(runningAnimations,animationName);
        	if (!wasRemoved)
        		throwError("Called animationEnded with animationName="+animationName+" that is not a running animation!");
        	sendFinishedCallback();        	        	
        }		
		
		/****************************
		 * Below this line we only have private and overriding methods.
		 */
        public function isInTransaction():Boolean {
        	return msgsInTransaction!=null
        }
        private function checkInsideTransaction():Void {
        	if (!isInTransaction()) 
        		throwError("You can start/end an animation only when the server called some 'got' callback");
        }
        private function sendFinishedCallback():Void {
        	checkInsideTransaction();        	
        	if (runningAnimations.length>0) return;
        	var msgNum:Number = LocalConnectionUser.getMsgNum(currentCallback); 
        	var transaction:API_Transaction = API_Transaction.create(API_DoFinishedCallback.create(StaticFunctions.getMethodName(currentCallback),msgNum), msgsInTransaction);
    		
    		msgsInTransaction = null;
			currentCallback = null;
       		super.sendMessage(transaction);
        }
        private function updateMirorServerState(serverEntries:Array/*ServerEntry*/):Void
        {
        	var p164:Number=0; for (var i164:String in serverEntries) { var serverEntry:ServerEntry = serverEntries[serverEntries.length==null ? i164 : p164]; p164++;
        	    serverStateMiror.addEntry(serverEntry);	
        	}     	
        }
        public function getServerEntry(key:Object):ServerEntry
        {
        	return ServerEntry(serverStateMiror.getValue(key));
        }
        
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	if (isInTransaction()) {					
    			throwError("The container sent an API message without waiting for DoFinishedCallback");
			}
    		if (runningAnimations.length!=0 || currentCallback!=null)
    			throwError("Internal error! runningAnimations="+runningAnimations+" msgsInTransaction="+msgsInTransaction+" currentCallback="+currentCallback);
    			
        	try {        		
				msgsInTransaction = []; // we start a transaction
				animationStarted("BaseGameAPI.gotMessage");
				currentCallback = msg;
				
        		hackerUserId = -1;
        		
	    		if (msg instanceof API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			if (stateChanged.serverEntries.length >= 1) {
	    				updateMirorServerState(stateChanged.serverEntries);
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		} else if (msg instanceof API_GotMatchStarted) {
	    			serverStateMiror = new ObjectDictionary();
					var matchStarted:API_GotMatchStarted = API_GotMatchStarted(msg);
					updateMirorServerState(matchStarted.serverEntries);
	    		} else if (msg instanceof API_GotCustomInfo) {	 					    			
					var customInfo:API_GotCustomInfo = API_GotCustomInfo(msg);
					var i18nObj:Object = {};
					var customObj:Object = {};
					var p202:Number=0; for (var i202:String in customInfo.infoEntries) { var entry:InfoEntry = customInfo.infoEntries[customInfo.infoEntries.length==null ? i202 : p202]; p202++;
						var key:String = entry.key;
						var value:Object = entry.value;
						if (key==API_Message.CUSTOM_INFO_KEY_i18n) {
							i18nObj = value;
						} else if (key==API_Message.CUSTOM_INFO_KEY_reflection) {
							for (var reflectionKey:String in value) {
								StaticFunctions.performReflectionObject(reflectionKey,value[reflectionKey]);
							}
						} else if (key==API_Message.CUSTOM_INFO_KEY_checkThrowingAnError && value==true) {
							throw new Error("We check throwing an error.");
						} else {
							customObj[key] = value;
						}
					}		
					T.initI18n(i18nObj, customObj); // may be called several times because we may pass different 'secondsPerMatch' every time a game starts					
				}else if(msg instanceof API_GotUserInfo){
					var infoMessage:API_GotUserInfo =API_GotUserInfo( msg);
					var userObject:Object = {};
					var p221:Number=0; for (var i221:String in infoMessage.infoEntries) { var infoEntry:InfoEntry = infoMessage.infoEntries[infoMessage.infoEntries.length==null ? i221 : p221]; p221++;
						userObject[infoEntry.key] = infoEntry.value;
					}
					T.updateUser(infoMessage.userId, userObject);
					
				}
				dispatchMessage(msg)

        	} catch (err:Error) {
        		try{				
        			showError(getErrorMessage(msg, err));
				} catch (err2:Error) { 
					// to avoid an infinite loop, I can't call passError again.
					showError("Another error occurred when calling gotError. The new error is="+AS3_vs_AS2.error2String(err2));
				}
    		}
    		animationEnded("BaseGameAPI.gotMessage");     		   	
        }
        public function dispatchMessage(msg:API_Message):Void {
        	var methodName:String = StaticFunctions.getMethodName(msg);
			if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
			var func:Function = Function(this[methodName]);
			if (func==null) return;
			var params:Array = StaticFunctions.getMethodParameters(msg);
			if (msg instanceof API_GotMatchStarted || msg instanceof API_GotMatchEnded || msg instanceof API_GotStateChanged) {
				StaticFunctions.assert(AS3_vs_AS2.isOnStage(StaticFunctions.someMovieClip),"The game must be on stage when the game is in progress");
				// removes the msgNum:Number
				params.shift();
			}
			func.apply(this, params);
        }
        /*override*/ public function sendMessage(doMsg:API_Message):Void {
        	if (doMsg instanceof API_DoAllFoundHacker) {
        		var stackTraces:String = AS3_vs_AS2.myGetStackTrace(new Error());
        		if (stackTraces!=null)
        			(API_DoAllFoundHacker(doMsg)).errorDescription += "\n\nStack traces when sending DoAllFoundHacker:\n"+stackTraces;        		
        	}
        	
        	if (ProtocolVerifier.isPassThrough(doMsg) || doMsg instanceof API_DoStoreState) {
        		super.sendMessage(doMsg);
        		return;
        	}        	
			      	
			if (!isInTransaction()) 
				throwError(ERROR_DO_ALL);	
			
			msgsInTransaction.push(doMsg);			
        }
	}
