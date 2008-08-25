//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllStoreState extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public static function create(userEntries:Array/*UserEntry*/):API_DoAllStoreState { 
			var res:API_DoAllStoreState = new API_DoAllStoreState();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.userEntries = userEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userEntries = parameters[pos++];
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
		/*override*/ public function toString():String { return '{API_DoAllStoreState:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doAllStoreState'; }
		/*override*/ public function getMethodParameters():Array { return [userEntries]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

