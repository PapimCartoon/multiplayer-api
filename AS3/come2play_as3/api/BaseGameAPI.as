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
		public static var MAX_ANIMATION_MILLISECONDS:int = 10*1000; // max 10 seconds for animations
		
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
		private var hackerUserId:int = -1;
		private var runningAnimationsNumber:int = 0;
		private var animationStartedOn:int = -1; 
		private var currentPlayerIds:Array/*int*/;

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
        override public function gotMessage(msg:API_Message):void {
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
	    		if (msg is API_GotStateChanged) {
					checkContainer(currentPlayerIds.length>0);
	    			var stateChanged:API_GotStateChanged = msg as API_GotStateChanged;
	    			if (stateChanged.serverEntries.length >= 1) {
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		} else if (msg is API_GotMatchStarted) {
					checkContainer(currentPlayerIds.length==0);
					var matchStarted:API_GotMatchStarted = msg as API_GotMatchStarted;
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
        private function checkAnimationInterval():void {
        	if (animationStartedOn==-1) return; // animation is not running
        	var now:int = getTimer();
        	if (now - animationStartedOn < MAX_ANIMATION_MILLISECONDS) return; // animation is running for a short time
        	// animation is running for too long
        	throwError("An animation is running for more than MAX_ANIMATION_MILLISECONDS="+MAX_ANIMATION_MILLISECONDS+". It started "+animationStartedOn+" milliseconds after the script started.");         	
        }
        public function canDoAnimations():Boolean {
			return currentCallback is API_GotMatchStarted || 
				currentCallback is API_GotMatchEnded || 
				currentCallback is API_GotStateChanged;
		}
        public function isInGotRequestStateCalculation():Boolean {
			return currentCallback is API_GotRequestStateCalculation;
		}
        
		private static const ERROR_DO_ALL:String = "You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted, gotMatchEnded, or gotRequestStateCalculation.";
        override public function sendMessage(msg:API_Message):void {			
			StaticFunctions.storeTrace(["sendMessage: ",msg]);
        	if (msg is API_DoRegisterOnServer || msg is API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	var isStore:Boolean = msg is API_DoStoreState;
        	if (!isStore && !StaticFunctions.startsWith(msg.getMethodName(), "doAll"))
        		throwError("Illegal sendMessage="+msg);
        	
			if (isInTransaction()) {
				if (isStore) {
					// ok
				} else if (isInGotRequestStateCalculation()) {
					if (!(msg is API_DoAllStoreStateCalculation))
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
}