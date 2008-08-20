//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllStoreStateCalculation extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public static function create(userEntries:Array/*UserEntry*/):API_DoAllStoreStateCalculation { 
			var res:API_DoAllStoreStateCalculation = new API_DoAllStoreStateCalculation();
			res.userEntries = userEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.userEntries = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
		/*override*/ public function toString():String { return '{API_DoAllStoreStateCalculation:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'doAllStoreStateCalculation'; }
		/*override*/ public function getMethodParameters():Array { return [userEntries]; }
	}
