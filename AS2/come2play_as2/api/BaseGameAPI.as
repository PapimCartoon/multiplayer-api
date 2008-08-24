	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;
	
	import flash.external.*;
	
	/**
	 * See http://code.google.com/p/multiplayer-api
	 */ 
import come2play_as2.api.*;
	class come2play_as2.api.BaseGameAPI extends LocalConnectionUser 
	{        
		private var sPrefix:String;
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, sPrefix = getPrefixFromFlashVars(_someMovieClip));
			API_LoadMessages.useAll();	
			if (sPrefix==null) 
				new SinglePlayerEmulator(_someMovieClip);		
		}
		private var hackerUserId:Number = -1;
		/*override*/ public function gotError(withObj:Object, err:Error):Void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, "Got error withObj="+JSON.stringify(withObj)+" err="+AS3_vs_AS2.error2String(err)) );
		}
        /*override*/ public function gotMessage(msg:API_Message):Void {
        	try {
        		hackerUserId = -1;
	    		if (msg instanceof API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = API_GotStateChanged(msg);
	    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
	    			hackerUserId = serverEntry.storedByUserId;
	    		}
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return
	    		var func:Function = this[methodName] /*as Function*/;
				if (func==null) return;
				func.apply(this, msg.getMethodParameters());
    		} finally {
    			sendMessage( API_DoFinishedCallback.create(msg.getMethodName()) );        			
    		}        		   	
        }
	}
