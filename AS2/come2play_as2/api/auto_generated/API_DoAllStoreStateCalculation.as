//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllStoreStateCalculation extends API_Message {
		public var requestId:Number;
		public var userEntries:Array/*UserEntry*/;
		public static function create(requestId:Number, userEntries:Array/*UserEntry*/):API_DoAllStoreStateCalculation {
			var res:API_DoAllStoreStateCalculation = new API_DoAllStoreStateCalculation();
			res.requestId = requestId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.userEntries = userEntries;
			return res;
		}
		public static var FUNCTION_ID:Number = -108;
		public static var METHOD_NAME:String = 'doAllStoreStateCalculation';
		public static var METHOD_PARAMS:Array = ['requestId', 'userEntries'];
	}
