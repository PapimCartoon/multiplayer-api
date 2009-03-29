//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoFinishedCallback extends API_Message {
		public var callbackName:String;
		public var msgNum:Number;
		public static function create(callbackName:String, msgNum:Number):API_DoFinishedCallback {
			var res:API_DoFinishedCallback = new API_DoFinishedCallback();
			res.callbackName = callbackName;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.msgNum = msgNum;
			return res;
		}
		public static var FUNCTION_ID:Number = -128;
		public static var METHOD_NAME:String = 'doFinishedCallback';
		public static var METHOD_PARAMS:Array = ['callbackName', 'msgNum'];
	}
