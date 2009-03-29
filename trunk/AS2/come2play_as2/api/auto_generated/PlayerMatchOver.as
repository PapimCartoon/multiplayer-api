//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.PlayerMatchOver extends API_Message {
		public var playerId:Number;
		public var score:Number;
		public var potPercentage:Number;
		public static function create(playerId:Number, score:Number, potPercentage:Number):PlayerMatchOver {
			var res:PlayerMatchOver = new PlayerMatchOver();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.playerId = playerId;
			res.score = score;
			res.potPercentage = potPercentage;
			return res;
		}
		public static var FUNCTION_ID:Number = -90;
		public static var METHOD_NAME:String = 'playerMatchOver';
		public static var METHOD_PARAMS:Array = ['playerId', 'score', 'potPercentage'];
	}
