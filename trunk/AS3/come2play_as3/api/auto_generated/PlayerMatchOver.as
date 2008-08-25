package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class PlayerMatchOver extends SerializableClass {
		public var playerId:int;
		public var score:int;
		public var potPercentage:int;
		public static function create(playerId:int, score:int, potPercentage:int):PlayerMatchOver {
			var res:PlayerMatchOver = new PlayerMatchOver();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.playerId = playerId;
			res.score = score;
			res.potPercentage = potPercentage;
			return res;
		}
		public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		public function toString():String { return '{PlayerMatchOver: ' + getParametersAsString() + '}'; }
	}
}
