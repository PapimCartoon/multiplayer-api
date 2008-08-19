package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_DoFinishedCallback extends API_Message {
		public var callbackName:String;
		public function API_DoFinishedCallback(callbackName:String) { super('doFinishedCallback',arguments); 
			this.callbackName = callbackName;
		}
		override public function getParametersAsString():String { return 'callbackName=' + JSON.stringify(callbackName); }
	}
}
