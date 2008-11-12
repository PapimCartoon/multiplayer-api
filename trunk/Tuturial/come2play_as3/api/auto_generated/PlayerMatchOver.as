package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

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
		override public function getFunctionId():int { return -90; }
		override public function getMethodName():String { return 'playerMatchOver'; }
		override public function getMethodParameters():Array { return [playerId, score, potPercentage]; }
		override public function getMethodParametersNum():int { return 3; }
	}
}
