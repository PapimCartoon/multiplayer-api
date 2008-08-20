//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllEndMatch extends API_Message {
		public var finishedPlayers:Array/*PlayerMatchOver*/;
		public static function create(finishedPlayers:Array/*PlayerMatchOver*/):API_DoAllEndMatch { 
			var res:API_DoAllEndMatch = new API_DoAllEndMatch();
			res.finishedPlayers = finishedPlayers;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.finishedPlayers = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'finishedPlayers=' + JSON.stringify(finishedPlayers); }
		/*override*/ public function toString():String { return '{API_DoAllEndMatch:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doAllEndMatch'; }
		/*override*/ public function getMethodParameters():Array { return [finishedPlayers]; }
	}
