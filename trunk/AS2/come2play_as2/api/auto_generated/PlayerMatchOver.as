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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function getParametersAsString():String { return 'playerId=' + JSON.stringify(playerId)+', score=' + JSON.stringify(score)+', potPercentage=' + JSON.stringify(potPercentage); }
		/*override*/ public function toString():String { return '{PlayerMatchOver:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'PlayerMatchOver'; }
		/*override*/ public function getMethodParameters():Array { return [playerId, score, potPercentage]; }
	}
