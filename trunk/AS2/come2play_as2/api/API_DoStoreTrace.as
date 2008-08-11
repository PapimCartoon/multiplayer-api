//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoStoreTrace extends API_Message {
		public var name:String;
		public var message:Object/*Serializable*/;
		public function API_DoStoreTrace(name:String, message:Object/*Serializable*/) { super('do_store_trace',arguments); 
			this.name = name;
			this.message = message;
		}
		/*override*/ public function toString():String { return '{API_DoStoreTrace' + ': name=' + JSON.stringify(name) + ': message=' + JSON.stringify(message)+'}'; }
	}
