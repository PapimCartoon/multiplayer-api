//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllFoundHacker extends API_Message {
		public var userId:Number;
		public var errorDescription:String;
		public static function create(userId:Number, errorDescription:String):API_DoAllFoundHacker {
			var res:API_DoAllFoundHacker = new API_DoAllFoundHacker();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.errorDescription = errorDescription;
			return res;
		}
		public static var FUNCTION_ID:Number = -111;
		public static var METHOD_NAME:String = 'doAllFoundHacker';
		public static var METHOD_PARAMS:Array = ['userId', 'errorDescription'];
	}
