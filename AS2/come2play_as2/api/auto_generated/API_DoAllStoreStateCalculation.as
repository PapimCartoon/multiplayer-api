//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllStoreStateCalculation extends API_Message {
		public var requestId:Number;
		public var userEntries:Array/*UserEntry*/;
		public static function create(requestId:Number, userEntries:Array/*UserEntry*/):API_DoAllStoreStateCalculation {
			var res:API_DoAllStoreStateCalculation = new API_DoAllStoreStateCalculation();
			res.requestId = requestId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.userEntries = userEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.requestId = parameters[pos++];
			this.userEntries = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'requestId=' + JSON.stringify(requestId)+', userEntries=' + JSON.stringify(userEntries); }
		/*override*/ public function toString():String { return '{API_DoAllStoreStateCalculation:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodName():String { return 'doAllStoreStateCalculation'; }
		/*override*/ public function getMethodParameters():Array { return [requestId, userEntries]; }
	}
