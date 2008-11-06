package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_GotMatchStarted extends API_Message {
		public var allPlayerIds:Array/*int*/;
		public var finishedPlayerIds:Array/*int*/;
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):API_GotMatchStarted {
			var res:API_GotMatchStarted = new API_GotMatchStarted();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.allPlayerIds = allPlayerIds;
			res.finishedPlayerIds = finishedPlayerIds;
			res.serverEntries = serverEntries;
			return res;
		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.allPlayerIds = parameters[pos++];
			this.finishedPlayerIds = parameters[pos++];
			this.serverEntries = parameters[pos++];

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function getFunctionId():int { return -121; }
		override public function getMethodName():String { return 'gotMatchStarted'; }
		override public function getMethodParameters():Array { return [allPlayerIds, finishedPlayerIds, serverEntries]; }
		override public function getMethodParametersNum():int { return 3; }
	}
}
