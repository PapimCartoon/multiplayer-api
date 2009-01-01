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

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			res.playerId = playerId;
			res.score = score;
			res.potPercentage = potPercentage;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.playerId = parameters[pos++];
			this.score = parameters[pos++];
			this.potPercentage = parameters[pos++];

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function getFunctionId():Number { return -90; }
		/*override*/ public function getMethodName():String { return 'playerMatchOver'; }
		/*override*/ public function getMethodParameters():Array { return [playerId, score, potPercentage]; }
		/*override*/ public function getMethodParametersNum():Number { return 3; }
	}
