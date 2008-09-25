package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class PlayerMatchOver extends API_Message {
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
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.playerId = parameters[pos++];
			this.score = parameters[pos++];
			this.potPercentage = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		override public function toString():String { return '{PlayerMatchOver:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'PlayerMatchOver'; }
		override public function getMethodParameters():Array { return [playerId, score, potPercentage]; }
	}
}
