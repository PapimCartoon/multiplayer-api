//Do not change the code below because this class was generated automatically!

import come2play_as2.api.*;
	class come2play_as2.api.ClientGameAPI extends BaseGameAPI {
		public function ClientGameAPI(parameters:Object) {
			super(parameters);
		}
		public function got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void {}
		public function got_general_info(entries:Array/*Entry*/):Void {}
		public function got_user_info(user_id:Number, entries:Array/*Entry*/):Void {}
		public function got_user_disconnected(user_id:Number):Void {}
		public function got_my_user_id(my_user_id:Number):Void {}
		public function got_match_started(player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, match_state:Array/*UserEntry*/):Void {}
		
		public function do_agree_on_match_over(finished_players:Array/*PlayerMatchOver*/):Void { sendDoOperation('do_agree_on_match_over', arguments); }
		public function got_match_over(finished_player_ids:Array/*int*/):Void {}
		
		public function do_start_my_turn():Void { sendDoOperation('do_start_my_turn', arguments); }
		public function got_start_turn_of(user_id:Number):Void {}
		public function do_end_my_turn(next_turn_of_player_ids:Array/*int*/):Void { sendDoOperation('do_end_my_turn', arguments); }
		public function got_end_turn_of(user_id:Number):Void {}
		
		public function do_store_match_state(entry:Entry):Void { sendDoOperation('do_store_match_state', arguments); }
		public function got_stored_match_state(user_entry:UserEntry):Void {}
		
		public function do_send_message(to_user_ids:Array/*int*/, value:Object/*Serializable*/):Void { sendDoOperation('do_send_message', arguments); }
		public function got_message(user_id:Number, value:Object/*Serializable*/):Void {}
		
		public function do_set_timer(in_seconds:Number, entry:Entry):Void { sendDoOperation('do_set_timer', arguments); }
		public function got_timer(in_seconds:Number, user_entry:UserEntry):Void {}
		
		public function do_client_protocol_error_with_description(error_description:String):Void { sendDoOperation('do_client_protocol_error_with_description', arguments); }
		
		
	}
