//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllRevealState extends API_Message {
		public var revealEntries:Array/*RevealEntry*/;
		public static function create(revealEntries:Array/*RevealEntry*/):API_DoAllRevealState {
			var res:API_DoAllRevealState = new API_DoAllRevealState();
			res.revealEntries = revealEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.revealEntries = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'revealEntries=' + JSON.stringify(revealEntries); }
		/*override*/ public function toString():String { return '{API_DoAllRevealState:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doAllRevealState'; }
		/*override*/ public function getMethodParameters():Array { return [revealEntries]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

