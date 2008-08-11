//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
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
		public function got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, match_state:Array/*UserStateEntry*/):Void {}
		
		
		public function do_finished_callback(method_name:String):Void { sendDoOperation('do_finished_callback', arguments); }
		public function do_register_on_server():Void { sendDoOperation('do_register_on_server', arguments); }
		public function do_store_trace(name:String, message:Object/*Serializable*/):Void { sendDoOperation('do_store_trace', arguments); }
		
		public function do_store_match_state(entries:Array/*StateEntry*/):Void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_id:Number, entries:Array/*StateEntry*/):Void {}
		
		public function do_all_end_match(finished_players:Array/*PlayerMatchOver*/):Void { sendDoOperation('do_all_end_match', arguments); }
		public function got_match_over(finished_player_ids:Array/*int*/):Void {}
		
		// if user_id==-1, then nobody has the turn.
		// if milliseconds_in_turn==-1 then the default time per turn is used,
		// and if milliseconds_in_turn==0 then the user should do some actions immediately.
		public function do_all_set_turn(user_id:Number, milliseconds_in_turn:Number):Void { sendDoOperation('do_all_set_turn', arguments); }
		public function got_turn_of(user_id:Number):Void {}
		
		
		// if to_user_id==-1, then the entry becomes PUBLIC
		public function do_all_reveal_state(entries:Array/*RevealEntry*/):Void { sendDoOperation('do_all_reveal_state', arguments); }
		public function do_all_shuffle_state(keys:Array/*String*/):Void { sendDoOperation('do_all_shuffle_state', arguments); }
		
		// if user_id=-1, then it is a bug of the game developer
		public function do_all_found_hacker(user_id:Number, error_description:String):Void { sendDoOperation('do_all_found_hacker', arguments); }
		
		// do_all_request_impartial_state is used to do a secret calculation
		// (e.g., the initial board in multiplayer Sudoku or MineSweeper).
		// The server picks several random users, and sends them got_request_impartial_state.
		// All the users must do the exact same calls to do_store_match_state
		public function do_all_request_impartial_state(value:Object/*Serializable*/):Void { sendDoOperation('do_all_request_impartial_state', arguments); }
		public function got_request_impartial_state(secret_seed:Number, value:Object/*Serializable*/):Void {}
		
	}
