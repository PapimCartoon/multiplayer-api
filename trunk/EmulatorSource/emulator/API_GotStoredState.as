package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_GotStoredState extends API_Message {
		public var userId:int;
		public var stateEntries:Array/*StateEntry*/;
		public function API_GotStoredState(userId:int, stateEntries:Array/*StateEntry*/) { super('gotStoredState',arguments); 
			this.userId = userId;
			this.stateEntries = stateEntries;
			for (var i:int=0; i<stateEntries.length; i++) stateEntries[i] = StateEntry.object2StateEntry(stateEntries[i]);
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId)+', stateEntries=' + JSON.stringify(stateEntries); }
	}
}
