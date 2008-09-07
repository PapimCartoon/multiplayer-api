//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.RevealEntry extends API_Message {
		public var key/*any type*/;
		public var userIds:Array/*int*/;
		public var depth:Number;
		public static function create(key/*any type*/, userIds:Array/*int*//*<InAS3> = null </InAS3>*/, depth:Number/*<InAS3> = 0 </InAS3>*/):RevealEntry {
			var res:RevealEntry = new RevealEntry();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.key = key;
			res.userIds = userIds;
			/*<InAS2>*/ if (depth==null) depth = 0;/*</InAS2>*/
			res.depth = depth;
			return res;
		}
		/*override*/ public function setMethodParameters(parameters:Array):Void { 
			var pos:Number = 0;
			this.key = parameters[pos++];
			this.userIds = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.depth = parameters[pos++];
		}
		/*override*/ public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds)+', depth=' + JSON.stringify(depth); }
		/*override*/ public function toString():String { return '{RevealEntry:' +getParametersAsString() +'}'; }
		/*override*/ public function getMethodName():String { return 'RevealEntry'; }
		/*override*/ public function getMethodParameters():Array { return [key, userIds, depth]; }
	}
