package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	public  class API_GotCustomInfo extends API_Message {
		public var infoEntries:Array/*InfoEntry*/;
		public function API_GotCustomInfo(infoEntries:Array/*InfoEntry*/) { super('gotCustomInfo',arguments); 
			this.infoEntries = infoEntries;
			for (var i:int=0; i<infoEntries.length; i++) infoEntries[i] = InfoEntry.object2InfoEntry(infoEntries[i]);
		}
		override public function getParametersAsString():String { return 'infoEntries=' + JSON.stringify(infoEntries); }
	}
}
