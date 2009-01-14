//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.InfoEntry extends API_Message {
		public var key:String;
		public var value:Object;
		public static function create(key:String, value:Object):InfoEntry {
			var res:InfoEntry = new InfoEntry();
			res.key = key;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.value = value;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.key = parameters[pos++];
			this.value = parameters[pos++];
		}
		/*override*/ public function getFunctionId():Number { return -89; }
		/*override*/ public function getMethodName():String { return 'infoEntry'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		/*override*/ public function getMethodParameters():Array { return [key, value]; }
		/*override*/ public function getMethodParametersNum():Number { return 2; }
	}
