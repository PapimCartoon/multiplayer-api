package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_GotStateChanged extends API_Message {
		public var serverEntries:Array/*ServerEntry*/;
		public static function create(serverEntries:Array/*ServerEntry*/):API_GotStateChanged {
			var res:API_GotStateChanged = new API_GotStateChanged();
			res.serverEntries = serverEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.serverEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'serverEntries=' + JSON.stringify(serverEntries); }
		override public function getFunctionId():int { return -118; }
		override public function getClassName():String { return 'API_GotStateChanged'; }
		override public function getMethodName():String { return 'gotStateChanged'; }
		override public function getFieldNames():Array { return ['serverEntries']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [serverEntries]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
