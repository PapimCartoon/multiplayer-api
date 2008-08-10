package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class CombinedClientAndSecureGameAPI extends BaseGameAPI {
		public function CombinedClientAndSecureGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function got_keyboard_event(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {}
		public function got_general_info(entries:Array/*Entry*/):void {}
		public function got_user_info(user_id:int, entries:Array/*Entry*/):void {}
		public function got_user_disconnected(user_id:int):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/):void {}
		public function do_agree_on_match_over(finished_players:Array/*PlayerMatchOver*/):void { sendDoOperation('do_agree_on_match_over', arguments); }
		public function got_match_over(finished_player_ids:Array/*int*/):void {}
		public function do_start_my_turn():void { sendDoOperation('do_start_my_turn', arguments); }
		public function got_start_turn_of(user_id:int):void {}
		public function do_end_my_turn(next_turn_of_player_ids:Array/*int*/):void { sendDoOperation('do_end_my_turn', arguments); }
		public function got_end_turn_of(user_id:int):void {}
		public function do_store_match_state(entries:Array/*Entry*/):void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_id:int, entries:Array/*Entry*/):void {}
		public function do_send_message(to_user_ids:Array/*int*/, value:Object/*Serializable*/):void { sendDoOperation('do_send_message', arguments); }
		public function got_message(user_id:int, value:Object/*Serializable*/):void {}
		public function do_client_protocol_error_with_description(error_description:String):void { sendDoOperation('do_client_protocol_error_with_description', arguments); }
		// For players and jurors
		// user_id = -1 is for a juror, user_id>0 is for a user (player/viewer)
		// to reveal secret match state
		public function do_juror_unfold_match_state(key:String, to_user_id:int):void { sendDoOperation('do_juror_unfold_match_state', arguments); }
		public function do_juror_shuffle_match_state(keys:Array/*String*/):void { sendDoOperation('do_juror_shuffle_match_state', arguments); }
		public function do_juror_set_turn(turn_of_player_id:int):void { sendDoOperation('do_juror_set_turn', arguments); }
		public function do_juror_end_match(finished_players:Array/*PlayerMatchOver*/):void { sendDoOperation('do_juror_end_match', arguments); }
	}
}
