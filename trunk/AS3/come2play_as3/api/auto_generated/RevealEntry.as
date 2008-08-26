package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class RevealEntry extends API_Message {
		public var key:String;
		public var userIds:Array/*int*/;
		public var depth:int;
		public static function create(key:String, userIds:Array/*int*//*<InAS3>*/ = null /*</InAS3>*/, depth:int/*<InAS3>*/ = 1 /*</InAS3>*/):RevealEntry {
			var res:RevealEntry = new RevealEntry();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.key = key;
			res.userIds = userIds;
			/*<InAS2> if (depth==null) depth = 1;</InAS2>*/
			res.depth = depth;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.key = parameters[pos++];
			this.userIds = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.depth = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds)+', depth=' + JSON.stringify(depth); }
		override public function toString():String { return '{RevealEntry:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'RevealEntry'; }
		override public function getMethodParameters():Array { return [key, userIds, depth]; }
	}
}
