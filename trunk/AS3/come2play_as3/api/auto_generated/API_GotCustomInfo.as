package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class API_GotCustomInfo extends API_Message {
		public var infoEntries:Array/*InfoEntry*/;
		public static function create(infoEntries:Array/*InfoEntry*/):API_GotCustomInfo {
			var res:API_GotCustomInfo = new API_GotCustomInfo();
			res.infoEntries = infoEntries;
			return res;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		override public function setMethodParameters(parameters:Array):void { 
			var pos:int = 0;
			this.infoEntries = parameters[pos++];
		}
		override public function getParametersAsString():String { return 'infoEntries=' + JSON.stringify(infoEntries); }
		override public function getFunctionId():int { return -124; }
		override public function getClassName():String { return 'API_GotCustomInfo'; }
		override public function getMethodName():String { return 'gotCustomInfo'; }
		override public function getFieldNames():Array { return ['infoEntries']; }

// This is a AUTOMATICALLY GENERATED! Do not change!

		override public function getMethodParameters():Array { return [infoEntries]; }
		override public function getMethodParametersNum():int { return 1; }
	}
}
