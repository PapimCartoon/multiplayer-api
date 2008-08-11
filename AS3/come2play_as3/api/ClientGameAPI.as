package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	import come2play_as3.util.*;
	public  class ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(someMovieClip:MovieClip) {
			super(someMovieClip);
		}
		public function got_keyboard_event(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {}
		public function got_general_info(entries:Array/*Entry*/):void {}
		public function got_user_info(user_id:int, entries:Array/*Entry*/):void {}
		public function got_user_disconnected(user_id:int):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserStateEntry*/):void {}
		
		
		public function do_finished_callback(method_name:String):void { sendDoOperation('do_finished_callback', arguments); }
		public function do_register_on_server():void { sendDoOperation('do_register_on_server', arguments); }
		public function do_store_trace(name:String, message:Object/*Serializable*/):void { sendDoOperation('do_store_trace', arguments); }
		
		public function do_store_match_state(entries:Array/*StateEntry*/):void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_id:int, entries:Array/*StateEntry*/):void {}
		
		public function do_all_end_match(finished_players:Array/*PlayerMatchOver*/):void { sendDoOperation('do_all_end_match', arguments); }
		public function got_match_over(finished_player_ids:Array/*int*/):void {}
		
		// if user_id==-1, then nobody has the turn.
		// if milliseconds_in_turn==-1 then the default time per turn is used,
		// and if milliseconds_in_turn==0 then the user should do some actions immediately.
		public function do_all_set_turn(user_id:int, milliseconds_in_turn:int):void { sendDoOperation('do_all_set_turn', arguments); }
		public function got_turn_of(user_id:int):void {}
		
		
		// if to_user_id==-1, then the entry becomes PUBLIC
		public function do_all_reveal_state(entries:Array/*RevealEntry*/):void { sendDoOperation('do_all_reveal_state', arguments); }
		public function do_all_shuffle_state(keys:Array/*String*/):void { sendDoOperation('do_all_shuffle_state', arguments); }
		
		// if user_id=-1, then it is a bug of the game developer
		public function do_all_found_hacker(user_id:int, error_description:String):void { sendDoOperation('do_all_found_hacker', arguments); }
		
		// do_all_request_impartial_state is used to do a secret calculation
		// (e.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users, and sends them got_request_impartial_state.
		// All the users must do the exact same calls to do_store_match_state
		public function do_all_request_impartial_state(value:Object/*Serializable*/):void { sendDoOperation('do_all_request_impartial_state', arguments); }
		public function got_request_impartial_state(secret_seed:int, value:Object/*Serializable*/):void {}
		
	}
}
