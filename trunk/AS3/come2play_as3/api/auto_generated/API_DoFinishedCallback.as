package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

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
		override public function getFunctionId():int { return -128; }
		override public function getMethodName():String { return 'doFinishedCallback'; }
		override public function getMethodParameters():Array { return [callbackName]; }
		override public function getMethodParametersNum():int { return 1; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
