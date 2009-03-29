//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllSetTurn extends API_Message {
		public var userId:Number;
		public var milliSecondsInTurn:Number;
		public static function create(userId:Number, milliSecondsInTurn:Number/*<InAS3> = -1 </InAS3>*/):API_DoAllSetTurn {
			var res:API_DoAllSetTurn = new API_DoAllSetTurn();
			res.userId = userId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			/*<InAS2>*/ if (milliSecondsInTurn==null) milliSecondsInTurn = -1;/*</InAS2>*/
			res.milliSecondsInTurn = milliSecondsInTurn;
			return res;
		}
		public static var FUNCTION_ID:Number = -115;
		public static var METHOD_NAME:String = 'doAllSetTurn';
		public static var METHOD_PARAMS:Array = ['userId', 'milliSecondsInTurn'];
	}
