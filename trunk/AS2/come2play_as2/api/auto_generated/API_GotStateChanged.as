//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotStateChanged extends API_Message {
		public var msgNum:Number;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(msgNum:Number, serverEntries:Array/*ServerEntry*/):API_GotStateChanged {
			var res:API_GotStateChanged = new API_GotStateChanged();
			res.msgNum = msgNum;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.serverEntries = serverEntries;
			return res;
		}
		public static var FUNCTION_ID:Number = -119;
		public static var METHOD_NAME:String = 'gotStateChanged';
		public static var METHOD_PARAMS:Array = ['msgNum', 'serverEntries'];
	}
