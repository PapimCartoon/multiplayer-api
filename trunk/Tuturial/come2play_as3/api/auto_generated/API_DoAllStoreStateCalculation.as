package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_DoAllStoreStateCalculation extends API_Message {
		public var requestId:int;
		public var userEntries:Array/*UserEntry*/;
		public static function create(requestId:int, userEntries:Array/*UserEntry*/):API_DoAllStoreStateCalculation {
			var res:API_DoAllStoreStateCalculation = new API_DoAllStoreStateCalculation();
			res.requestId = requestId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.userEntries = userEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.requestId = parameters[pos++];
			this.userEntries = parameters[pos++];
		}
		override public function getFunctionId():int { return -108; }
		override public function getMethodName():String { return 'doAllStoreStateCalculation'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [requestId, userEntries]; }
		override public function getMethodParametersNum():int { return 2; }
	}
}
