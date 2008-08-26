package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_DoConnectedEndMatch extends API_Message {
		public var didWin:Boolean;
		public static function create(didWin:Boolean):API_DoConnectedEndMatch {
			var res:API_DoConnectedEndMatch = new API_DoConnectedEndMatch();
			res.didWin = didWin;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.didWin = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'didWin=' + JSON.stringify(didWin); }
		override public function toString():String { return '{API_DoConnectedEndMatch:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'doConnectedEndMatch'; }
		override public function getMethodParameters():Array { return [didWin]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
