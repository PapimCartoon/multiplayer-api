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
		}
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var canSendDoAll:Boolean = false;
		private var hackerUserId:Number = -1;
		private var runningAnimationsNumber:Number = 0;
		private var animationStartedOn:Number = -1; 

		public function gotError(withObj:Object, err:Error):Void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, 
				"Got error withObj="+JSON.stringify(withObj)+
				" err="+AS3_vs_AS2.error2String(err)+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" animationStartedOn="+animationStartedOn+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" msgsInTransaction="+msgsInTransaction) );
		}
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	try {
        		if (isInTransaction()) {
					if (msg instanceof API_GotKeyboardEvent) {
						trace("We ignore a keyboard event. It is a bug in the emulator that will be fixed promptly. msg="+msg);
						return;
					}
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
				}
        		if (runningAnimationsNumber!=0)
        			throwError("Internal error! runningAnimationsNumber="+runningAnimationsNumber+" msgsInTransaction="+msgsInTransaction);
				msgsInTransaction = []; // we start a transaction
				canSendDoAll = msg instanceof API_GotMatchStarted || msg instanceof API_GotMatchEnded || msg instanceof API_GotStateChanged;
				msgsInTransaction.push( API_DoFinishedCallback.create(msg.getMethodName()) );
				
        		hackerUserId = -1;
	    		if (msg instanceof API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			if (stateChanged.serverEntries.length >= 1) {
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
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
       		super.sendMessage( API_Transaction.create(msgsInTransaction) );
    		msgsInTransaction = null;
        }
        public function animationStarted():Void {
        	checkInsideTransaction();
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
        
        
        /*override*/ public function sendMessage(msg:API_Message):Void {
        	if (msg instanceof API_DoRegisterOnServer || msg instanceof API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	var isStore:Boolean = msg instanceof API_DoStoreState;
        	if (!isStore && !StaticFunctions.startsWith(msg.getMethodName(), "doAll"))
        		throwError("Illegal sendMessage="+msg);
        	
        	if (!isInTransaction() || !canSendDoAll) {
        		if (!isStore)
        			throwError("You can only call a doAll* message when the server calls gotStateChanged, gotMatchStarted or gotMatchEnded. You called function="+msg);
        		super.sendMessage( API_Transaction.create([msg]) );
        		return;
        	}
        	msgsInTransaction.push(msg);   
        }
	}
