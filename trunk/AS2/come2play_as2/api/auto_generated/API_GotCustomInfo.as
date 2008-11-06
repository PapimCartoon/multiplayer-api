//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_GotCustomInfo extends API_Message {
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(infoEntries:Array/*InfoEntry*/):API_GotCustomInfo {
			var res:API_GotCustomInfo = new API_GotCustomInfo();
			res.infoEntries = infoEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.infoEntries = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -124; }
		/*override*/ public function getMethodName():String { return 'gotCustomInfo'; }
		/*override*/ public function getMethodParameters():Array { return [infoEntries]; }
		/*override*/ public function getMethodParametersNum():Number { return 1; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

