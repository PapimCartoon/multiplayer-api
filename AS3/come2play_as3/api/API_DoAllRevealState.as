package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoAllRevealState extends API_Message {
		public var entries:Array/*RevealEntry*/;
		public function API_DoAllRevealState(entries:Array/*RevealEntry*/) { super('do_all_reveal_state',arguments); 
			this.entries = entries;
			for (var i:int=0; i<entries.length; i++) entries[i] = RevealEntry.object2RevealEntry(entries[i]);
		}
		override public function toString():String { return '{API_DoAllRevealState' + ': entries=' + JSON.stringify(entries)+'}'; }
	}
}
