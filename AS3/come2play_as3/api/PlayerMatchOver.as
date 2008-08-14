package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	public  class PlayerMatchOver  {
		public var playerId:int;
		public var score:int;
		public var potPercentage:int;
		public function PlayerMatchOver(playerId:int, score:int, potPercentage:int) {
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
}
