package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_GotUserDisconnected extends API_Message {
		public var userId:int;
		public function API_GotUserDisconnected(userId:int) { super('gotUserDisconnected',arguments); 
			this.userId = userId;
		}
		override public function getParametersAsString():String { return 'userId=' + JSON.stringify(userId); }
	}
}
