//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotMatchEnded extends API_Message {
		public var msgNum:Number;
		public var finishedPlayerIds:Array/*int*/;
		public static function create(msgNum:Number, finishedPlayerIds:Array/*int*/):API_GotMatchEnded {
			var res:API_GotMatchEnded = new API_GotMatchEnded();
			res.msgNum = msgNum;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.finishedPlayerIds = finishedPlayerIds;
			return res;
		}
		public static var FUNCTION_ID:Number = -120;
		public static var METHOD_NAME:String = 'gotMatchEnded';
		public static var METHOD_PARAMS:Array = ['msgNum', 'finishedPlayerIds'];
	}
