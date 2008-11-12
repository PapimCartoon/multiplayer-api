package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_DoAllShuffleState extends API_Message {
		public var keys:Array/*Object*/;
		public static function create(keys:Array/*Object*/):API_DoAllShuffleState {
			var res:API_DoAllShuffleState = new API_DoAllShuffleState();
			res.keys = keys;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.keys = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
		override public function getFunctionId():int { return -113; }
		override public function getClassName():String { return 'API_DoAllShuffleState'; }
		override public function getMethodName():String { return 'doAllShuffleState'; }
		override public function getFieldNames():Array { return ['keys']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [keys]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
