//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotRequestStateCalculation extends API_Message {
		public var requestId:Number;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(requestId:Number, serverEntries:Array/*ServerEntry*/):API_GotRequestStateCalculation {
			var res:API_GotRequestStateCalculation = new API_GotRequestStateCalculation();
			res.requestId = requestId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.serverEntries = serverEntries;
			return res;
		}
		public static var FUNCTION_ID:Number = -109;
		public static var METHOD_NAME:String = 'gotRequestStateCalculation';
		public static var METHOD_PARAMS:Array = ['requestId', 'serverEntries'];
	}
