package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_GotRequestStateCalculation extends API_Message {
		public var serverEntries:Array/*ServerEntry*/;
		public function API_GotRequestStateCalculation(serverEntries:Array/*ServerEntry*/) { super('gotRequestStateCalculation',arguments); 
			this.serverEntries = serverEntries;
			for (var i:int=0; i<serverEntries.length; i++) serverEntries[i] = ServerEntry.object2ServerEntry(serverEntries[i]);
		}
		override public function getParametersAsString():String { return 'serverEntries=' + JSON.stringify(serverEntries); }
	}
}
