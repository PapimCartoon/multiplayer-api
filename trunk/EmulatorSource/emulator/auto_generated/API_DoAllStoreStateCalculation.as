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
		public static var FUNCTION_ID:int = -108;
		public static var METHOD_NAME:String = 'doAllStoreStateCalculation';
		public static var METHOD_PARAMS:Array = ['requestId', 'userEntries'];
	}
}
