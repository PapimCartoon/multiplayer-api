package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class PlayerMatchOver extends SerializableClass {
		public var playerId:int;
		public var score:int;
		public var potPercentage:int;
		public static function create(playerId:int, score:int, potPercentage:int):PlayerMatchOver {
			var res:PlayerMatchOver = new PlayerMatchOver();
			res.playerId = playerId;
			res.score = score;
			res.potPercentage = potPercentage;
			return res;
		}
		public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		public function toString():String { return '{PlayerMatchOver: ' + getParametersAsString() + '}'; }
	}
}
