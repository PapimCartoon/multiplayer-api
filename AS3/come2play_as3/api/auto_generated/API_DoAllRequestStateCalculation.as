package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_DoAllRequestStateCalculation extends API_Message {
		public var keys:Array/*Object*/;
		public static function create(keys:Array/*Object*/):API_DoAllRequestStateCalculation {
			var res:API_DoAllRequestStateCalculation = new API_DoAllRequestStateCalculation();
			res.keys = keys;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.keys = parameters[pos++];
		}
		override public function getFunctionId():int { return -110; }
		override public function getMethodName():String { return 'doAllRequestStateCalculation'; }
		override public function getMethodParameters():Array { return [keys]; }
		override public function getMethodParametersNum():int { return 1; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
