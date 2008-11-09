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
		public static var MAX_ANIMATION_MILLISECONDS:Number = 10*1000; // max 10 seconds for animations
		
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var serverStateMiror:ObjectDictionary;
		private var currentCallback:API_Message = null;
		private var hackerUserId:Number = -1;
		private var runningAnimationsNumber:Number = 0;
		private var animationStartedOn:Number = -1; 
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
		public function setMaybeHackerUserId(hackerUserId:Number):Void {
			this.hackerUserId = hackerUserId;			
		}
		/**
		 * gotError is called whenever your overriding 'got' methods
		 * 	throw an Error.
		 */
		public function gotError(withObj:Object, err:Error):Void {
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
		 * 
		 * About loading images:
		 * Flash caches loaded images, but only after loading is completed.
		 * So, if you want to use the same image in many places
		 * (e.g., place some custom image on all the pieces)
		 * then you should first call cacheImage,
		 * and only in the  onLoaded  function load the image to all the pieces.
		 * Function cacheImage starts an animation, and when the image is loaded 
		 * (or failed to load) then the animation is ended.
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
        	if (runningAnimationsNumber==0) 
        		animationStartedOn = getTimer();
        	runningAnimationsNumber++;        	
        }
        public function animationEnded():Void {
        	checkInsideTransaction();
        	if (runningAnimationsNumber<=0)
        		throwError("Called animationEnded too many times!");
        	runningAnimationsNumber--;
        	if (runningAnimationsNumber==0)
        		animationStartedOn = -1;
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
		private function checkInProgress(inProgress:Boolean, msg:API_Message):Void {
			checkContainer(inProgress == (currentPlayerIds.length>0), ["The game must ",inProgress?"" : "not"," be in progress when passing msg=",msg]); 
		}
		private function checkContainer(val:Boolean, msg:Object):Void {
			if (!val) throwError("We have an error in the container! msg="+msg);
		}
		private function subtractArray(arr:Array, minus:Array):Array {
			var res:Array = arr.concat();
			for (var i141:Number=0; i141<minus.length; i141++) { var o:Object = minus[i141]; 
				var indexOf:Number = AS3_vs_AS2.IndexOf(res, o);
				checkContainer(indexOf!=-1, ["Missing element ",o," in arr ",arr]);				
				res.splice(indexOf, 1);
			}
			return res;
		}
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
			if (isInGotRequestStateCalculation() && msgsInTransaction.length==0) 
				throwError("When the server calls gotRequestStateCalculation, you must call doAllStoreStateCalculation");
       		super.sendMessage( API_Transaction.create(API_DoFinishedCallback.create(currentCallback.getMethodName()), msgsInTransaction) );
    		msgsInTransaction = null;
			currentCallback = null;
        }
        private function checkAnimationInterval():Void {
        	if (animationStartedOn==-1) return; // animation is not running
        	var now:Number = getTimer();
        	if (now - animationStartedOn < MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	throwError("An animation is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It started "+animationStartedOn+" milliseconds after the script started.");         	
        }
        private function isInGotRequestStateCalculation():Boolean {
			return currentCallback instanceof API_GotRequestStateCalculation;
		}
        
        private function isNullKeyExistUserEntry(userEntries:Array/*UserEntry*/):Void
        {
        	for (var i177:Number=0; i177<userEntries.length; i177++) { var userEntry:UserEntry = userEntries[i177]; 
        		if (userEntry.key == null)
        			throwError("key cannot be null !");
        	}
        }
        private function isNullKeyExistRevealEntry(revealEntries:Array/*RevealEntry*/):Void
        {
        	for (var i184:Number=0; i184<revealEntries.length; i184++) { var revealEntry:RevealEntry = revealEntries[i184]; 
        		if (revealEntry.key == null)
        			throwError("key cannot be null !");
        	}
        }
        private function isNullKeyExist(keys:Array/*Object*/):Void
        {
        	for (var i191:Number=0; i191<keys.length; i191++) { var key:String = keys[i191]; 
        		if (key == null)
        			throwError("key cannot be null !");
        	}
        }
        private function updateMirorServerState(serverEntries:Array/*ServerEntry*/):Void
        {
        	for (var i198:Number=0; i198<serverEntries.length; i198++) { var serverEntry:ServerEntry = serverEntries[i198]; 
        	    if (serverEntry.value == null)
					serverStateMiror.remove(serverEntry.key);
				else 
					serverStateMiror.put(serverEntry.key,serverEntry);	
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
	    			checkInProgress(true,msg);
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			if (stateChanged.serverEntries.length >= 1) {
	    				updateMirorServerState(stateChanged.serverEntries);
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		} else if (msg instanceof API_GotMatchStarted) {
	    			checkInProgress(false,msg);
	    			serverStateMiror = new ObjectDictionary();
					var matchStarted:API_GotMatchStarted = API_GotMatchStarted(msg);
					updateMirorServerState(matchStarted.serverEntries);
					currentPlayerIds = subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
	    		} else if (msg instanceof API_GotMatchEnded) {	    			
	    			checkInProgress(true,msg);
					var matchEnded:API_GotMatchEnded = API_GotMatchEnded(msg);
					currentPlayerIds = subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
				} else if (msg instanceof API_GotCustomInfo) {	 					    			
	    			checkInProgress(false,msg);
					var customInfo:API_GotCustomInfo = API_GotCustomInfo(msg);
					var i18nObj:Object = {};
					var customObj:Object = {};
					for (var i244:Number=0; i244<customInfo.infoEntries.length; i244++) { var entry:InfoEntry = customInfo.infoEntries[i244]; 
						var key:String = entry.key;
						var value:Object = entry.value;	
						if (key=="i18n")
							i18nObj = value;
						else
							customObj[key] = value;
					}		
					T.initI18n(i18nObj, customObj); // may be called several times because we may pass different 'secondsPerMatch' every time a game starts
				} else if (msg instanceof API_GotKeyboardEvent) {						    			
	    			checkInProgress(true,msg);
				} 
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
				var func:Function = Function(this[methodName]);
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
        /*override*/ public function sendMessage(msg:API_Message):Void {
        	if (msg instanceof API_DoRegisterOnServer || msg instanceof API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	var msgName:String = msg.getMethodName();
        	if (StaticFunctions.startsWith(msgName, "do_")) {
        		// an OldBoard operation
        		super.sendMessage(msg);
        		return;
        	}
        	if (msg instanceof API_DoStoreState) {
        		var doStoreStateMessage:API_DoStoreState = API_DoStoreState(msg);
        		if (doStoreStateMessage.userEntries.length < 1 )
        			throwError("You have to call doStoreState with at least 1 parameter !");
        		if (isInTransaction())
        			throwError("You can call doStoreState only when you are not inside a transaction! msg="+msg);
        		isNullKeyExistUserEntry(doStoreStateMessage.userEntries)
        		super.sendMessage( msg );
        		return;
			}  
			else if (msg instanceof API_DoAllStoreState)
			{
				var doAllStoreStateMessage:API_DoAllStoreState = API_DoAllStoreState(msg);
        		if (doAllStoreStateMessage.userEntries.length < 1 )
        			throwError("You have to call doAllStoreStateMessage with at least 1 UserEntry !");
				isNullKeyExistUserEntry(doAllStoreStateMessage.userEntries);
			}   
			else if (msg instanceof API_DoAllEndMatch)
			{
				var doAllEndMatchMessage:API_DoAllEndMatch = API_DoAllEndMatch(msg);
        		if (doAllEndMatchMessage.finishedPlayers.length < 1 )
        			throwError("You have to call doAllEndMatch with at least 1 PlayerMatchOver !");
			} 
			else if (msg instanceof API_DoAllRevealState) 
			{
				var doAllRevealState:API_DoAllRevealState = API_DoAllRevealState(msg);
        		if (doAllRevealState.revealEntries.length < 1 )
        			throwError("You have to call doAllRevealState with at least 1 RevealEntry !");
        		isNullKeyExistRevealEntry(doAllRevealState.revealEntries);
			} 
			else if (msg instanceof API_DoAllRequestStateCalculation) 
			{
				var doAllRequestStateCalculation:API_DoAllRequestStateCalculation = API_DoAllRequestStateCalculation(msg);
        		if (doAllRequestStateCalculation.keys.length < 1 )
        			throwError("You have to call doAllRequestStateCalculation with at least 1 key !");
        		isNullKeyExist(doAllRequestStateCalculation.keys);
			}	
			else if (msg instanceof API_DoAllSetTurn) 
			{
				var doAllSetTurn:API_DoAllSetTurn = API_DoAllSetTurn(msg);
        		if (AS3_vs_AS2.IndexOf(currentPlayerIds, doAllSetTurn.userId) == -1 )
        			throwError("You have to call doAllSetTurn with a player user ID !");
			}
			else if (msg instanceof API_DoAllShuffleState) 
			{
				var doAllShuffleState:API_DoAllShuffleState = API_DoAllShuffleState(msg);
        		if (doAllShuffleState.keys.length < 1 )
        			throwError("You have to call doAllShuffleState with at least 1 key !");
        		isNullKeyExist(doAllShuffleState.keys);
			}
			else if (msg instanceof API_DoAllStoreStateCalculation) 
			{
				var doAllStoreStateCalculations:API_DoAllStoreStateCalculation = API_DoAllStoreStateCalculation(msg);
        		if (doAllStoreStateCalculations.userEntries.length < 1 )
        			throwError("You have to call doAllStoreStateCalculations with at least 1 UserEntry !");
				isNullKeyExistUserEntry(doAllStoreStateCalculations.userEntries);
			}
        	if (!StaticFunctions.startsWith(msgName, "doAll"))
        		throwError("Illegal sendMessage="+msg);        	
			if (!isInTransaction()) 
				throwError(ERROR_DO_ALL);	
				
			if (isInGotRequestStateCalculation()) {
				if (!((msg instanceof API_DoAllStoreStateCalculation) || (msg instanceof API_DoAllFoundHacker) ))
					throwError("When the server calls gotRequestStateCalculation you must respond with doAllStoreStateCalculation");
			} else if (!canDoAnimations()) {
				throwError(ERROR_DO_ALL);
			}
			msgsInTransaction.push(msg);			
        }
	}
