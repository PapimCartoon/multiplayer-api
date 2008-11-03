//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.UserEntry extends API_Message {
		public var key/*any type*/;
		public var value/*any type*/;
		public var isSecret:Boolean;
		public static function create(key/*any type*/, value/*any type*/, isSecret:Boolean/*<InAS3> = false </InAS3>*/):UserEntry {
			var res:UserEntry = new UserEntry();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.key = key;
			res.value = value;
			/*<InAS2>*/ if (isSecret==null) isSecret = false;/*</InAS2>*/
			res.isSecret = isSecret;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.key = parameters[pos++];
			this.value = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.isSecret = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', isSecret=' + JSON.stringify(isSecret); }
		/*override*/ public function getFunctionId():Number { return -87; }
		/*override*/ public function getClassName():String { return 'UserEntry'; }
		/*override*/ public function getMethodName():String { return 'userEntry'; }
		/*override*/ public function getFieldNames():Array { return ['key', 'value', 'isSecret']; }
		/*override*/ public function getMethodParameters():Array { return [key, value, isSecret]; }
		/*override*/ public function getMethodParametersNum():Number { return 3; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

