//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllRequestStateCalculation extends API_Message {
		public var keys:Array/*Object*/;
		public static function create(keys:Array/*Object*/):API_DoAllRequestStateCalculation {
			var res:API_DoAllRequestStateCalculation = new API_DoAllRequestStateCalculation();
			res.keys = keys;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.keys = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
		/*override*/ public function getFunctionId():Number { return -109; }
		/*override*/ public function getClassName():String { return 'API_DoAllRequestStateCalculation'; }
		/*override*/ public function getMethodName():String { return 'doAllRequestStateCalculation'; }
		/*override*/ public function getFieldNames():Array { return ['keys']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [keys]; }
		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}
