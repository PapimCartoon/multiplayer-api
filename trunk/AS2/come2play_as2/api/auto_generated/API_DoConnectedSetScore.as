//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoConnectedSetScore extends API_Message {
		public var score:Number;
		public static function create(score:Number):API_DoConnectedSetScore {
			var res:API_DoConnectedSetScore = new API_DoConnectedSetScore();
			res.score = score;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public static var FUNCTION_ID:Number = -107;
		public static var METHOD_NAME:String = 'doConnectedSetScore';
		public static var METHOD_PARAMS:Array = ['score'];
	}
