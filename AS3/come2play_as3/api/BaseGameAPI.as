package come2play_as3.api {
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.utils.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
	public class BaseGameAPI extends LocalConnectionUser 
	{        
		public static var ERROR_DO_ALL:String = "You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted, gotMatchEnded, or gotRequestStateCalculation.";
		public static var MAX_ANIMATION_MILLISECONDS:int = 10*1000; // max 10 seconds for animations
		
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var serverStateMiror:ObjectDictionary;
		private var currentCallback:API_Message = null;
		private var hackerUserId:int = -1;
		private var runningAnimationsNumber:int = 0;
		private var animationStartedOn:int = -1; 
		private var currentPlayerIds:Array/*int*/;
		
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, getPrefixFromFlashVars(_someMovieClip));
			if (getPrefixFromFlashVars(_someMovieClip)==null) 
				new SinglePlayerEmulator(_someMovieClip);
			StaticFunctions.performReflectionFromFlashVars(_someMovieClip);	
			setInterval(AS3_vs_AS2.delegate(this, this.checkAnimationInterval), MAX_ANIMATION_MILLISECONDS);
			currentPlayerIds = [];
		}

		/**
		 * If your overriding 'got' methods will throw an Error,
		 * 	then hackerUserId will be declared as a hacker.
		 * We automatically set hackerUserId to storedByUserId 
		 * 	whenever receiving gotStateChanged,
		 * 	however, when the state changes after doAllReveal then
		 * 	storedByUserId is -1, so your code should call setMaybeHackerUserId.
		 */
		public function setMaybeHackerUserId(hackerUserId:int):void {
			this.hackerUserId = hackerUserId;			
		}
		/**
		 * gotError is called whenever your overriding 'got' methods
		 * 	throw an Error.
		 */
		public function gotError(withObj:Object, err:Error):void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, 
				"Got error withObj="+JSON.stringify(withObj)+
				" err="+AS3_vs_AS2.error2String(err)+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" animationStartedOn="+animationStartedOn+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" currentPlayerIds="+currentPlayerIds+
				" currentCallback="+currentCallback+
				" msgsInTransaction="+msgsInTransaction) );
		}
		/** 
		 * A transaction starts when the server calls
		 * 	a 'got' method (e.g., gotStateChanged).
		 * The transaction normally ends when your overriding 'got' method returns.
		 * However, if you start animations, 
		 * 	then the transaction continues until all the animation will end.
		 * 
		 * You may call doAll methods if and only if you are inside a transaction,
		 * and doStoreState if and only if you are not inside a transaction.
		 * 
		 * Animations may be displayed only inside a transaction
		 * 	that is either gotMatchStarted or gotMatchEnded or gotStateChanged.
		 */
        public function animationStarted():void {
        	checkInsideTransaction();
			if (!canDoAnimations())
				throwError("You can do animations only when the server calls gotMatchStarted, gotMatchEnded, or gotStateChanged");
        	if (runningAnimationsNumber==0) 
        		animationStartedOn = getTimer();
        	runningAnimationsNumber++;        	
        }
        public function animationEnded():void {
        	checkInsideTransaction();
        	if (runningAnimationsNumber<=0)
        		throwError("Called animationEnded too many times!");
        	runningAnimationsNumber--;
        	if (runningAnimationsNumber==0)
        		animationStartedOn = -1;
        	sendFinishedCallback();        	        	
        }
        public function canDoAnimations():Boolean {
			return currentCallback is API_GotMatchStarted || 
				currentCallback is API_GotMatchEnded || 
				currentCallback is API_GotStateChanged;
		}
		
		
		/****************************
		 * Below this line we only have private and overriding methods.
		 */
		private function checkContainer(val:Boolean):void {
			if (!val) throwError("We have an error in the container!");
		}
		private function subtractArray(arr:Array, minus:Array):Array {
			var res:Array = arr.concat();
			for each (var o:Object in minus) {
				var indexOf:int = AS3_vs_AS2.IndexOf(res, o);
				checkContainer(indexOf!=-1);
				res.splice(indexOf, 1);
			}
			return res;
		}
        private function isInTransaction():Boolean {
        	return msgsInTransaction!=null
        }
        private function checkInsideTransaction():void {
        	if (!isInTransaction()) 
        		throwError("You can start/end an animation only when the server called some 'got' callback");
        }
        private function sendFinishedCallback():void {
        	checkInsideTransaction();        	
        	if (runningAnimationsNumber>0) return;
			if (isInGotRequestStateCalculation() && msgsInTransaction.length==0) 
				throwError("When the server calls gotRequestStateCalculation, you must call doAllStoreStateCalculation");
       		super.sendMessage( API_Transaction.create(API_DoFinishedCallback.create(currentCallback.getMethodName()), msgsInTransaction) );
    		msgsInTransaction = null;
			currentCallback = null;
        }
        private function checkAnimationInterval():void {
        	if (animationStartedOn==-1) return; // animation is not running
        	var now:int = getTimer();
        	if (now - animationStartedOn < MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	throwError("An animation is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It started "+animationStartedOn+" milliseconds after the script started.");         	
        }
        private function isInGotRequestStateCalculation():Boolean {
			return currentCallback is API_GotRequestStateCalculation;
		}
        
        private function isNullKeyExistUserEntry(userEntries:Array/*UserEntry*/):void
        {
        	for each (var userEntry:UserEntry in userEntries) {
        		if (userEntry.key == null)
        			throwError("key cannot be null !");
        	}
        }
        private function isNullKeyExistRevealEntry(revealEntries:Array/*RevealEntry*/):void
        {
        	for each (var revealEntry:RevealEntry in revealEntries) {
        		if (revealEntry.key == null)
        			throwError("key cannot be null !");
        	}
        }
        private function isNullKeyExist(keys:Array/*Object*/):void
        {
        	for each (var key:String in keys) {
        		if (key == null)
        			throwError("key cannot be null !");
        	}
        }
        private function updateMirorServerState(serverEntries:Array/*ServerEntry*/):void
        {
        	for each(var serverEntry:ServerEntry in serverEntries)
        	{
        	    if((serverEntry.value == null) || (serverEntry.value == ""))
				{
					if( typeof(serverEntry.value) == "number" )
						serverStateMiror.put(serverEntry.key,serverEntry);
					else
						serverStateMiror.remove(serverEntry.key);
				}
				else
					serverStateMiror.put(serverEntry.key,serverEntry);	
        	}     	
        }
        public function getServerEntry(key:Object):ServerEntry
        {
        	return serverStateMiror.getValue(key) as ServerEntry;
        }
        
        override public function gotMessage(msg:API_Message):void {
        	try {
        		if (isInTransaction()) {					
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
				}
        		if (runningAnimationsNumber!=0 || currentCallback!=null)
        			throwError("Internal error! runningAnimationsNumber="+runningAnimationsNumber+" msgsInTransaction="+msgsInTransaction+" currentCallback="+currentCallback);
				msgsInTransaction = []; // we start a transaction
				currentCallback = msg;
				
        		hackerUserId = -1;
	    		if (msg is API_GotStateChanged) {
					checkContainer(currentPlayerIds.length>0);
	    			var stateChanged:API_GotStateChanged = msg as API_GotStateChanged;
	    			if (stateChanged.serverEntries.length >= 1) {
	    				updateMirorServerState(stateChanged.serverEntries);
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		} else if (msg is API_GotMatchStarted) {
	    			serverStateMiror = new ObjectDictionary();
					checkContainer(currentPlayerIds.length==0);
					var matchStarted:API_GotMatchStarted = msg as API_GotMatchStarted;
					updateMirorServerState(matchStarted.serverEntries);
					currentPlayerIds = subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
	    		} else if (msg is API_GotMatchEnded) {
					checkContainer(currentPlayerIds.length>0);
					var matchEnded:API_GotMatchEnded = msg as API_GotMatchEnded;
					currentPlayerIds = subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
				}
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
	    		var func:Function = this[methodName] as Function;
				if (func==null) return;
				func.apply(this, msg.getMethodParameters());
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
        override public function sendMessage(msg:API_Message):void {
        	if (msg is API_DoRegisterOnServer || msg is API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	var msgName:String = msg.getMethodName();
        	if (StaticFunctions.startsWith(msgName, "do_")) {
        		// an OldBoard operation
        		super.sendMessage(msg);
        		return;
        	}
        	if (msg is API_DoStoreState) {
        		var doStoreStateMessage:API_DoStoreState = msg as API_DoStoreState;
        		if (doStoreStateMessage.userEntries.length < 1 )
        			throwError("You have to call doStoreState with at least 1 parameter !");
        		if (isInTransaction())
        			throwError("You can call doStoreState only when you are not inside a transaction! msg="+msg);
        		isNullKeyExistUserEntry(doStoreStateMessage.userEntries)
        		super.sendMessage( msg );
        		return;
			}  
			else if (msg is API_DoAllStoreState)
			{
				var doAllStoreStateMessage:API_DoAllStoreState = msg as API_DoAllStoreState;
        		if (doAllStoreStateMessage.userEntries.length < 1 )
        			throwError("You have to call doAllStoreStateMessage with at least 1 UserEntry !");
				isNullKeyExistUserEntry(doAllStoreStateMessage.userEntries);
			}   
			else if (msg is API_DoAllEndMatch)
			{
				var doAllEndMatchMessage:API_DoAllEndMatch = msg as API_DoAllEndMatch;
        		if (doAllEndMatchMessage.finishedPlayers.length < 1 )
        			throwError("You have to call doAllEndMatch with at least 1 PlayerMatchOver !");
			} 
			else if (msg is API_DoAllRevealState) 
			{
				var doAllRevealState:API_DoAllRevealState = msg as API_DoAllRevealState;
        		if (doAllRevealState.revealEntries.length < 1 )
        			throwError("You have to call doAllRevealState with at least 1 RevealEntry !");
        		isNullKeyExistRevealEntry(doAllRevealState.revealEntries);
			} 
			else if (msg is API_DoAllRequestStateCalculation) 
			{
				var doAllRequestStateCalculation:API_DoAllRequestStateCalculation = msg as API_DoAllRequestStateCalculation;
        		if (doAllRequestStateCalculation.keys.length < 1 )
        			throwError("You have to call doAllRequestStateCalculation with at least 1 key !");
        		isNullKeyExist(doAllRequestStateCalculation.keys);
			}	
			else if (msg is API_DoAllSetTurn) 
			{
				var doAllSetTurn:API_DoAllSetTurn = msg as API_DoAllSetTurn;
        		if (AS3_vs_AS2.IndexOf(currentPlayerIds, doAllSetTurn.userId) == -1 )
        			throwError("You have to call doAllSetTurn with a player user ID !");
			}
			else if (msg is API_DoAllShuffleState) 
			{
				var doAllShuffleState:API_DoAllShuffleState = msg as API_DoAllShuffleState;
        		if (doAllShuffleState.keys.length < 1 )
        			throwError("You have to call doAllShuffleState with at least 1 key !");
        		isNullKeyExist(doAllShuffleState.keys);
			}
			else if (msg is API_DoAllStoreStateCalculation) 
			{
				var doAllStoreStateCalculations:API_DoAllStoreStateCalculation = msg as API_DoAllStoreStateCalculation;
        		if (doAllStoreStateCalculations.userEntries.length < 1 )
        			throwError("You have to call doAllStoreStateCalculations with at least 1 UserEntry !");
				isNullKeyExistUserEntry(doAllStoreStateCalculations.userEntries);
			}
        	if (!StaticFunctions.startsWith(msgName, "doAll"))
        		throwError("Illegal sendMessage="+msg);        	
			if (!isInTransaction()) 
				throwError(ERROR_DO_ALL);	
				
			if (isInGotRequestStateCalculation()) {
				if (!((msg is API_DoAllStoreStateCalculation) || (msg is API_DoAllFoundHacker) ))
					throwError("When the server calls gotRequestStateCalculation you must respond with doAllStoreStateCalculation");
			} else if (!canDoAnimations()) {
				throwError(ERROR_DO_ALL);
			}
			msgsInTransaction.push(msg);			
        }
	}
}