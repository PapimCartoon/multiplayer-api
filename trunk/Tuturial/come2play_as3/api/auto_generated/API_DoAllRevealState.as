package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_DoAllRevealState extends API_Message {
		public var revealEntries:Array/*RevealEntry*/;
		public static function create(revealEntries:Array/*RevealEntry*/):API_DoAllRevealState {
			var res:API_DoAllRevealState = new API_DoAllRevealState();
			res.revealEntries = revealEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.revealEntries = parameters[pos++];
		}
		override public function getFunctionId():int { return -114; }
		override public function getMethodName():String { return 'doAllRevealState'; }
		override public function getMethodParameters():Array { return [revealEntries]; }
		override public function getMethodParametersNum():int { return 1; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
