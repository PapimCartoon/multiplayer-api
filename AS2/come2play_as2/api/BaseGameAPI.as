	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends LocalConnectionUser 
	{        
		public static var MAX_ANIMATION_MILLISECONDS:Number = 10*1000; // max 10 seconds for animations
		
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, getPrefixFromFlashVars(_someMovieClip));
			if (getPrefixFromFlashVars(_someMovieClip)==null) 
				new SinglePlayerEmulator(_someMovieClip);
			StaticFunctions.performReflectionFromFlashVars(_someMovieClip);	
			setInterval(AS3_vs_AS2.delegate(this, this.checkAnimationInterval), MAX_ANIMATION_MILLISECONDS);
			currentPlayerIds = [];
		}
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var currentCallback:API_Message = null;
		private var hackerUserId:Number = -1;
		private var runningAnimationsNumber:Number = 0;
		private var animationStartedOn:Number = -1; 
		private var currentPlayerIds:Array/*int*/;

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
		private function checkContainer(val:Boolean):Void {
			if (!val) throwError("We have an error in the container!");
		}
		private function subtractArray(arr:Array, minus:Array):Array {
			var res:Array = arr.concat();
			for (var i48:Number=0; i48<minus.length; i48++) { var o:Object = minus[i48]; 
				var indexOf:Number = AS3_vs_AS2.IndexOf(res, o);
				checkContainer(indexOf!=-1);
				res.splice(indexOf, 1);
			}
			return res;
		}
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	try {
				StaticFunctions.storeTrace(["gotMessage: ",msg]);
        		if (isInTransaction()) {					
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
				}
        		if (runningAnimationsNumber!=0 || currentCallback!=null)
        			throwError("Internal error! runningAnimationsNumber="+runningAnimationsNumber+" msgsInTransaction="+msgsInTransaction+" currentCallback="+currentCallback);
				msgsInTransaction = []; // we start a transaction
				currentCallback = msg;
				
        		hackerUserId = -1;
	    		if (msg instanceof API_GotStateChanged) {
					checkContainer(currentPlayerIds.length>0);
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			if (stateChanged.serverEntries.length >= 1) {
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		} else if (msg instanceof API_GotMatchStarted) {
					checkContainer(currentPlayerIds.length==0);
					var matchStarted:API_GotMatchStarted = API_GotMatchStarted(msg);
					currentPlayerIds = subtractArray(matchStarted.allPlayerIds, matchStarted.finishedPlayerIds);
	    		} else if (msg instanceof API_GotMatchEnded) {
					checkContainer(currentPlayerIds.length>0);
					var matchEnded:API_GotMatchEnded = API_GotMatchEnded(msg);
					currentPlayerIds = subtractArray(currentPlayerIds, matchEnded.finishedPlayerIds);
				}
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
	    		var func:Function = this[methodName] /*as Function*/;
				if (func==null) return;
				func.apply(this, msg.getMethodParameters());
        	} catch (err:Error) {
        		try{				
        			trace(getErrorMessage(msg, err));
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
        private function checkAnimationInterval():Void {
        	if (animationStartedOn==-1) return; // animation is not running
        	var now:Number = getTimer();
        	if (now - animationStartedOn < MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	throwError("An animation is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It started "+animationStartedOn+" milliseconds after the script started.");         	
        }
        public function canDoAnimations():Boolean {
			return currentCallback instanceof API_GotMatchStarted || 
				currentCallback instanceof API_GotMatchEnded || 
				currentCallback instanceof API_GotStateChanged;
		}
        public function isInGotRequestStateCalculation():Boolean {
			return currentCallback instanceof API_GotRequestStateCalculation;
		}
        
		private static var ERROR_DO_ALL:String = "You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted, gotMatchEnded, or gotRequestStateCalculation.";
        /*override*/ public function sendMessage(msg:API_Message):Void {			
			StaticFunctions.storeTrace(["sendMessage: ",msg]);
        	if (msg instanceof API_DoRegisterOnServer || msg instanceof API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	var isStore:Boolean = msg instanceof API_DoStoreState;
        	if (!isStore && !StaticFunctions.startsWith(msg.getMethodName(), "doAll"))
        		throwError("Illegal sendMessage="+msg);
        	
			if (isInTransaction()) {
				if (isStore) {
					// ok
				} else if (isInGotRequestStateCalculation()) {
					if (!(msg instanceof API_DoAllStoreStateCalculation))
						throwError("When the server calls gotRequestStateCalculation you must respond with doAllStoreStateCalculation");
				} else if (!canDoAnimations()) {
					throwError(ERROR_DO_ALL);
				}
				msgsInTransaction.push(msg);
				return;
			}
			// not in transaction, then you must send doStore
       		if (!isStore)
				throwError(ERROR_DO_ALL);				        			
       		super.sendMessage( msg );
        }
	}
