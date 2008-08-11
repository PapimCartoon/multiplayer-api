package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_DoStoreTrace extends API_Message {
		public var name:String;
		public var message:Object/*Serializable*/;
		public function API_DoStoreTrace(name:String, message:Object/*Serializable*/) { super('do_store_trace',arguments); 
			this.name = name;
			this.message = message;
		}
		override public function toString():String { return '{API_DoStoreTrace' + ': name=' + JSON.stringify(name) + ': message=' + JSON.stringify(message)+'}'; }
	}
}
