//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotStateChanged extends API_Message {
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(serverEntries:Array/*ServerEntry*/):API_GotStateChanged {
			var res:API_GotStateChanged = new API_GotStateChanged();
			res.serverEntries = serverEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.serverEntries = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -119; }
		/*override*/ public function getMethodName():String { return 'gotStateChanged'; }
		/*override*/ public function getMethodParameters():Array { return [serverEntries]; }
		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

