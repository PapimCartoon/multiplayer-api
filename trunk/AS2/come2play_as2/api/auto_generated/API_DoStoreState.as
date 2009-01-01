//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoStoreState extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public var revealEntries:Array/*RevealEntry*/;
		public static function create(userEntries:Array/*UserEntry*/, revealEntries:Array/*RevealEntry*//*<InAS3> = null </InAS3>*/):API_DoStoreState {
			var res:API_DoStoreState = new API_DoStoreState();
			res.userEntries = userEntries;

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

			res.revealEntries = revealEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userEntries = parameters[pos++];
			this.revealEntries = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -118; }
		/*override*/ public function getMethodName():String { return 'doStoreState'; }

// This instanceof a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [userEntries, revealEntries]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
