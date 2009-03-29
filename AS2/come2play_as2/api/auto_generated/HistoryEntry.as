//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.HistoryEntry extends API_Message {
		public var message:API_Message;
		public var gotTimeInMilliSeconds:Number;
		public static function create(message:API_Message, gotTimeInMilliSeconds:Number):HistoryEntry {
			var res:HistoryEntry = new HistoryEntry();
			res.message = message;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.gotTimeInMilliSeconds = gotTimeInMilliSeconds;
			return res;
		}
		public static var FUNCTION_ID:Number = -85;
		public static var METHOD_NAME:String = 'historyEntry';
		public static var METHOD_PARAMS:Array = ['message', 'gotTimeInMilliSeconds'];
	}
