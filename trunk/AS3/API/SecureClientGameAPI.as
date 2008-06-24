//Do not change the code below because this class is automatically generated!

package  {
	public  class SecureClientGameAPI extends BaseGameAPI {
		public function SecureClientGameAPI(parameters:Object) {
			super(parameters);
		}
		// For players
		public function got_general_info(keys:Array/*String[]*/, values:Array/*Serializable[]*/):void {}
		public function got_user_info(user_id:int, keys:Array/*String[]*/, values:Array/*Serializable[]*/):void {}
		
		// For players and judges
		// user_id = -1 is for judges
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(user_ids:Array/*int[]*/, extra_match_info:Object/*Serializable*/, match_started_time:int):void {}
		public function got_match_over(user_ids:Array/*int[]*/):void {}
		public function got_start_turn_of(user_id:int):void {}
		public function got_end_turn_of(user_id:int):void {}
		
		public function do_send_message(to_user_ids:Array/*int[]*/, value:Object/*Serializable*/):void { sendDoOperation('do_send_message', arguments); }
		public function got_message(user_id:int, value:Object/*Serializable*/):void {}
		
		public function do_set_timer(key:String, in_seconds:int, pass_back:Object/*Serializable*/):void { sendDoOperation('do_set_timer', arguments); }
		public function got_timer(from_user_id:int, key:String, in_seconds:int, pass_back:Object/*Serializable*/):void {}
		
		// secret_level is either PUBLIC=0, SECRET=1, TOPSECRET=2
		public function do_judge_store_match_state(key:String, value:Object/*Serializable*/, secret_level:int, for_user_id:int):void { sendDoOperation('do_judge_store_match_state', arguments); }
		public function do_player_store_match_state(key:String, value:Object/*Serializable*/, secret_level:int):void { sendDoOperation('do_player_store_match_state', arguments); }
		public function got_secure_stored_match_state(user_ids:Array/*int[]*/, keys:Array/*String[]*/, values:Array/*Serializable[]*/, secret_levels:Array/*int[]*/):void {}
		
		public function do_judge_unfold_top_secret(key:String, to_user_id:int):void { sendDoOperation('do_judge_unfold_top_secret', arguments); }
		public function do_judge_reorder_top_secret(keys:Array/*String[]*/):void { sendDoOperation('do_judge_reorder_top_secret', arguments); }
		
		public function do_judge_set_turn(turn_of_player_id:int):void { sendDoOperation('do_judge_set_turn', arguments); }
		public function do_judge_end_match(finished_player_ids:Array/*int[]*/, scores:Array/*int[]*/, pot_percentages:Array/*int[]*/):void { sendDoOperation('do_judge_end_match', arguments); }
		
		
	}
}
