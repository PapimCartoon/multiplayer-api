package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_DoAllRequestImpartialState extends API_Message {
		public var value:Object/*Serializable*/;
		public function API_DoAllRequestImpartialState(value:Object/*Serializable*/) { super('do_all_request_impartial_state',arguments); 
			this.value = value;
		}
		override public function toString():String { return '{API_DoAllRequestImpartialState' + ': value=' + JSON.stringify(value)+'}'; }
	}
}
