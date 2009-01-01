//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoConnectedEndMatch extends API_Message {
		public var didWin:Boolean;
		public static function create(didWin:Boolean):API_DoConnectedEndMatch {
			var res:API_DoConnectedEndMatch = new API_DoConnectedEndMatch();
			res.didWin = didWin;
			return res;

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.didWin = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -106; }
		/*override*/ public function getMethodName():String { return 'doConnectedEndMatch'; }
		/*override*/ public function getMethodParameters():Array { return [didWin]; }
		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

