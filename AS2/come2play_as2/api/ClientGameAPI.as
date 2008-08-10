//Do not change the code below because this class was generated automatically!

import come2play_as2.api.*;
	class come2play_as2.api.ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function got_general_info(entries:Array/*Entry*/):Void {}
		public function got_user_info(user_id:Number, entries:Array/*Entry*/):Void {}
		public function got_user_disconnected(user_id:Number):Void {}
		public function got_my_user_id(my_user_id:Number):Void {}
		public function got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, match_state:Array/*UserEntry*/):Void {}
		
		// agree_on_match_over
		public function do_all_end_match(finished_players:Array/*PlayerMatchOver*/):Void { sendDoOperation('do_all_end_match', arguments); }
		public function got_match_over(finished_player_ids:Array/*int*/):Void {}
		
		// if user_id==-1, then nobody has the turn.
		// if milliseconds_in_turn==-1 then the default time per turn is used,
		// and if milliseconds_in_turn==0 then the user should do some actions immediately.
		public function do_all_set_turn(user_id:Number, milliseconds_in_turn:Number):Void { sendDoOperation('do_all_set_turn', arguments); }
		public function got_start_turn_of(user_id:Number):Void {}
		public function got_end_turn_of(user_id:Number):Void {}
		
		public function do_store_match_state(entries:Array/*Entry*/):Void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_id:Number, entries:Array/*Entry*/):Void {}
		
		// if to_user_id==-1, then the entry becomes PUBLIC
		public function do_all_reveal_state(key:String, to_user_id:Number):Void { sendDoOperation('do_all_reveal_state', arguments); }
		public function do_all_shuffle_state(keys:Array/*String*/):Void { sendDoOperation('do_all_shuffle_state', arguments); }
		
		// old name: do_client_protocol_error_with_description
		public function do_all_found_hacker(user_id:Number, error_description:String):Void { sendDoOperation('do_all_found_hacker', arguments); }
		
		
		
	}
