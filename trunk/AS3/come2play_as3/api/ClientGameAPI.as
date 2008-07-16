//Do not change the code below because this class is automatically generated!

package come2play_as3.api {
	public  class ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(parameters:Object) {
			super(parameters);
		}
		public function got_general_info(entries:Array/*Entry*/):void {}
		public function got_user_info(user_id:int, entries:Array/*Entry*/):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/):void {}
		
		public function do_agree_on_match_over(finished_players:Array/*PlayerMatchOver*/):void { sendDoOperation('do_agree_on_match_over', arguments); }
		public function got_match_over(player_ids:Array/*int*/):void {}
		
		public function do_start_my_turn():void { sendDoOperation('do_start_my_turn', arguments); }
		public function got_start_turn_of(user_id:int):void {}
		public function do_end_my_turn(next_turn_of_player_ids:Array/*int*/):void { sendDoOperation('do_end_my_turn', arguments); }
		public function got_end_turn_of(user_id:int):void {}
		
		public function do_store_match_state(entry:Entry):void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_entry:UserEntry):void {}
		
		public function do_send_message(to_user_ids:Array/*int*/, value:Object/*Serializable*/):void { sendDoOperation('do_send_message', arguments); }
		public function got_message(user_id:int, value:Object/*Serializable*/):void {}
		
		public function do_set_timer(in_seconds:int, entry:Entry):void { sendDoOperation('do_set_timer', arguments); }
		public function got_timer(in_seconds:int, user_entry:UserEntry):void {}
		
		public function do_client_protocol_error_with_description(error_description:String):void { sendDoOperation('do_client_protocol_error_with_description', arguments); }
		
		
	}
}
