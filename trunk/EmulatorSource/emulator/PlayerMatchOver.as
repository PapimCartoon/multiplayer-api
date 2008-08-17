package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
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
			if (obj.playerId==null) throw new Error('Missing field "playerId" when creating PlayerMatchOver from the object='+JSON.stringify(obj));
			if (obj.score==null) throw new Error('Missing field "score" when creating PlayerMatchOver from the object='+JSON.stringify(obj));
			if (obj.potPercentage==null) throw new Error('Missing field "potPercentage" when creating PlayerMatchOver from the object='+JSON.stringify(obj));
			return new PlayerMatchOver(obj.playerId, obj.score, obj.potPercentage)
		}
		public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		public function toString():String { return '{PlayerMatchOver: ' + getParametersAsString() + '}'; }
	}
}
