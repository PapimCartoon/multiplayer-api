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
		private var sPrefix:String;
		public function BaseGameAPI(_someMovieClip:MovieClip) {
			super(_someMovieClip, false, sPrefix = getPrefixFromFlashVars(_someMovieClip));
			if (sPrefix==null) 
				new SinglePlayerEmulator(_someMovieClip);
			StaticFunctions.performReflectionFromFlashVars(_someMovieClip);	
		}
		private var hackerUserId:int = -1;
		override public function gotError(withObj:Object, err:Error):void {
			sendMessage( API_DoAllFoundHacker.create(hackerUserId, "Got error withObj="+JSON.stringify(withObj)+" err="+AS3_vs_AS2.error2String(err)) );
		}
        override public function gotMessage(msg:API_Message):void {
        	try {
        		hackerUserId = -1;
	    		if (msg is API_GotStateChanged) {
	    			var stateChanged:API_GotStateChanged = msg as API_GotStateChanged;
	    			var serverEntry:ServerEntry = stateChanged.serverEntries[0];
	    			hackerUserId = serverEntry.storedByUserId;
	    		}
	    		var methodName:String = msg.getMethodName();
	    		if (AS3_vs_AS2.isAS3 && !this.hasOwnProperty(methodName)) return
	    		var func:Function = this[methodName] as Function;
				if (func==null) return;
				func.apply(this, msg.getMethodParameters());
    		} finally {
    			sendMessage( API_DoFinishedCallback.create(msg.getMethodName()) );        			
    		}        		   	
        }
	}
}