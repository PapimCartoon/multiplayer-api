package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
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
		override public function getParametersAsString():String { return 'requestId=' + JSON.stringify(requestId)+', userEntries=' + JSON.stringify(userEntries); }
		override public function toString():String { return '{API_DoAllStoreStateCalculation:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodName():String { return 'doAllStoreStateCalculation'; }
		override public function getMethodParameters():Array { return [requestId, userEntries]; }
	}
}
