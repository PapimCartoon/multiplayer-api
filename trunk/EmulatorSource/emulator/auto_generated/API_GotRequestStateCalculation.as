package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class API_GotRequestStateCalculation extends API_Message {
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(serverEntries:Array/*ServerEntry*/):API_GotRequestStateCalculation { 
			var res:API_GotRequestStateCalculation = new API_GotRequestStateCalculation();
			res.serverEntries = serverEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.serverEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'serverEntries=' + JSON.stringify(serverEntries); }
		override public function toString():String { return '{API_GotRequestStateCalculation:' +getParametersAsString() +'}'; }
		override public function getMethodName():String { return 'gotRequestStateCalculation'; }
		override public function getMethodParameters():Array { return [serverEntries]; }
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
