	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.ProtocolVerifier
	{
		// I had normal cases that took more than 30 seconds!
		//["Time: ",63516,["myInterval set","TictactoeSquareGraphic.moveAnimationStep",MyInterval x50 not running,50]],
		//["Time: ",99063,["myInterval cleared","TictactoeSquareGraphic.moveAnimationStep",MyInterval x50 not running,50]]]
		public static var MAX_ANIMATION_MILLISECONDS:Number = 120*1000; // max seconds for animations
		public static var WARN_ANIMATION_MILLISECONDS:Number = 60*1000; // if an animation finished after X seconds, we report an error (for us to know that it can happen!)

		private var transactionStartedOn:TimeMeasure; 
		private var currentCallback:API_Message = null;
		private var didRegisterOnServer:Boolean = false;
		private var currentPlayerIds:Array/*int*/;
		private var allPlayerIds:Array/*int*/;
		// Imagine ProtocolVerifier on the container, and the container sends GotMatchEnded for my player.
		// The game may send doStoreState up until it sends the transaction for GotMatchEnded
		// We do not queue those doStoreState anymore (the java will throw away doStore of a viewer)
		
		public function ProtocolVerifier() {
			transactionStartedOn = new TimeMeasure();
			ErrorHandler.myInterval("ProtocolVerifier.checkAnimationInterval",AS3_vs_AS2.delegate(this, this.checkAnimationInterval), MAX_ANIMATION_MILLISECONDS);
			currentPlayerIds = [];
		}
		public function toString():String {
			return "ProtocolVerifier:"+
				" transactionStartedOn="+transactionStartedOn+
				" currentCallback="+currentCallback+ 
				" didRegisterOnServer="+didRegisterOnServer+ 
				" currentPlayerIds="+currentPlayerIds+ 
				"";
		}
		private function transactionRunningTime():Number {
			return transactionStartedOn.milliPassed();
		}
        private function checkAnimationInterval():Void {
        	if (!transactionStartedOn.isTimeSet()) return; // animation is not running
        	var delta:Number = transactionRunningTime();
        	if (delta<MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	StaticFunctions.throwError("An transaction is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS);         	
        }
        public function getAllPlayerIds():Array/*int*/{
        	return currentPlayerIds;
        }
        public function getFinishedPlayerIds():Array/*int*/ {
        	if(allPlayerIds == null) return new Array();
        	var finishedPlayerids:Array = allPlayerIds.concat();
        	var p55:Number=0; for (var i55:String in currentPlayerIds) { var playerId:Number = currentPlayerIds[currentPlayerIds.length==null ? i55 : p55]; p55++;
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
        	var p66:Number=0; for (var i66:String in playerIds) { var playerId:Number = playerIds[playerIds.length==null ? i66 : p66]; p66++;
        		if (!isInPlayers(playerId)) return false;
        	}
        	return true;        	
        }
		private function check(cond:Boolean, arr:Array):Void {
			if (cond) return;
			StaticFunctions.assert(false, "ProtocolVerifier found an error: ", [arr]);
		}
		private function checkServerEntries(serverEntries:Array/*ServerEntry*/):Void {
			var p76:Number=0; for (var i76:String in serverEntries) { var entry:ServerEntry = serverEntries[serverEntries.length==null ? i76 : p76]; p76++;
				check(entry.key!=null, ["Found a null key in serverEntry=",entry]);
			}
		}
		private function checkInProgress(inProgress:Boolean, msg:API_Message):Void {
			StaticFunctions.assert(inProgress == (currentPlayerIds.length>0), "checkInProgress",["The game must ",inProgress?"" : "not"," be in progress when passing msg=",msg]); 
		}
		public function msgToGame(gotMsg:API_Message):Void {
			check(gotMsg!=null, ["Got a null message!"]);
			check(currentCallback==null, ["Container sent two messages without waiting! oldCallback=", currentCallback, " newCallback=",gotMsg]);
			//check(didRegisterOnServer, [T.i18n("Container sent a message before getting doRegisterOnServer")]); 
			currentCallback = gotMsg;
			transactionStartedOn.setTime();   
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
				currentPlayerIds = StaticFunctions.subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
    		} else if (gotMsg instanceof API_GotMatchEnded) {	    			
    			checkInProgress(true,gotMsg);
				var matchEnded:API_GotMatchEnded = API_GotMatchEnded(gotMsg);
				currentPlayerIds = StaticFunctions.subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
			} else if (gotMsg instanceof API_GotCustomInfo) {	 					    			
    			// isPause is called when the game is in progress,
    			// and other info is passed before the game starts.
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
			var name:String = StaticFunctions.getMethodName(msg);
			return StaticFunctions.startsWith(name, "do_") || StaticFunctions.startsWith(name, "got_");
		}
		public static function isPassThrough(doMsg:API_Message):Boolean {
			return doMsg instanceof API_DoAllFoundHacker || 
				doMsg instanceof API_DoRegisterOnServer || doMsg instanceof API_DoTrace ||
        		isOldBoard(doMsg);
		}
		public function isDoAll(doMsg:API_Message):Boolean {
			return StaticFunctions.startsWith(StaticFunctions.getMethodName(doMsg), "doAll");
		}
		
		public function msgFromGame(doMsg:API_Message):Void {
			check(doMsg!=null, ["Send a null message!"]);
			
			if (doMsg instanceof API_DoRegisterOnServer) {
				check(!didRegisterOnServer, ["Call DoRegisterOnServer only once!"]);
				didRegisterOnServer = true;
				return;
			} 
			if (isPassThrough(doMsg)) return; //e.g., we always pass doTrace or doAllFoundHacker
			check(didRegisterOnServer, ["The first call must be DoRegisterOnServer!"]);
			
        	if (doMsg instanceof API_DoStoreState) {
        		// The game might send DoStoreState for a player, but the verifier already send GotMatchEnded for that player
        		// check(isPlayer(), ["Only a player can send DoStoreState"]);
        		var doStoreStateMessage:API_DoStoreState = API_DoStoreState(doMsg);
        		isNullKeyExistUserEntry(doStoreStateMessage.userEntries);
        		isNullKeyExistRevealEntry(doStoreStateMessage.revealEntries)
        		isDeleteLegal(doStoreStateMessage.userEntries)
			} else if (doMsg instanceof API_Transaction) {
				var transaction:API_Transaction = API_Transaction(doMsg);
				check(currentCallback!=null && StaticFunctions.getMethodName(currentCallback)==transaction.callback.callbackName, ["Illegal callbackName!"]);
				// The game may perform doAllFoundHacker (in a transaction) even after the game is over,
				// because: The container may pass gotStateChanged after the game sends doAllEndMatch,
				//			because the game should verify every doStoreState (to prevent hackers from polluting the state after they know the game will be over).
				//if (transaction.messages.length>0) check(currentPlayerIds.length>0);
				
				var wasStoreStateCalculation:Boolean = false;
				var isRequestStateCalculation:Boolean = currentCallback instanceof API_GotRequestStateCalculation;
				var p161:Number=0; for (var i161:String in transaction.messages) { var doAllMsg:API_Message = transaction.messages[transaction.messages.length==null ? i161 : p161]; p161++;
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
				
				if (transactionRunningTime()>WARN_ANIMATION_MILLISECONDS) // for us to know it can happen (so we should increase our bound)
					ErrorHandler.alwaysTraceAndSendReport("A transaction finished after WARN_ANIMATION_MILLISECONDS",transactionStartedOn);
        		transactionStartedOn.clearTime();
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
