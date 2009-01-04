	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends LocalConnectionUser 
	{        
		public static var ERROR_DO_ALL:String = "You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted, gotMatchEnded, or gotRequestStateCalculation.";
		
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var doStoreQueue:Array/*API_DoStoreState*/ = new Array;
		private var serverStateMiror:ObjectDictionary;
		private var currentCallback:API_Message = null;
		private var hackerUserId:Number = -1;
		private var runningAnimationsNumber:Number = 0;
		private var keys:Array;
		private var someMovieClip:MovieClip;
		private var historyEntries:Array/*HistoryEntry*/;
		private var keyboardMessages:Array/*API_GotKeyboardEvent*/;
		private var singlePlayerEmulator:SinglePlayerEmulator;
		public static var HISTORY_LENGTH:Number = 100;
		
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, getPrefixFromFlashVars(_someMovieClip),true);
			
			keyboardMessages = [];
			someMovieClip = _someMovieClip;
			AS3_vs_AS2.addKeyboardListener(_someMovieClip,keyPressed);
			if (getPrefixFromFlashVars(_someMovieClip)==null) 
				singlePlayerEmulator = new SinglePlayerEmulator(_someMovieClip); // to prevent garbage collection
				
			if(HISTORY_LENGTH > 0)
				historyEntries = new Array();
			//come2play_as2.api::BaseGameAPI.abc = 666
		}
		
		private function keyPressed(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void
		{
			if((shiftKey) && (ctrlKey) && (altKey) && (is_key_down))
			{
				if(String('G').charCodeAt(0) == charCode)
				{
					var serverEntries:Array/*ServerEntry*/ = new Array();
					var output:String = "Traces:\n\n"+
					StaticFunctions.getTraces()+"\n\n"+
					"Server State(client side) : \n\n";
					
					if(serverStateMiror!=null){
						for (var i56:Number=0; i56<serverStateMiror.allValues.length; i56++) { var serverEntry:ServerEntry = serverStateMiror.allValues[i56]; 
							serverEntries.push(serverEntry);
							output+= serverEntry.toString() + "\n";
						}
					}
					if(historyEntries!=null)
						output+="History entries :\n\n"+historyEntries.join("\n")+"\n\n";
					
					output+="Custom Data:\n\n"+getTAsArray().join("\n");
					var gotMatchStarted:API_GotMatchStarted = API_GotMatchStarted.create(verifier.getAllPlayerIds(),verifier.getFinishedPlayerIds(),serverEntries)
					AS3_vs_AS2.showError(someMovieClip,"gotMatchStarted : \n\n"+JSON.stringify(gotMatchStarted)+"\n"+output);
				}
			}
			if (verifier.isPlayer() &&
				!T.custom(API_Message.CUSTOM_INFO_KEY_isFocusInChat,false) &&
				!T.custom(API_Message.CUSTOM_INFO_KEY_isPause,false))
				 {				 	
					var keyBoardEvent:API_GotKeyboardEvent = API_GotKeyboardEvent.create(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey)	
				 	keyboardMessages.push(keyBoardEvent)
				 	if(!isInTransaction())
				 	{
				 		sendKeyboardEvents();
				 	}
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
		private function sendKeyboardEvents():Void
		{
			while (keyboardMessages.length > 0 )
				dispatchMessage(API_Message(keyboardMessages.shift()));			
		}
		/**
		 * If your overriding 'got' methods will throw an Error,
		 * 	then hackerUserId will be declared as a hacker.
		 * We automatically set hackerUserId to storedByUserId 
		 * 	whenever receiving gotStateChanged,
		 * 	however, when the state changes after doAllReveal then
		 * 	storedByUserId instanceof -1, so your code should call setMaybeHackerUserId.
		 */
		
		public function setMaybeHackerUserId(hackerUserId:Number):Void {
			this.hackerUserId = hackerUserId;			
		}
		/**
		 * gotError instanceof called whenever your overriding 'got' methods
		 * 	throw an Error.
		 */
		public function gotError(withObj:Object, err:Error):Void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, 
				"Got error withObj="+JSON.stringify(withObj)+
				" err="+AS3_vs_AS2.error2String(err)+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" currentCallback="+currentCallback+
				" msgsInTransaction="+JSON.stringify(msgsInTransaction)+
				" traces="+StaticFunctions.getTraces() ) );
		}
		/** 
		 * A transaction starts when the server calls
		 * 	a 'got' method (e.g., gotStateChanged).
		 * The transaction normally ends when your overriding 'got' method returns.
		 * However, if you start animations, 
		 * 	then the transaction continues until all the animation will end.
		 * A transaction must be ended after 10 seconds (see ProtocolVerifier.MAX_ANIMATION_MILLISECONDS),
		 * so make sure your animations are short (less than 5 seconds).
		 * 
		 * You may call doAll methods if and only if you are inside a transaction,
		 * and doStoreState if and only if you are not inside a transaction.
		 * 
		 * Animations may be displayed only inside a transaction
		 * 	that instanceof either gotMatchStarted or gotMatchEnded or gotStateChanged.
		 * 
		 * About loading images:
		 * Flash caches loaded images, but only after loading instanceof completed.
		 * So, if you want to use the same image in many places
		 * (e.g., place some custom image on all the pieces)
		 * then you should first call cacheImage,
		 * and only in the  onLoaded  function load the image to all the pieces.
		 * Function cacheImage starts an animation, and when the image instanceof loaded 
		 * (or failed to load) then the animation instanceof ended.
		 * The image will be stored in some 
		 * newly created invisible child in someMovieClip. 
		 * E.g.,
		 * cacheImage( imageUrl, someMovieClip, 
		 * 		function (isSuccess:Boolean):Void {
		 * 			if (isSuccess) {
		 * 				// load the image in all the pieces
		 * 			}
		 * 		});
		 */		 
        public function animationStarted():Void {
        	checkInsideTransaction();
			if (!canDoAnimations())
				throwError("You can do animations only when the server calls gotMatchStarted, gotMatchEnded, or gotStateChanged");
        	runningAnimationsNumber++;        	
        }
        public function animationEnded():Void {
        	checkInsideTransaction();
        	if (runningAnimationsNumber<=0)
        		throwError("Called animationEnded too many times!");
        	runningAnimationsNumber--;
        	sendFinishedCallback();        	        	
        }
        public function canDoAnimations():Boolean {
			return currentCallback instanceof API_GotCustomInfo || 
				currentCallback instanceof API_GotMatchStarted ||
				currentCallback instanceof API_GotMatchEnded || 
				currentCallback instanceof API_GotUserInfo ||
				currentCallback instanceof API_GotStateChanged;
		}
		public function cacheImage(imageUrl:String, someMovieClip:MovieClip,
					onLoaded:Function):Void {		
			animationStarted();
			var thisObj:BaseGameAPI = this; // for AS2
			var forCaching:MovieClip =
				AS3_vs_AS2.loadMovieIntoNewChild(someMovieClip, imageUrl, 
					function (isSucc:Boolean):Void {
						onLoaded(isSucc);
						thisObj.animationEnded();				
					});	
			AS3_vs_AS2.setVisible(forCaching, false);		
		}
		
		
		/****************************
		 * Below this line we only have private and overriding methods.
		 */
        private function isInTransaction():Boolean {
        	return msgsInTransaction!=null
        }
        private function checkInsideTransaction():Void {
        	if (!isInTransaction()) 
        		throwError("You can start/end an animation only when the server called some 'got' callback");
        }
        private function sendFinishedCallback():Void {
        	checkInsideTransaction();        	
        	if (runningAnimationsNumber>0) return;
       		super.sendMessage( API_Transaction.create(API_DoFinishedCallback.create(currentCallback.getMethodName()), msgsInTransaction) );
    		msgsInTransaction = null;
			currentCallback = null;
			sendKeyboardEvents();
			if (verifier.isPlayer()) sendDoStoreStateEvents();
        }
        private function sendDoStoreStateEvents():Void{
        	for (var i207:Number=0; i207<doStoreQueue.length; i207++) { var doStoreMsg:API_DoStoreState = doStoreQueue[i207]; 
        		super.sendMessage(doStoreMsg);
        	}
        	doStoreQueue = [];
        }
        private function updateMirorServerState(serverEntries:Array/*ServerEntry*/):Void
        {
        	for (var i214:Number=0; i214<serverEntries.length; i214++) { var serverEntry:ServerEntry = serverEntries[i214]; 
        	    serverStateMiror.addEntry(serverEntry);	
        	}     	
        }
        public function getServerEntry(key:Object):ServerEntry
        {
        	return ServerEntry(serverStateMiror.getValue(key));
        }
        
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	try {
        		if (isInTransaction()) {					
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
				}
        		if (runningAnimationsNumber!=0 || currentCallback!=null)
        			throwError("Internal error! runningAnimationsNumber="+runningAnimationsNumber+" msgsInTransaction="+msgsInTransaction+" currentCallback="+currentCallback);
				msgsInTransaction = []; // we start a transaction
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
	    			doStoreQueue = [];
	    			serverStateMiror = new ObjectDictionary();
					var matchStarted:API_GotMatchStarted = API_GotMatchStarted(msg);
					updateMirorServerState(matchStarted.serverEntries);
	    		} else if (msg instanceof API_GotCustomInfo) {	 					    			
					var customInfo:API_GotCustomInfo = API_GotCustomInfo(msg);
					var i18nObj:Object = {};
					var customObj:Object = {};
					for (var i251:Number=0; i251<customInfo.infoEntries.length; i251++) { var entry:InfoEntry = customInfo.infoEntries[i251]; 
						var key:String = entry.key;
						var value:Object = entry.value;
						if (key==API_Message.CUSTOM_INFO_KEY_i18n) {
							i18nObj = value;
						} else if (key==API_Message.CUSTOM_INFO_KEY_reflection) {
							for (var reflectionKey:String in value) {
								StaticFunctions.performReflectionObject(reflectionKey,value[reflectionKey]);
							}
						} else if (key==API_Message.CUSTOM_INFO_KEY_checkThrowingAnError && value==true) {
							throw new Error("checkThrowingAnError");
						} else {
							customObj[key] = value;
						}
					}		
					T.initI18n(i18nObj, customObj); // may be called several times because we may pass different 'secondsPerMatch' every time a game starts
				}else if(msg instanceof API_GotUserInfo){
					var infoMessage:API_GotUserInfo =API_GotUserInfo( msg);
					var userObject:Object = {};
					for (var i270:Number=0; i270<infoMessage.infoEntries.length; i270++) { var infoEntry:InfoEntry = infoMessage.infoEntries[i270]; 
						trace(infoEntry.key+ "="+ infoEntry.value)
						userObject[infoEntry.key] = infoEntry.value;
					}
					T.updateUser(infoMessage.userId, userObject);
					
				}
				if(historyEntries != null)
					if(historyEntries.length < HISTORY_LENGTH)
						historyEntries.push(HistoryEntry.create(API_Message(SerializableClass.deserialize(msg.toObject())),getTimer()))
				dispatchMessage(msg)

        	} catch (err:Error) {
        		try{				
        			showError(getErrorMessage(msg, err));
					gotError(msg, err);
				} catch (err2:Error) { 
					// to avoid an infinite loop, I can't call passError again.
					showError("Another error occurred when calling gotError. The new error is="+AS3_vs_AS2.error2String(err2));
				}
    		} finally {       
        		// we end a transaction
    			sendFinishedCallback(); 			
    		}        		   	
        }
        public function dispatchMessage(msg:API_Message):Void {
        	var methodName:String = msg.getMethodName();
			if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
			var func:Function = Function(this[methodName]);
			if (func==null) return;
			var params:Array = msg.getMethodParameters();
			if (msg instanceof API_GotMatchStarted || msg instanceof API_GotMatchEnded || msg instanceof API_GotStateChanged) {
				// removes the msgNum:Number
				params.shift();
			}
			func.apply(this, params);
        }
        /*override*/ public function sendMessage(doMsg:API_Message):Void {
        	if (ProtocolVerifier.isPassThrough(doMsg)) {
        		super.sendMessage(doMsg);
        		return;
        	}
        	if (doMsg instanceof API_DoStoreState) {
        		if (isInTransaction()){
        			trace("push message")
        			doStoreQueue.push(doMsg)
        		}else{
        			trace("send message")
        			super.sendMessage(doMsg);
        		}
        		return;
        	}        	
			      	
			if (!isInTransaction()) 
				throwError(ERROR_DO_ALL);	
			
			msgsInTransaction.push(doMsg);			
        }
	}
