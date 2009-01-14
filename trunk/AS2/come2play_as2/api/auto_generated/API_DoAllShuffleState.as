//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllShuffleState extends API_Message {
		public var keys:Array/*Object*/;
		public static function create(keys:Array/*Object*/):API_DoAllShuffleState {
			var res:API_DoAllShuffleState = new API_DoAllShuffleState();
			res.keys = keys;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.keys = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -113; }
		/*override*/ public function getMethodName():String { return 'doAllShuffleState'; }
		/*override*/ public function getMethodParameters():Array { return [keys]; }
		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

