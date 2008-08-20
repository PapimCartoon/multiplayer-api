//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllShuffleState extends API_Message {
		public var keys:Array/*String*/;
		public static function create(keys:Array/*String*/):API_DoAllShuffleState { 
			var res:API_DoAllShuffleState = new API_DoAllShuffleState();
			res.keys = keys;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.keys = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
		/*override*/ public function toString():String { return '{API_DoAllShuffleState:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doAllShuffleState'; }
		/*override*/ public function getMethodParameters():Array { return [keys]; }
	}
