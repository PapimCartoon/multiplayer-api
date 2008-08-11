package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_DoAllShuffleState extends API_Message {
		public var keys:Array/*String*/;
		public function API_DoAllShuffleState(keys:Array/*String*/) { super('do_all_shuffle_state',arguments); 
			this.keys = keys;
		}
		override public function toString():String { return '{API_DoAllShuffleState' + ': keys=' + JSON.stringify(keys)+'}'; }
	}
}
