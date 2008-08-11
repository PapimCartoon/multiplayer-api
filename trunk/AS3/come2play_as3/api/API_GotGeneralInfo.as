package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotGeneralInfo extends API_Message {
		public var entries:Array/*Entry*/;
		public function API_GotGeneralInfo(entries:Array/*Entry*/) { super('got_general_info',arguments); 
			this.entries = entries;
			for (var i:int=0; i<entries.length; i++) entries[i] = Entry.object2Entry(entries[i]);
		}
		override public function toString():String { return '{API_GotGeneralInfo' + ': entries=' + JSON.stringify(entries)+'}'; }
	}
}
