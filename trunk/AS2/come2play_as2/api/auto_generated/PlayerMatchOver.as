//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.PlayerMatchOver extends SerializableClass {
		public var playerId:Number;
		public var score:Number;
		public var potPercentage:Number;
		public static function create(playerId:Number, score:Number, potPercentage:Number):PlayerMatchOver {
			var res:PlayerMatchOver = new PlayerMatchOver();
			res.playerId = playerId;
			res.score = score;
			res.potPercentage = potPercentage;
			return res;
		}
		public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		public function toString():String { return '{PlayerMatchOver: ' + getParametersAsString() + '}'; }
	}
