//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoConnectedSetScore extends API_Message {
		public var score:Number;
		public static function create(score:Number):API_DoConnectedSetScore {
			var res:API_DoConnectedSetScore = new API_DoConnectedSetScore();
			res.score = score;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.score = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'score=' + JSON.stringify(score); }
		/*override*/ public function toString():String { return '{API_DoConnectedSetScore:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doConnectedSetScore'; }
		/*override*/ public function getMethodParameters():Array { return [score]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

