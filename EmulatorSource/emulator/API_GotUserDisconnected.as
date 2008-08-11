package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_GotUserDisconnected extends API_Message {
		public var user_id:int;
		public function API_GotUserDisconnected(user_id:int) { super('got_user_disconnected',arguments); 
			this.user_id = user_id;
		}
		override public function toString():String { return '{API_GotUserDisconnected' + ': user_id=' + JSON.stringify(user_id)+'}'; }
	}
}
