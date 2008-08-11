package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_GotMyUserId extends API_Message {
		public var my_user_id:int;
		public function API_GotMyUserId(my_user_id:int) { super('got_my_user_id',arguments); 
			this.my_user_id = my_user_id;
		}
		override public function toString():String { return '{API_GotMyUserId' + ': my_user_id=' + JSON.stringify(my_user_id)+'}'; }
	}
}
