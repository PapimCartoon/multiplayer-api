//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMatchStarted extends API_Message {
		public var msgNum:Number;
		public var allPlayerIds:Array/*int*/;
		public var finishedPlayerIds:Array/*int*/;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(msgNum:Number, allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):API_GotMatchStarted {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var res:API_GotMatchStarted = new API_GotMatchStarted();
			res.msgNum = msgNum;
			res.allPlayerIds = allPlayerIds;
			res.finishedPlayerIds = finishedPlayerIds;
			res.serverEntries = serverEntries;
			return res;
		}
		public static var FUNCTION_ID:Number = -121;
		public static var METHOD_NAME:String = 'gotMatchStarted';
		public static var METHOD_PARAMS:Array = ['msgNum', 'allPlayerIds', 'finishedPlayerIds', 'serverEntries'];

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
