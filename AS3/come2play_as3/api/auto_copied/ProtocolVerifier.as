package come2play_as3.api.auto_copied
{
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class ProtocolVerifier
	{
		public static var MAX_ANIMATION_MILLISECONDS:int = 60*1000; // max 60 seconds for animations
		public static var WARN_ANIMATION_MILLISECONDS:int = 30*1000; // if an animation finished after 30 seconds we report an error (for us to know that it can happen!)

		private var transactionStartedOn:int = -1; 
		private var currentCallback:API_Message = null;
		private var didRegisterOnServer:Boolean = false;
		private var currentPlayerIds:Array/*int*/;
		private var allPlayerIds:Array/*int*/;
		// Imagine ProtocolVerifier on the container, and the container sends GotMatchEnded for my player.
		// The game may send doStoreState up until it sends the transaction for GotMatchEnded
		// therefore we update currentPlayerIds only after we get the transaction.
		private var nextPlayerIds:Array/*int*/; 
		private var myUserId:int = -1;
		
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
		private function transactionRunningTime():int {
			return getTimer() - transactionStartedOn;
		}
        private function checkAnimationInterval():void {
        	if (transactionStartedOn==-1) return; // animation is not running
        	var delta:int = transactionRunningTime();
        	if (delta< MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	StaticFunctions.throwError("An transaction is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It is running for="+delta+". ProtocolVerifier="+this);         	
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
        	for each (var playerId:int in currentPlayerIds) {
        		var spliceIndex:int = AS3_vs_AS2.IndexOf(finishedPlayerids,playerId);
        		finishedPlayerids.splice(spliceIndex,1);
        	}	
        	return finishedPlayerids;
        }
        public function isInPlayers(playerId:int):Boolean {
        	return AS3_vs_AS2.IndexOf(currentPlayerIds, playerId)!=-1;        	
        }
        public function isAllInPlayers(playerIds:Array/*int*/):Boolean {
        	check(playerIds.length>=1, ["isAllInPlayers was called with an empty playerIds array"]);
        	for each (var playerId:int in playerIds) {
        		if (!isInPlayers(playerId)) return false;
        	}
        	return true;        	
        }
		private function check(cond:Boolean, arr:Array):void {
			if (cond) return;
			StaticFunctions.assert(false, ["ProtocolVerifier found an error: ", arr]);
		}
		private function checkServerEntries(serverEntries:Array/*ServerEntry*/):void {
			for each (var entry:ServerEntry in serverEntries) {
				check(entry.key!=null, ["Found a null key in serverEntry=",entry]);
			}
		}
		private function checkInProgress(inProgress:Boolean, msg:API_Message):void {
			StaticFunctions.assert(inProgress == (currentPlayerIds.length>0), ["The game must ",inProgress?"" : "not"," be in progress when passing msg=",msg]); 
		}
		public function msgToGame(gotMsg:API_Message):void {
			check(gotMsg!=null, ["Got a null message!"]);
			check(currentCallback==null, ["Container sent two messages without waiting! oldCallback=", currentCallback, " newCallback=",gotMsg]);
			//check(didRegisterOnServer, [T.i18n("Container sent a message before getting doRegisterOnServer")]); 
			currentCallback = gotMsg;
			transactionStartedOn = getTimer();   
			if (isOldBoard(gotMsg)) {
			} else if (gotMsg is API_GotStateChanged) {
    			checkInProgress(true,gotMsg);
    			var stateChanged:API_GotStateChanged = /*as*/gotMsg as API_GotStateChanged;
    			checkServerEntries(stateChanged.serverEntries);
    		} else if (gotMsg is API_GotMatchStarted) {
    			checkInProgress(false,gotMsg);
				var matchStarted:API_GotMatchStarted = /*as*/gotMsg as API_GotMatchStarted;
				checkServerEntries(matchStarted.serverEntries);
				allPlayerIds = matchStarted.allPlayerIds.concat();
				nextPlayerIds = StaticFunctions.subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
    		} else if (gotMsg is API_GotMatchEnded) {	    			
    			checkInProgress(true,gotMsg);
				var matchEnded:API_GotMatchEnded = /*as*/gotMsg as API_GotMatchEnded;
				nextPlayerIds = StaticFunctions.subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
			} else if (gotMsg is API_GotCustomInfo) {	 					    			
    			// isPause is called when the game is in progress,
    			// and other info is passed before the game starts.
    			var customInfo:API_GotCustomInfo = /*as*/gotMsg as API_GotCustomInfo;
    			for each (var infoEntry:InfoEntry in customInfo.infoEntries) {
    				if (infoEntry.key==API_Message.CUSTOM_INFO_KEY_myUserId)
    					myUserId = AS3_vs_AS2.as_int(infoEntry.value);
    			}
			} else if (gotMsg is API_GotKeyboardEvent) {						    			
    			checkInProgress(true,gotMsg);
    			
				// can be sent whether the game is in progress or not
			} else if (gotMsg is API_GotUserInfo) { 
			} else if (gotMsg is API_GotUserDisconnected) {
			} else if (gotMsg is API_GotRequestStateCalculation){
				
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
			return doMsg is API_DoAllFoundHacker || 
				doMsg is API_DoRegisterOnServer || doMsg is API_DoTrace ||
        		isOldBoard(doMsg);
		}
		public function isDoAll(doMsg:API_Message):Boolean {
			return StaticFunctions.startsWith(StaticFunctions.getMethodName(doMsg), "doAll");
		}
		
		public function msgFromGame(doMsg:API_Message):void {
			check(doMsg!=null, ["Send a null message!"]);
			
			if (doMsg is API_DoRegisterOnServer) {
				check(!didRegisterOnServer, ["Call DoRegisterOnServer only once!"]);
				didRegisterOnServer = true;
				return;
			} 
			if (isPassThrough(doMsg)) return; //e.g., we always pass doTrace or doAllFoundHacker
			check(didRegisterOnServer, ["The first call must be DoRegisterOnServer!"]);
			
        	if (doMsg is API_DoStoreState) {
        		check(isPlayer(), ["Only a player can send DoStoreState"]);
        		var doStoreStateMessage:API_DoStoreState = /*as*/doMsg as API_DoStoreState;
        		isNullKeyExistUserEntry(doStoreStateMessage.userEntries);
        		isNullKeyExistRevealEntry(doStoreStateMessage.revealEntries)
        		isDeleteLegal(doStoreStateMessage.userEntries)
			} else if (doMsg is API_Transaction) {
				var transaction:API_Transaction = /*as*/doMsg as API_Transaction;
				check(currentCallback!=null && StaticFunctions.getMethodName(currentCallback)==transaction.callback.callbackName, ["Illegal callbackName!"]);
				// The game may perform doAllFoundHacker (in a transaction) even after the game is over,
				// because: The container may pass gotStateChanged after the game sends doAllEndMatch,
				//			because the game should verify every doStoreState (to prevent hackers from polluting the state after they know the game will be over).
				//if (transaction.messages.length>0) check(currentPlayerIds.length>0 || nextPlayerIds.length>0);
				currentPlayerIds = nextPlayerIds; // we do this before calling checkDoAll
				
				var wasStoreStateCalculation:Boolean = false;
				var isRequestStateCalculation:Boolean = currentCallback is API_GotRequestStateCalculation;
				for each (var doAllMsg:API_Message in transaction.messages) {
					checkDoAll(doAllMsg);
					if (isRequestStateCalculation) {
						if (doAllMsg is API_DoAllStoreStateCalculation)	
							wasStoreStateCalculation = true;
						else
							check(doAllMsg is API_DoAllFoundHacker, ["Illegal msg=",doAllMsg," when processing ",currentCallback]);
					}					
				}
				if (transaction.messages.length>0)
					check(isRequestStateCalculation ||
						  currentCallback is API_GotMatchStarted || 
						  currentCallback is API_GotMatchEnded ||
						  currentCallback is API_GotStateChanged, ["You can change the state with a doAll message only in a transaction that corresponds to GotMatchStarted, GotMatchEnded or GotStateChanged. doAllMsg=",doAllMsg," currentCallback=",currentCallback]);
						  
				if (isRequestStateCalculation)
					check(wasStoreStateCalculation, ["When the server calls gotRequestStateCalculation, you must call doAllStoreStateCalculation"]);
				
				currentCallback = null;
				
				if (transactionRunningTime()>WARN_ANIMATION_MILLISECONDS) // for us to know it can happen (so we should increase our bound)
					ErrorHandler.alwaysTraceAndSendReport("A transaction finished after WARN_ANIMATION_MILLISECONDS",this);
        		transactionStartedOn = -1;
			} else {
				check(false, ["Forgot to verify message type=",AS3_vs_AS2.getClassName(doMsg), " doMsg=",doMsg]);
			}
			
		}
		private function isDeleteLegal(userEntries:Array/*UserEntry*/):void
		{
			for each(var userEntry:UserEntry in userEntries) {
				if (userEntry.value == null)
					check(!userEntry.isSecret,["key deletion must be public! userEntry=",userEntry]);
			}
		}		    		

        private function checkDoAll(msg:API_Message):void {
        	if (msg is API_DoAllFoundHacker) {        		
			}
			else if (msg is API_DoAllStoreStateCalculation) 
			{
				var doAllStoreStateCalculations:API_DoAllStoreStateCalculation = /*as*/msg as API_DoAllStoreStateCalculation;
        		isNullKeyExistUserEntry(doAllStoreStateCalculations.userEntries);
				isDeleteLegal(doAllStoreStateCalculations.userEntries)
        	}
        	else if (msg is API_DoAllStoreState)
			{
				var doAllStoreStateMessage:API_DoAllStoreState = /*as*/msg as API_DoAllStoreState;
        		isNullKeyExistUserEntry(doAllStoreStateMessage.userEntries);
				isDeleteLegal(doAllStoreStateMessage.userEntries)
			}   
			else if (msg is API_DoAllEndMatch)
			{
				var doAllEndMatchMessage:API_DoAllEndMatch = /*as*/msg as API_DoAllEndMatch;
				isAllInPlayers(doAllEndMatchMessage.finishedPlayers);
				// IMPORTANT Note: I do not update currentPlayerIds, because the container still needs to pass gotMatchEnded
				// Also, the container may pass gotStateChanged after the game sends DoAllEndMatch,
				// because the game should verify every doStoreState (to prevent hackers from polluting the state after they know the game will be over). 
			} 
			else if (msg is API_DoAllRevealState) 
			{
				var doAllRevealState:API_DoAllRevealState = /*as*/msg as API_DoAllRevealState;
        		isNullKeyExistRevealEntry(doAllRevealState.revealEntries);
			} 
			else if (msg is API_DoAllRequestStateCalculation) 
			{
				var doAllRequestStateCalculation:API_DoAllRequestStateCalculation = /*as*/msg as API_DoAllRequestStateCalculation;
        		isNullKeyExist(doAllRequestStateCalculation.keys);
			}
			else if	(msg is API_DoAllRequestRandomState)
			{
				var doAllRequestRandomState:API_DoAllRequestRandomState = /*as*/msg as API_DoAllRequestRandomState;	
				check(doAllRequestRandomState.key != null,["You have to call doAllRequestRandomState with a non null key !"]);
			}	
			else if (msg is API_DoAllSetTurn) 
			{
				var doAllSetTurn:API_DoAllSetTurn = /*as*/msg as API_DoAllSetTurn;
        		check(isInPlayers(doAllSetTurn.userId), ["You have to call doAllSetTurn with a playerId!"]);
			}
			else if (msg is API_DoAllSetMove) 
			{				
				// nothing to check
			}
			else if (msg is API_DoAllShuffleState) 
			{
				var doAllShuffleState:API_DoAllShuffleState = /*as*/msg as API_DoAllShuffleState;
        		isNullKeyExist(doAllShuffleState.keys);			
			}
			else
			{
				check(false, ["Unknown doAll message=",msg]);
			}
        }
		
        private function isNullKeyExistUserEntry(userEntries:Array/*UserEntry*/):void
        {
        	check(userEntries.length!=0, ["userEntries must have at least one UserEntry!"]);
        	for each (var userEntry:UserEntry in userEntries) {
        		check(userEntry.key != null,["UserEntry.key cannot be null ! userEntry=",userEntry]);
        	}
        }
        private function isNullKeyExistRevealEntry(revealEntries:Array/*RevealEntry*/):void
        {
        	//check(revealEntries.length>=1, ["revealEntries must have at least one RevealEntry!"]);
        	for each (var revealEntry:RevealEntry in revealEntries) {
        		check(revealEntry != null && revealEntry.key != null && (revealEntry.userIds==null || isAllInPlayers(revealEntry.userIds)), ["RevealEntry.key cannot be null, userIds must either be null or contain only players. revealEntry=",revealEntry]); 
        	}
        }
        private function isNullKeyExist(keys:Array/*Object*/):void
        {
        	check(keys.length!=0,["keys must have at leasy one key!"]);        		
        	for each (var key:String in keys) {
        		check(key != null,["key cannot be null ! keys=",keys]);
        	}
        }

	}
}