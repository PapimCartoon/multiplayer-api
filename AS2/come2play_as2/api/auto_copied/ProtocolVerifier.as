	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.ProtocolVerifier
	{
		public static var MAX_ANIMATION_MILLISECONDS:Number = 30*1000; // max 30 seconds for animations

		private var transactionStartedOn:Number = -1; 
		private var currentCallback:API_Message = null;
		private var didRegisterOnServer:Boolean = false;
		private var currentPlayerIds:Array/*int*/;
		private var allPlayerIds:Array/*int*/;
		// Imagine ProtocolVerifier on the container, and the container sends GotMatchEnded for my player.
		// The game may send doStoreState up until it sends the transaction for GotMatchEnded
		// therefore we update currentPlayerIds only after we get the transaction.
		private var nextPlayerIds:Array/*int*/; 
		private var myUserId:Number = -1;
		
		public function ProtocolVerifier() {
			ErrorHandler.myInterval("ProtocolVerifier.checkAnimationInterval",AS3_vs_AS2.delegate(this, this.checkAnimationInterval), MAX_ANIMATION_MILLISECONDS);
			currentPlayerIds = [];
			nextPlayerIds = [];
		}
		public function toString():String {
			return "ProtocolVerifier:"+
				" transactionStartedOn="+transactionStartedOn+
				" currentCallback="+currentCallback+ 
				" didRegisterOnServer="+didRegisterOnServer+ 
				" currentPlayerIds="+currentPlayerIds+ 
				"";
		}
        private function checkAnimationInterval():Void {
        	if (transactionStartedOn==-1) return; // animation is not running
        	var now:Number = getTimer();
        	if (now - transactionStartedOn < MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	StaticFunctions.throwError("An transaction is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It started "+transactionStartedOn+" milliseconds after the script started, and now="+now+". ProtocolVerifier="+this);         	
        }
        public function isPlayer():Boolean {
        	// I can't use T.custom(API_Message.CUSTOM_INFO_KEY_myUserId,0), because ProtocolVerifier is used in emulator that runs multiple clients (thus static memory will cause a conflict)
        	return isInPlayers(myUserId);        	
        }
        public function getAllPlayerIds():Array/*int*/{
        	return currentPlayerIds;
        }
        public function getFinishedPlayerIds():Array/*int*/ {
        	if(allPlayerIds == null) return new Array();
        	var finishedPlayerids:Array = allPlayerIds.concat();
        	var p54:Number=0; for (var i54:String in currentPlayerIds) { var playerId:Number = currentPlayerIds[currentPlayerIds.length==null ? i54 : p54]; p54++;
        		var spliceIndex:Number = AS3_vs_AS2.IndexOf(finishedPlayerids,playerId);
        		finishedPlayerids.splice(spliceIndex,1);
        	}	
        	return finishedPlayerids;
        }
        public function isInPlayers(playerId:Number):Boolean {
        	return AS3_vs_AS2.IndexOf(currentPlayerIds, playerId)!=-1;        	
        }
        public function isAllInPlayers(playerIds:Array/*int*/):Boolean {
        	check(playerIds.length>=1, ["isAllInPlayers was called with an empty playerIds array"]);
        	var p65:Number=0; for (var i65:String in playerIds) { var playerId:Number = playerIds[playerIds.length==null ? i65 : p65]; p65++;
        		if (!isInPlayers(playerId)) return false;
        	}
        	return true;        	
        }
		private function check(cond:Boolean, arr:Array):Void {
			if (cond) return;
			StaticFunctions.assert(false, ["ProtocolVerifier found an error: ", arr]);
		}
		private function checkServerEntries(serverEntries:Array/*ServerEntry*/):Void {
			var p75:Number=0; for (var i75:String in serverEntries) { var entry:ServerEntry = serverEntries[serverEntries.length==null ? i75 : p75]; p75++;
				check(entry.key!=null, ["Found a null key in serverEntry=",entry]);
			}
		}
		private function checkInProgress(inProgress:Boolean, msg:API_Message):Void {
			StaticFunctions.assert(inProgress == (currentPlayerIds.length>0), ["The game must ",inProgress?"" : "not"," be in progress when passing msg=",msg]); 
		}
		public function msgToGame(gotMsg:API_Message):Void {
			check(gotMsg!=null, ["Got a null message!"]);
			check(currentCallback==null, ["Container sent two messages without waiting! oldCallback=", currentCallback, " newCallback=",gotMsg]);
			//check(didRegisterOnServer, [T.i18n("Container sent a message before getting doRegisterOnServer")]); 
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
				allPlayerIds = matchStarted.allPlayerIds.concat();
				nextPlayerIds = StaticFunctions.subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
    		} else if (gotMsg instanceof API_GotMatchEnded) {	    			
    			checkInProgress(true,gotMsg);
				var matchEnded:API_GotMatchEnded = API_GotMatchEnded(gotMsg);
				nextPlayerIds = StaticFunctions.subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
			} else if (gotMsg instanceof API_GotCustomInfo) {	 					    			
    			// isPause is called when the game is in progress,
    			// and other info is passed before the game starts.
    			var customInfo:API_GotCustomInfo = API_GotCustomInfo(gotMsg);
    			var p107:Number=0; for (var i107:String in customInfo.infoEntries) { var infoEntry:InfoEntry = customInfo.infoEntries[customInfo.infoEntries.length==null ? i107 : p107]; p107++;
    				if (infoEntry.key==API_Message.CUSTOM_INFO_KEY_myUserId)
    					myUserId = AS3_vs_AS2.as_int(infoEntry.value);
    			}
			} else if (gotMsg instanceof API_GotKeyboardEvent) {						    			
    			checkInProgress(true,gotMsg);
    			
				// can be sent whether the game is in progress or not
			} else if (gotMsg instanceof API_GotUserInfo) { 
			} else if (gotMsg instanceof API_GotUserDisconnected) {
			} else if (gotMsg instanceof API_GotRequestStateCalculation){
				
			}
			else {
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
			check(doMsg!=null, ["Send a null message!"]);
			if (doMsg instanceof API_DoRegisterOnServer) {
				check(!didRegisterOnServer, ["Call DoRegisterOnServer only once!"]);
				didRegisterOnServer = true;
				return;
			} 
			check(didRegisterOnServer, ["The first call must be DoRegisterOnServer!"]);
			if (isPassThrough(doMsg)) return; //e.g., we always pass doTrace or doAllFoundHacker
			
        	if (doMsg instanceof API_DoStoreState) {
        		check(isPlayer(), ["Only a player can send DoStoreState"]);
        		var doStoreStateMessage:API_DoStoreState = API_DoStoreState(doMsg);
        		isNullKeyExistUserEntry(doStoreStateMessage.userEntries);
        		isNullKeyExistRevealEntry(doStoreStateMessage.revealEntries)
        		isDeleteLegal(doStoreStateMessage.userEntries)
			} else if (doMsg instanceof API_Transaction) {
				var transaction:API_Transaction = API_Transaction(doMsg);
				check(currentCallback!=null && currentCallback.getMethodName()==transaction.callback.callbackName, ["Illegal callbackName!"]);
				// The game may perform doAllFoundHacker (in a transaction) even after the game is over,
				// because: The container may pass gotStateChanged after the game sends doAllEndMatch,
				//			because the game should verify every doStoreState (to prevent hackers from polluting the state after they know the game will be over).
				//if (transaction.messages.length>0) check(currentPlayerIds.length>0 || nextPlayerIds.length>0);
				currentPlayerIds = nextPlayerIds; // we do this before calling checkDoAll
				
				var wasStoreStateCalculation:Boolean = false;
				var isRequestStateCalculation:Boolean = currentCallback instanceof API_GotRequestStateCalculation;
				var p164:Number=0; for (var i164:String in transaction.messages) { var doAllMsg:API_Message = transaction.messages[transaction.messages.length==null ? i164 : p164]; p164++;
					checkDoAll(doAllMsg);
					if (isRequestStateCalculation) {
						if (doAllMsg instanceof API_DoAllStoreStateCalculation)	
							wasStoreStateCalculation = true;
						else
							check(doAllMsg instanceof API_DoAllFoundHacker, ["Illegal msg=",doAllMsg," when processing ",currentCallback]);
					}					
				}
				if (transaction.messages.length>0)
					check(isRequestStateCalculation ||
						  currentCallback instanceof API_GotMatchStarted || 
						  currentCallback instanceof API_GotMatchEnded ||
						  currentCallback instanceof API_GotStateChanged, ["You can change the state with a doAll message only in a transaction that corresponds to GotMatchStarted, GotMatchEnded or GotStateChanged. doAllMsg=",doAllMsg," currentCallback=",currentCallback]);
						  
				if (isRequestStateCalculation)
					check(wasStoreStateCalculation, ["When the server calls gotRequestStateCalculation, you must call doAllStoreStateCalculation"]);
				
				currentCallback = null;
        		transactionStartedOn = -1;
			} else {
				check(false, ["Forgot to verify message type=",AS3_vs_AS2.getClassName(doMsg), " doMsg=",doMsg]);
			}
			
		}
		private function isDeleteLegal(userEntries:Array/*UserEntry*/):Void
		{
			var p191:Number=0; for (var i191:String in userEntries) { var userEntry:UserEntry = userEntries[userEntries.length==null ? i191 : p191]; p191++;
				if (userEntry.value == null)
					check(!userEntry.isSecret,["key deletion must be public! userEntry=",userEntry]);
			}
		}		    		

        private function checkDoAll(msg:API_Message):Void {
        	if (msg instanceof API_DoAllFoundHacker) {        		
			}
			else if (msg instanceof API_DoAllStoreStateCalculation) 
			{
				var doAllStoreStateCalculations:API_DoAllStoreStateCalculation = API_DoAllStoreStateCalculation(msg);
        		isNullKeyExistUserEntry(doAllStoreStateCalculations.userEntries);
				isDeleteLegal(doAllStoreStateCalculations.userEntries)
        	}
        	else if (msg instanceof API_DoAllStoreState)
			{
				var doAllStoreStateMessage:API_DoAllStoreState = API_DoAllStoreState(msg);
        		isNullKeyExistUserEntry(doAllStoreStateMessage.userEntries);
				isDeleteLegal(doAllStoreStateMessage.userEntries)
			}   
			else if (msg instanceof API_DoAllEndMatch)
			{
				var doAllEndMatchMessage:API_DoAllEndMatch = API_DoAllEndMatch(msg);
				isAllInPlayers(doAllEndMatchMessage.finishedPlayers);
				// IMPORTANT Note: I do not update currentPlayerIds, because the container still needs to pass gotMatchEnded
				// Also, the container may pass gotStateChanged after the game sends DoAllEndMatch,
				// because the game should verify every doStoreState (to prevent hackers from polluting the state after they know the game will be over). 
			} 
			else if (msg instanceof API_DoAllRevealState) 
			{
				var doAllRevealState:API_DoAllRevealState = API_DoAllRevealState(msg);
        		isNullKeyExistRevealEntry(doAllRevealState.revealEntries);
			} 
			else if (msg instanceof API_DoAllRequestStateCalculation) 
			{
				var doAllRequestStateCalculation:API_DoAllRequestStateCalculation = API_DoAllRequestStateCalculation(msg);
        		isNullKeyExist(doAllRequestStateCalculation.keys);
			}
			else if	(msg instanceof API_DoAllRequestRandomState)
			{
				var doAllRequestRandomState:API_DoAllRequestRandomState = API_DoAllRequestRandomState(msg);	
				check(doAllRequestRandomState.key != null,["You have to call doAllRequestRandomState with a non null key !"]);
			}	
			else if (msg instanceof API_DoAllSetTurn) 
			{
				var doAllSetTurn:API_DoAllSetTurn = API_DoAllSetTurn(msg);
        		check(isInPlayers(doAllSetTurn.userId), ["You have to call doAllSetTurn with a playerId!"]);
			}
			else if (msg instanceof API_DoAllSetMove) 
			{				
				// nothing to check
			}
			else if (msg instanceof API_DoAllShuffleState) 
			{
				var doAllShuffleState:API_DoAllShuffleState = API_DoAllShuffleState(msg);
        		isNullKeyExist(doAllShuffleState.keys);			
			}
			else
			{
				check(false, ["Unknown doAll message=",msg]);
			}
        }
		
        private function isNullKeyExistUserEntry(userEntries:Array/*UserEntry*/):Void
        {
        	check(userEntries.length!=0, ["userEntries must have at least one UserEntry!"]);
        	var p258:Number=0; for (var i258:String in userEntries) { var userEntry:UserEntry = userEntries[userEntries.length==null ? i258 : p258]; p258++;
        		check(userEntry.key != null,["UserEntry.key cannot be null ! userEntry=",userEntry]);
        	}
        }
        private function isNullKeyExistRevealEntry(revealEntries:Array/*RevealEntry*/):Void
        {
        	//check(revealEntries.length>=1, ["revealEntries must have at least one RevealEntry!"]);
        	var p265:Number=0; for (var i265:String in revealEntries) { var revealEntry:RevealEntry = revealEntries[revealEntries.length==null ? i265 : p265]; p265++;
        		check(revealEntry != null && revealEntry.key != null && (revealEntry.userIds==null || isAllInPlayers(revealEntry.userIds)), ["RevealEntry.key cannot be null, userIds must either be null or contain only players. revealEntry=",revealEntry]); 
        	}
        }
        private function isNullKeyExist(keys:Array/*Object*/):Void
        {
        	check(keys.length!=0,["keys must have at leasy one key!"]);        		
        	var p272:Number=0; for (var i272:String in keys) { var key:String = keys[keys.length==null ? i272 : p272]; p272++;
        		check(key != null,["key cannot be null ! keys=",keys]);
        	}
        }

	}
