//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoConnectedEndMatch extends API_Message {
		public var didWin:Boolean;
		public static function create(didWin:Boolean):API_DoConnectedEndMatch { 
			var res:API_DoConnectedEndMatch = new API_DoConnectedEndMatch();
			res.didWin = didWin;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.didWin = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'didWin=' + JSON.stringify(didWin); }
		/*override*/ public function toString():String { return '{API_DoConnectedEndMatch:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doConnectedEndMatch'; }
		/*override*/ public function getMethodParameters():Array { return [didWin]; }
	}
