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
		}
		private var msgsInTransaction:Array/*API_Message*/ = null;
		private var hackerUserId:int = -1;
		private var runningAnimationsNumber:int = 0;
		private var animationStartedOn:int = -1; 

		override public function gotError(withObj:Object, err:Error):void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, 
				"Got error withObj="+JSON.stringify(withObj)+
				" err="+AS3_vs_AS2.error2String(err)+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" animationStartedOn="+animationStartedOn+
				" runningAnimationsNumber="+runningAnimationsNumber+
				" msgsInTransaction="+msgsInTransaction) );
		}
        override public function gotMessage(msg:API_Message):void {
        	try {
        		if (isInTransaction())
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
        		if (runningAnimationsNumber!=0)
        			throwError("Internal error! runningAnimationsNumber="+runningAnimationsNumber+" msgsInTransaction="+msgsInTransaction);
				msgsInTransaction = []; // we start a transaction
				msgsInTransaction.push( API_DoFinishedCallback.create(msg.getMethodName()) );
				
        		hackerUserId = -1;
	    		if (msg is API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = msg as API_GotStateChanged;
	    			if (stateChanged.serverEntries.length >= 1) {
		    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
		    			hackerUserId = serverEntry.storedByUserId;
		    		}
	    		}
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
	    		var func:Function = this[methodName] as Function;
				if (func==null) return;
				func.apply(this, msg.getMethodParameters());
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
       		super.sendMessage( API_Transaction.create(msgsInTransaction) );
    		msgsInTransaction = null;
        }
        public function animationStarted():void {
        	checkInsideTransaction();
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
        
        
        override public function sendMessage(msg:API_Message):void {
        	if (msg is API_DoRegisterOnServer || msg is API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	var isStore:Boolean = msg is API_DoStoreState;
        	if (!isStore && !StaticFunctions.startsWith(msg.getMethodName(), "doAll"))
        		throwError("Illegal sendMessage="+msg);
        	
        	if (!isInTransaction()) {
        		if (!isStore)
        			throwError("You can only call doStoreState in user events. Other 'doAll' functions may be called only when the server calls some 'got' function. You called function="+msg);
        		super.sendMessage( API_Transaction.create([msg]) );
        		return;
        	}
        	msgsInTransaction.push(msg);   
        }
	}
}