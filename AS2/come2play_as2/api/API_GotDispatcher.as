//Do not change the code below because this class was generated automatically!

import come2play_as2.api.*;
	class come2play_as2.api.API_GotDispatcher  {
		private var func:Function;
		public function API_GotDispatcher(func:Function) { this.func = func; }
		
		public function API_got_graphic_command(new_movie_parents:Array/*int*/, new_movie_name_ids:Array/*int*/, graphic_commands:Array/*Serializable*/):Void { func('got_graphic_command',arguments); }
		public function API_got_save_graphic_command(arr:Array/*int*/, pos:Number):Void { func('got_save_graphic_command',arguments); }
		public function API_got_old_move_turn_of(is_white:Boolean):Void { func('got_old_move_turn_of',arguments); }
		public function API_got_match_over_waiting_others(white_score:Number, black_score:Number):Void { func('got_match_over_waiting_others',arguments); }
		public function API_got_no_available_moves(is_white:Boolean):Void { func('got_no_available_moves',arguments); }
		public function API_got_score(white_score:Number, black_score:Number):Void { func('got_score',arguments); }
		public function API_got_move_number(current_move_num:Number, total_moves_num:Number):Void { func('got_move_number',arguments); }
		public function API_got_can_cancel_move(is_enabled:Boolean):Void { func('got_can_cancel_move',arguments); }
		public function API_got_can_roll_dice(is_enabled:Boolean):Void { func('got_can_roll_dice',arguments); }
		public function API_got_keyboard_event(is_key_down:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void { func('got_keyboard_event',arguments); }
		public function API_got_general_info(keys:Array/*String*/, values:Array/*Serializable*/):Void { func('got_general_info',arguments); }
		public function API_got_user_info(user_id:Number, keys:Array/*String*/, values:Array/*Serializable*/):Void { func('got_user_info',arguments); }
		public function API_got_user_disconnected(user_id:Number):Void { func('got_user_disconnected',arguments); }
		public function API_got_my_user_id(my_user_id:Number):Void { func('got_my_user_id',arguments); }
		public function API_got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:Number, user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Void { func('got_match_started',arguments); }
		public function API_got_match_over(finished_player_ids:Array/*int*/):Void { func('got_match_over',arguments); }
		public function API_got_start_turn_of(user_id:Number):Void { func('got_start_turn_of',arguments); }
		public function API_got_end_turn_of(user_id:Number):Void { func('got_end_turn_of',arguments); }
		public function API_got_stored_match_state(user_id:Number, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Void { func('got_stored_match_state',arguments); }
	}
