//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotUserInfo extends API_Message {
		public var userId:Number;
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(userId:Number, infoEntries:Array/*InfoEntry*/):API_GotUserInfo {
			var res:API_GotUserInfo = new API_GotUserInfo();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.infoEntries = infoEntries;
			return res;
		}
		public static var FUNCTION_ID:Number = -123;
		public static var METHOD_NAME:String = 'gotUserInfo';
		public static var METHOD_PARAMS:Array = ['userId', 'infoEntries'];
	}
