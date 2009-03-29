//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_DoAllRevealState extends API_Message {
		public var revealEntries:Array/*RevealEntry*/;
		public static function create(revealEntries:Array/*RevealEntry*/):API_DoAllRevealState {
			var res:API_DoAllRevealState = new API_DoAllRevealState();
			res.revealEntries = revealEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public static var FUNCTION_ID:Number = -114;
		public static var METHOD_NAME:String = 'doAllRevealState';
		public static var METHOD_PARAMS:Array = ['revealEntries'];
	}
