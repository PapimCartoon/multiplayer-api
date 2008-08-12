//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_DoTrace extends API_Message {
		public var name:String;
		public var message:Object/*Serializable*/;
		public function API_DoTrace(name:String, message:Object/*Serializable*/) { super('doTrace',arguments); 
			this.name = name;
			this.message = message;
		}
		/*override*/ public function getParametersAsString():String { return 'name=' + JSON.stringify(name)+', message=' + JSON.stringify(message); }
	}
