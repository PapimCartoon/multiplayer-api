package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class API_GotRequestStateCalculation extends API_Message {
		public var requestId:int;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(requestId:int, serverEntries:Array/*ServerEntry*/):API_GotRequestStateCalculation {
			var res:API_GotRequestStateCalculation = new API_GotRequestStateCalculation();
			res.requestId = requestId;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.serverEntries = serverEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.requestId = parameters[pos++];
			this.serverEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'requestId=' + JSON.stringify(requestId)+', serverEntries=' + JSON.stringify(serverEntries); }
		override public function toString():String { return '{API_GotRequestStateCalculation:' +getParametersAsString() +'}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodName():String { return 'gotRequestStateCalculation'; }
		override public function getMethodParameters():Array { return [requestId, serverEntries]; }
	}
}
