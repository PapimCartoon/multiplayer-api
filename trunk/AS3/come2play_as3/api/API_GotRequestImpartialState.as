package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class API_GotRequestImpartialState extends API_Message {
		public var secret_seed:int;
		public var value:Object/*Serializable*/;
		public function API_GotRequestImpartialState(secret_seed:int, value:Object/*Serializable*/) { super('got_request_impartial_state',arguments); 
			this.secret_seed = secret_seed;
			this.value = value;
		}
		override public function toString():String { return '{API_GotRequestImpartialState' + ': secret_seed=' + JSON.stringify(secret_seed) + ': value=' + JSON.stringify(value)+'}'; }
	}
}
