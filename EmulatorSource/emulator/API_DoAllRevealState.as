package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_DoAllRevealState extends API_Message {
		public var revealEntries:Array/*RevealEntry*/;
		public function API_DoAllRevealState(revealEntries:Array/*RevealEntry*/) { super('doAllRevealState',arguments); 
			this.revealEntries = revealEntries;
			for (var i:int=0; i<revealEntries.length; i++) revealEntries[i] = RevealEntry.object2RevealEntry(revealEntries[i]);
		}
		override public function getParametersAsString():String { return 'revealEntries=' + JSON.stringify(revealEntries); }
	}
}
