package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class UserEntry extends API_Message {
		public var key:*;
		public var value:*;
		public var isSecret:Boolean;
		public static function create(key:*, value:*, isSecret:Boolean/*<InAS3>*/ = false /*</InAS3>*/):UserEntry {
			var res:UserEntry = new UserEntry();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.key = key;
			res.value = value;
			/*<InAS2> if (isSecret==null) isSecret = false;</InAS2>*/
			res.isSecret = isSecret;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.key = parameters[pos++];
			this.value = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

			this.isSecret = parameters[pos++];
		}
		override public function getFunctionId():int { return -87; }
		override public function getMethodName():String { return 'userEntry'; }
		override public function getMethodParameters():Array { return [key, value, isSecret]; }
		override public function getMethodParametersNum():int { return 3; }
	}
}
