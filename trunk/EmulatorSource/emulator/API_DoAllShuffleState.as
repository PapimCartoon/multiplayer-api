package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_DoAllShuffleState extends API_Message {
		public var keys:Array/*String*/;
		public function API_DoAllShuffleState(keys:Array/*String*/) { super('doAllShuffleState',arguments); 
			this.keys = keys;
		}
		override public function getParametersAsString():String { return 'keys=' + JSON.stringify(keys); }
	}
}
