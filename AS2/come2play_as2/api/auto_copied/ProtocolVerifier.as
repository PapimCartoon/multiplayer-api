	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.ProtocolVerifier
	{
		public static var MAX_ANIMATION_MILLISECONDS:Number = 10*1000; // max 10 seconds for animations

		private var transactionStartedOn:Number = -1; 
		private var currentCallback:API_Message = null;
		private var didRegisterOnServer:Boolean = false;
		private var currentPlayerIds:Array/*int*/;
		// Imagine ProtocolVerifier on the container, and the container sends GotMatchEnded for my player.
		// The game may send doStoreState up until it sends the transaction for GotMatchEnded
		// therefore we update currentPlayerIds only after we get the transaction.
		private var nextPlayerIds:Array/*int*/; // when the container sends
		private var myUserId:Number = -1;
		
		public function ProtocolVerifier() {
			setInterval(AS3_vs_AS2.delegate(this, this.checkAnimationInterval), MAX_ANIMATION_MILLISECONDS);
			currentPlayerIds = [];
		}
		public function toString():String {
			return "ProtocolVerifier:"+
				" transactionStartedOn="+transactionStartedOn+
				" currentCallback="+currentCallback+ 
				" didRegisterOnServer="+didRegisterOnServer+ 
				" currentPlayerIds="+currentPlayerIds+ 
				" currentCallback="+currentCallback+ 
				"";
		}
        private function checkAnimationInterval():Void {
        	if (transactionStartedOn==-1) return; // animation is not running
        	var now:Number = getTimer();
        	if (now - transactionStartedOn < MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	StaticFunctions.throwError("An animation is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It started "+transactionStartedOn+" milliseconds after the script started.");         	
        }
        public function isPlayer():Boolean {
        	// I can't use T.custom(API_Message.CUSTOM_INFO_KEY_myUserId,0), because ProtocolVerifier is used in emulator that runs multiple clients (thus static memory will cause a conflict)
        	return AS3_vs_AS2.IndexOf(currentPlayerIds, myUserId)!=-1;        	
        }
		private function check(cond:Boolean, arr:Array):Void {
			if (cond) return;
			StaticFunctions.assert(false, ["ProtocolVerifier found an error: ", arr]);
		}
		private function checkServerEntries(serverEntries:Array/*ServerEntry*/):Void {
			for (var i52:Number=0; i52<serverEntries.length; i52++) { var entry:ServerEntry = serverEntries[i52]; 
				check(entry.key!=null, ["Found a null key in serverEntry=",entry]);
			}
		}
		private function checkInProgress(inProgress:Boolean, msg:API_Message):Void {
			StaticFunctions.assert(inProgress == (currentPlayerIds.length>0), ["The game must ",inProgress?"" : "not"," be in progress when passing msg=",msg]); 
		}
		public function msgToGame(gotMsg:API_Message):Void {
			check(currentCallback==null, ["Container sent two messages without waiting! oldCallback=", currentCallback, " newCallback=",gotMsg]);
			check(didRegisterOnServer, ["Container sent a message before getting doRegisterOnServer"]); 
			currentCallback = gotMsg;
			transactionStartedOn = getTimer();   
			if (isOldBoard(gotMsg)) {
			} else if (gotMsg instanceof API_GotStateChanged) {
    			checkInProgress(true,gotMsg);
    			var stateChanged:API_GotStateChanged = API_GotStateChanged(gotMsg);
    			checkServerEntries(stateChanged.serverEntries);
    		} else if (gotMsg instanceof API_GotMatchStarted) {
    			checkInProgress(false,gotMsg);
				var matchStarted:API_GotMatchStarted = API_GotMatchStarted(gotMsg);
				checkServerEntries(matchStarted.serverEntries);
				nextPlayerIds = StaticFunctions.subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
    		} else if (gotMsg instanceof API_GotMatchEnded) {	    			
    			checkInProgress(true,gotMsg);
				var matchEnded:API_GotMatchEnded = API_GotMatchEnded(gotMsg);
				nextPlayerIds = StaticFunctions.subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
			} else if (gotMsg instanceof API_GotCustomInfo) {	 					    			
    			checkInProgress(false,gotMsg);
    			var customInfo:API_GotCustomInfo = API_GotCustomInfo(gotMsg);
    			for (var i81:Number=0; i81<customInfo.infoEntries.length; i81++) { var infoEntry:InfoEntry = customInfo.infoEntries[i81]; 
    				if (infoEntry.key==API_Message.CUSTOM_INFO_KEY_myUserId)
    					myUserId = AS3_vs_AS2.as_int(infoEntry.value);
    			}
			} else if (gotMsg instanceof API_GotKeyboardEvent) {						    			
    			checkInProgress(true,gotMsg);
    			
				// can be sent whether the game is in progress or not
			} else if (gotMsg instanceof API_GotUserInfo) { 
			} else if (gotMsg instanceof API_GotUserDisconnected) {
			} else {
				check(false, ["Illegal gotMsg=",gotMsg]);
			}
		}
		public static function isOldBoard(msg:API_Message):Boolean {
			var name:String = msg.getMethodName();
			return StaticFunctions.startsWith(name, "do_") || StaticFunctions.startsWith(name, "got_");
		}
		public static function isPassThrough(doMsg:API_Message):Boolean {
			return doMsg instanceof API_DoAllFoundHacker || 
				doMsg instanceof API_DoRegisterOnServer || doMsg instanceof API_DoTrace ||
        		isOldBoard(doMsg);
		}
		public function isDoAll(doMsg:API_Message):Boolean {
			return StaticFunctions.startsWith(doMsg.getMethodName(), "doAll");
		}
		
		public function msgFromGame(doMsg:API_Message):Void {
			if (doMsg instanceof API_DoRegisterOnServer) {
				check(!didRegisterOnServer, ["Call DoRegisterOnServer only once!"]);
				didRegisterOnServer = true;
			} else if (isPassThrough(doMsg)) {
        	} else if (doMsg instanceof API_DoStoreState) {
        		check(isPlayer(), ["Only a player can send DoStoreState"]);
        		var doStoreStateMessage:API_DoStoreState = API_DoStoreState(doMsg);
        		if (doStoreStateMessage.userEntries.length < 1 )
        			StaticFunctions.throwError("You have to call doStoreState with at least 1 parameter !");
        		
        		isNullKeyExistUserEntry(doStoreStateMessage.userEntries);
			} else if (doMsg instanceof API_Transaction) {
				var transaction:API_Transaction = API_Transaction(doMsg);
				check(currentCallback.getMethodName()==transaction.callback.callbackName, ["Illegal callbackName!"]);
				if (nextPlayerIds!=null) {
					currentPlayerIds = nextPlayerIds; // we do this before calling checkDoAll
					nextPlayerIds = null;
				}
				
				var wasStoreStateCalculation:Boolean = false;
				var isRequestStateCalculation:Boolean = currentCallback instanceof API_GotRequestStateCalculation;
				for (var i130:Number=0; i130<transaction.messages.length; i130++) { var doAllMsg:API_Message = transaction.messages[i130]; 
					checkDoAll(doAllMsg);
					if (isRequestStateCalculation) {
						if (doAllMsg instanceof API_DoAllStoreStateCalculation)	
							wasStoreStateCalculation = true;
						else
							check(doAllMsg instanceof API_DoAllFoundHacker, ["Illegal msg=",doAllMsg," when processing ",currentCallback]);
					}						
				}
				if (isRequestStateCalculation)
					check(wasStoreStateCalculation, ["When the server calls gotRequestStateCalculation, you must call doAllStoreStateCalculation"]);
				
				currentCallback = null;
        		transactionStartedOn = -1;
			}
			
		}
		    		

        private function checkDoAll(msg:API_Message):Void {
        	if (msg instanceof API_DoAllFoundHacker) {        		
			}
			else if (msg instanceof API_DoAllStoreStateCalculation) 
			{
				var doAllStoreStateCalculations:API_DoAllStoreStateCalculation = API_DoAllStoreStateCalculation(msg);
        		if (doAllStoreStateCalculations.userEntries.length < 1 )
        			StaticFunctions.throwError("You have to call doAllStoreStateCalculations with at least 1 UserEntry !");
				isNullKeyExistUserEntry(doAllStoreStateCalculations.userEntries);
        	}
        	else if (msg instanceof API_DoAllStoreState)
			{
				var doAllStoreStateMessage:API_DoAllStoreState = API_DoAllStoreState(msg);
        		if (doAllStoreStateMessage.userEntries.length < 1 )
        			StaticFunctions.throwError("You have to call doAllStoreStateMessage with at least 1 UserEntry !");
				isNullKeyExistUserEntry(doAllStoreStateMessage.userEntries);
			}   
			else if (msg instanceof API_DoAllEndMatch)
			{
				var doAllEndMatchMessage:API_DoAllEndMatch = API_DoAllEndMatch(msg);
        		if (doAllEndMatchMessage.finishedPlayers.length < 1 )
        			StaticFunctions.throwError("You have to call doAllEndMatch with at least 1 PlayerMatchOver !");
			} 
			else if (msg instanceof API_DoAllRevealState) 
			{
				var doAllRevealState:API_DoAllRevealState = API_DoAllRevealState(msg);
        		if (doAllRevealState.revealEntries.length < 1 )
        			StaticFunctions.throwError("You have to call doAllRevealState with at least 1 RevealEntry !");
        		isNullKeyExistRevealEntry(doAllRevealState.revealEntries);
			} 
			else if (msg instanceof API_DoAllRequestStateCalculation) 
			{
				var doAllRequestStateCalculation:API_DoAllRequestStateCalculation = API_DoAllRequestStateCalculation(msg);
        		if (doAllRequestStateCalculation.keys.length < 1 )
        			StaticFunctions.throwError("You have to call doAllRequestStateCalculation with at least 1 key !");
        		isNullKeyExist(doAllRequestStateCalculation.keys);
			}	
			else if (msg instanceof API_DoAllSetTurn) 
			{
				var doAllSetTurn:API_DoAllSetTurn = API_DoAllSetTurn(msg);
        		if (AS3_vs_AS2.IndexOf(currentPlayerIds, doAllSetTurn.userId) == -1 )
        			StaticFunctions.throwError("You have to call doAllSetTurn with a player user ID !");
			}
			else if (msg instanceof API_DoAllShuffleState) 
			{
				var doAllShuffleState:API_DoAllShuffleState = API_DoAllShuffleState(msg);
        		if (doAllShuffleState.keys.length < 1 )
        			StaticFunctions.throwError("You have to call doAllShuffleState with at least 1 key !");
        		isNullKeyExist(doAllShuffleState.keys);
			}
			else
			{
				check(false, ["Unknown doAll message=",msg]);
			}
        }
		
        private function isNullKeyExistUserEntry(userEntries:Array/*UserEntry*/):Void
        {
        	for (var i207:Number=0; i207<userEntries.length; i207++) { var userEntry:UserEntry = userEntries[i207]; 
        		if (userEntry.key == null)
        			StaticFunctions.throwError("key cannot be null !");
        	}
        }
        private function isNullKeyExistRevealEntry(revealEntries:Array/*RevealEntry*/):Void
        {
        	for (var i214:Number=0; i214<revealEntries.length; i214++) { var revealEntry:RevealEntry = revealEntries[i214]; 
        		if (revealEntry.key == null)
        			StaticFunctions.throwError("key cannot be null !");
        	}
        }
        private function isNullKeyExist(keys:Array/*Object*/):Void
        {
        	for (var i221:Number=0; i221<keys.length; i221++) { var key:String = keys[i221]; 
        		if (key == null)
        			StaticFunctions.throwError("key cannot be null !");
        	}
        }

	}
