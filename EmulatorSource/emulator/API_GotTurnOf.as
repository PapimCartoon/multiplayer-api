package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_GotTurnOf extends API_Message {
		public var userId:int;
		public function API_GotTurnOf(userId:int) { super('gotTurnOf',arguments); 
			this.userId = userId;
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId); }
	}
}
