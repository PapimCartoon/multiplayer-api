package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_DoFinishedCallback extends API_Message {
		public var callbackName:String;
		public static function create(callbackName:String):API_DoFinishedCallback {
			var res:API_DoFinishedCallback = new API_DoFinishedCallback();
			res.callbackName = callbackName;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.callbackName = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'callbackName=' + JSON.stringify(callbackName); }
		override public function toString():String { return '{API_DoFinishedCallback:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doFinishedCallback'; }
		override public function getMethodParameters():Array { return [callbackName]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
