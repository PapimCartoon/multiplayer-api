package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoStoreState extends API_Message {
		public var stateEntries:Array/*StateEntry*/;
		public function API_DoStoreState(stateEntries:Array/*StateEntry*/) { super('doStoreState',arguments); 
			this.stateEntries = stateEntries;
			for (var i:int=0; i<stateEntries.length; i++) stateEntries[i] = StateEntry.object2StateEntry(stateEntries[i]);
		}
		override public function getParametersAsString():String { return 'stateEntries=' + JSON.stringify(stateEntries); }
	}
}
