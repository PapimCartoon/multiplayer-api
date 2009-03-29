//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

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
		public static var FUNCTION_ID:Number = -88;
		public static var METHOD_NAME:String = 'revealEntry';
		public static var METHOD_PARAMS:Array = ['key', 'userIds', 'depth'];
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

