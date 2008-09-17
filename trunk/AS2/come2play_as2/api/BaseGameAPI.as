	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends LocalConnectionUser 
	{        
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, getPrefixFromFlashVars(_someMovieClip));
			if (getPrefixFromFlashVars(_someMovieClip)==null) 
				new SinglePlayerEmulator(_someMovieClip);
			StaticFunctions.performReflectionFromFlashVars(_someMovieClip);	
		}
		private var transactionDepth:Number = 0;
		private var msgsInTransaction:Array/*API_Message*/ = [];
		private var hackerUserId:Number = -1;
		private var runningAnimationsNumber:Number = 0;
		private var nonFinishedMsg:API_Message = null;
		/*override*/ public function gotError(withObj:Object, err:Error):Void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, "Got error withObj="+JSON.stringify(withObj)+" err="+AS3_vs_AS2.error2String(err)) );
		}
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	try {
        		startTransaction();
        		if (nonFinishedMsg!=null)
        			throwError("The container sent an API message without waiting for DoFinishedCallback");
				nonFinishedMsg = msg;    			 
        		hackerUserId = -1;
        		//if (runningAnimationsNumber>0) should I postpone processing of this message?
	    		if (msg instanceof API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			if (stateChanged.serverEntries.length < 1) throwError("The container sent a store message without without any user entries");
	    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
	    			hackerUserId = serverEntry.storedByUserId;
	    		}
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return;
	    		var func:Function = this[methodName] /*as Function*/;
				if (func==null) return;
				func.apply(this, msg.getMethodParameters());
    		} finally {
    			endTransaction();       
    			sendFinishedCallback(); 			
    		}        		   	
        }
        private function sendFinishedCallback():Void {        	
        	if (runningAnimationsNumber>0 || nonFinishedMsg==null) return;
			super.sendMessage( API_DoFinishedCallback.create(nonFinishedMsg.getMethodName()) );    	
        	nonFinishedMsg = null;
        }
        public function animationStarted():Void {
        	runningAnimationsNumber++;        	
        }
        public function animationEnded():Void {
        	if (runningAnimationsNumber<=0)
        		throwError("Called animationEnded too many times!");
        	runningAnimationsNumber--;
        	sendFinishedCallback();        	        	
        }
        
        
        /*override*/ public function sendMessage(msg:API_Message):Void {
        	if (msg instanceof API_DoRegisterOnServer || msg instanceof API_DoTrace) {
        		super.sendMessage(msg);
        		return;
        	}
        	if (!(msg instanceof API_DoStoreState || 
        		  StaticFunctions.startsWith(msg.getMethodName(), "doAll")))
        		StaticFunctions.throwError("Illegal sendMessage="+msg);
        	msgsInTransaction.push(msg);        	
        	finishTransaction();        	
        }
        private function finishTransaction():Void {
        	if (transactionDepth==0 && msgsInTransaction.length>0) {       		
        		super.sendMessage( API_Transaction.create(msgsInTransaction) );
        		msgsInTransaction = [];
        	}        	
        }
        public function startTransaction():Void {
        	transactionDepth++;
        }
        public function endTransaction():Void {
        	if (transactionDepth<=0) 
        		StaticFunctions.throwError("You called endTransaction when no transaction is in progress");
        	transactionDepth--;    	
        	finishTransaction();
        }
	}
