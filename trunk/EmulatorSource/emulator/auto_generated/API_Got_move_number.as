package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import emulator.JSON;
	
	import flash.display.*;
	import flash.utils.*;
	public  class API_Got_move_number extends API_Message {
		public var current_move_num:int;
		public var total_moves_num:int;
		public function API_Got_move_number(current_move_num:int, total_moves_num:int) { super('got_move_number',arguments); 
			this.current_move_num = current_move_num;
			this.total_moves_num = total_moves_num;
		}
		override public function getParametersAsString():String { return 'current_move_num=' + JSON.stringify(current_move_num)+', total_moves_num=' + JSON.stringify(total_moves_num); }
	}
}
