//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotUserDisconnected extends API_Message {
		public var userId:Number;
		public static function create(userId:Number):API_GotUserDisconnected {
			var res:API_GotUserDisconnected = new API_GotUserDisconnected();
			res.userId = userId;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public static var FUNCTION_ID:Number = -122;
		public static var METHOD_NAME:String = 'gotUserDisconnected';
		public static var METHOD_PARAMS:Array = ['userId'];
	}
