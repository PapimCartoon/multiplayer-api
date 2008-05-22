package {
	public class ClientGameAPI extends BaseGameAPI
	{
		public function ClientGameAPI(parameters:Object):void {
			super(parameters);
		}

		// Got functions. You may override these callbacks.
		public function got_general_info(keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_user_info(user_id:int, keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(user_ids:Array/*int*/, extra_match_info:Object, match_started_time:int):void {}
		public function got_match_over(user_ids:Array/*int*/):void { }
		public function got_start_turn_of(user_id:int):void { }
		public function got_end_turn_of(user_id:int):void { }
		public function got_stored_match_state(user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Object*/):void { }
		public function got_message(user_id:int, value:Object):void {}
		public function got_timer(from_user_id:int, key:String, pass_back:Object):void {}			

		// Do functions. You may call these functions.
		public function do_agree_on_match_over(user_ids:Array/*int*/, scores:Array/*int*/, pot_percentages:Array/*int*/):void {
			sendDoOperation("do_agree_on_match_over", arguments);
		}
		public function do_start_my_turn():void {
			sendDoOperation("do_start_my_turn", arguments);
		}
		public function do_end_my_turn(next_turn_of_player_ids:Array/*int*/):void {
			sendDoOperation("do_end_my_turn", arguments);
		}
		public function do_client_protocol_error_with_description(error_description:Object):void {			
			sendDoOperation("do_client_protocol_error_with_description", arguments);
		}
		public function do_store_match_state(key:String, value:Object):void {
			sendDoOperation("do_store_match_state", arguments);
		}
		public function do_send_message(to_user_ids:Array/*int*/, value:Object):void {
			sendDoOperation("do_send_message", arguments);
		}
		public function do_set_timer(key:String, in_seconds:int, pass_back:Object):void {
			sendDoOperation("do_set_timer", arguments);
		}
	}
}