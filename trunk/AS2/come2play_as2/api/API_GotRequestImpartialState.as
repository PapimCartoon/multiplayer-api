//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
import come2play_as2.api.*;
	class come2play_as2.api.API_GotRequestImpartialState extends API_Message {
		public var secret_seed:Number;
		public var value:Object/*Serializable*/;
		public function API_GotRequestImpartialState(secret_seed:Number, value:Object/*Serializable*/) { super('got_request_impartial_state',arguments); 
			this.secret_seed = secret_seed;
			this.value = value;
		}
		/*override*/ public function toString():String { return '{API_GotRequestImpartialState' + ': secret_seed=' + JSON.stringify(secret_seed) + ': value=' + JSON.stringify(value)+'}'; }
	}
