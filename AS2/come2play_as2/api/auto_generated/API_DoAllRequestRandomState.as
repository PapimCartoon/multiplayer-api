//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllRequestRandomState extends API_Message {
		public var key:Object;
		public var isSecret:Boolean;
		public static function create(key:Object, isSecret:Boolean/*<InAS3> = false </InAS3>*/):API_DoAllRequestRandomState {
			var res:API_DoAllRequestRandomState = new API_DoAllRequestRandomState();
			res.key = key;

// This is a AUTOMATICALLY GENERATED! Do not change!

			/*<InAS2>*/ if (isSecret==null) isSecret = false;/*</InAS2>*/
			res.isSecret = isSecret;
			return res;
		}
		public static var FUNCTION_ID:Number = -112;
		public static var METHOD_NAME:String = 'doAllRequestRandomState';
		public static var METHOD_PARAMS:Array = ['key', 'isSecret'];
	}
