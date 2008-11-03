package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*;
	public  class API_DoStoreState extends API_Message {
		public var userEntries:Array/*UserEntry*/;
		public static function create(userEntries:Array/*UserEntry*/):API_DoStoreState {
			var res:API_DoStoreState = new API_DoStoreState();
			res.userEntries = userEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.userEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'userEntries=' + JSON.stringify(userEntries); }
		override public function getFunctionId():int { return -118; }
		override public function getClassName():String { return 'API_DoStoreState'; }
		override public function getMethodName():String { return 'doStoreState'; }
		override public function getFieldNames():Array { return ['userEntries']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [userEntries]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
