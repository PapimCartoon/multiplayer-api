//Do not change the code below because this class is automatically generated!

class ClientGameAPI extends BaseGameAPI {
	public function ClientGameAPI(parameters:Object) {
		super(parameters);
	}
	public function got_general_info(keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	public function got_user_info(user_id:Number, keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	public function got_my_user_id(my_user_id:Number):Void {}
	public function got_match_started(user_ids:Array/*int[]*/, extra_match_info:Object/*Serializable*/, match_started_time:Number):Void {}
	
	public function do_agree_on_match_over(user_ids:Array/*int[]*/, scores:Array/*int[]*/, pot_percentages:Array/*int[]*/):Void { sendDoOperation('do_agree_on_match_over', arguments); }
	public function got_match_over(user_ids:Array/*int[]*/):Void {}
	
	public function do_start_my_turn():Void { sendDoOperation('do_start_my_turn', arguments); }
	public function got_start_turn_of(user_id:Number):Void {}
	public function do_end_my_turn(next_turn_of_player_ids:Array/*int[]*/):Void { sendDoOperation('do_end_my_turn', arguments); }
	public function got_end_turn_of(user_id:Number):Void {}
	
	public function do_store_match_state(key:String, value:Object/*Serializable*/):Void { sendDoOperation('do_store_match_state', arguments); }
	public function got_stored_match_state(user_ids:Array/*int[]*/, keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	
	public function do_send_message(to_user_ids:Array/*int[]*/, value:Object/*Serializable*/):Void { sendDoOperation('do_send_message', arguments); }
	public function got_message(user_id:Number, value:Object/*Serializable*/):Void {}
	
	public function do_set_timer(key:String, in_seconds:Number, pass_back:Object/*Serializable*/):Void { sendDoOperation('do_set_timer', arguments); }
	public function got_timer(from_user_id:Number, key:String, in_seconds:Number, pass_back:Object/*Serializable*/):Void {}
	
	public function do_client_protocol_error_with_description(error_description:String):Void { sendDoOperation('do_client_protocol_error_with_description', arguments); }
	
	
	
}
