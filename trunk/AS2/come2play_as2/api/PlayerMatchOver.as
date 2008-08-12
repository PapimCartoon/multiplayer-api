//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.PlayerMatchOver  {
		public var playerId:Number;
		public var score:Number;
		public var potPercentage:Number;
		public function PlayerMatchOver(playerId:Number, score:Number, potPercentage:Number) {
			this.playerId = playerId;
			this.score = score;
			this.potPercentage = potPercentage;
		}
		public static function object2PlayerMatchOver(obj:Object):PlayerMatchOver {
			if (obj.playerId==null) throw new Error('Missing field playerId in creating object of type PlayerMatchOver in object='+JSON.stringify(obj));
			if (obj.score==null) throw new Error('Missing field score in creating object of type PlayerMatchOver in object='+JSON.stringify(obj));
			if (obj.potPercentage==null) throw new Error('Missing field potPercentage in creating object of type PlayerMatchOver in object='+JSON.stringify(obj));
			return new PlayerMatchOver(obj.playerId, obj.score, obj.potPercentage)
		}
		public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		public function toString():String { return '{PlayerMatchOver: ' + getParametersAsString() + '}'; }
	}
