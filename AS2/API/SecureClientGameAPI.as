//Do not change the code below because this class is automatically generated!

class SecureClientGameAPI extends BaseGameAPI {
	public function SecureClientGameAPI(parameters:Object) {
		super(parameters);
	}
	// For players
	public function got_general_info(keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	public function got_user_info(user_id:Number, keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	
	// For players and judges
	// user_id = -1 is for judges
	public function got_my_user_id(my_user_id:Number):Void {}
	public function got_match_started(player_ids:Array/*int[]*/, extra_match_info:Object/*Serializable*/, match_started_time:Number):Void {}
	public function got_match_over(player_ids:Array/*int[]*/):Void {}
	public function got_start_turn_of(user_id:Number):Void {}
	public function got_end_turn_of(user_id:Number):Void {}
	
	public function do_send_message(to_user_ids:Array/*int[]*/, value:Object/*Serializable*/):Void { sendDoOperation('do_send_message', arguments); }
	public function got_message(user_id:Number, value:Object/*Serializable*/):Void {}
	
	public function do_set_timer(key:String, in_seconds:Number, pass_back:Object/*Serializable*/):Void { sendDoOperation('do_set_timer', arguments); }
	public function got_timer(from_user_id:Number, key:String, in_seconds:Number, pass_back:Object/*Serializable*/):Void {}
	
	// secret_level is either PUBLIC=0, SECRET=1, TOPSECRET=2
	public function do_judge_store_match_state(key:String, value:Object/*Serializable*/, secret_level:Number, for_user_id:Number):Void { sendDoOperation('do_judge_store_match_state', arguments); }
	public function do_player_store_match_state(key:String, value:Object/*Serializable*/, secret_level:Number):Void { sendDoOperation('do_player_store_match_state', arguments); }
	public function got_secure_stored_match_state(user_ids:Array/*int[]*/, keys:Array/*String[]*/, values:Array/*Serializable[]*/, secret_levels:Array/*int[]*/):Void {}
	
	public function do_judge_unfold_top_secret(key:String, to_user_id:Number):Void { sendDoOperation('do_judge_unfold_top_secret', arguments); }
	public function do_judge_reorder_top_secret(keys:Array/*String[]*/):Void { sendDoOperation('do_judge_reorder_top_secret', arguments); }
	
	public function do_judge_set_turn(turn_of_player_id:Number):Void { sendDoOperation('do_judge_set_turn', arguments); }
	public function do_judge_end_match(finished_player_ids:Array/*int[]*/, scores:Array/*int[]*/, pot_percentages:Array/*int[]*/):Void { sendDoOperation('do_judge_end_match', arguments); }
	
	
}
