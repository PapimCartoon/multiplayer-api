//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotRequestStateCalculation extends API_Message {
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(serverEntries:Array/*ServerEntry*/):API_GotRequestStateCalculation { 
			var res:API_GotRequestStateCalculation = new API_GotRequestStateCalculation();
			res.serverEntries = serverEntries;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.serverEntries = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'serverEntries=' + JSON.stringify(serverEntries); }
		/*override*/ public function toString():String { return '{API_GotRequestStateCalculation:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'gotRequestStateCalculation'; }
		/*override*/ public function getMethodParameters():Array { return [serverEntries]; }
	}
