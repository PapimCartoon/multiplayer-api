package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_DoAllRevealState extends API_Message {
		public var revealEntries:Array/*RevealEntry*/;
		public static function create(revealEntries:Array/*RevealEntry*/):API_DoAllRevealState { 
			var res:API_DoAllRevealState = new API_DoAllRevealState();
			res.revealEntries = revealEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.revealEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'revealEntries=' + JSON.stringify(revealEntries); }
		override public function toString():String { return '{API_DoAllRevealState:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doAllRevealState'; }
		override public function getMethodParameters():Array { return [revealEntries]; }
	}
}
