package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
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
			if (obj['playerId']===undefined) throw new Error('Missing field "playerId" when creating PlayerMatchOver from the object='+JSON.stringify(obj));
			if (obj['score']===undefined) throw new Error('Missing field "score" when creating PlayerMatchOver from the object='+JSON.stringify(obj));
			if (obj['potPercentage']===undefined) throw new Error('Missing field "potPercentage" when creating PlayerMatchOver from the object='+JSON.stringify(obj));
			return new PlayerMatchOver(obj.playerId, obj.score, obj.potPercentage)
		}
		public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		public function toString():String { return '{PlayerMatchOver: ' + getParametersAsString() + '}'; }
	}
}
