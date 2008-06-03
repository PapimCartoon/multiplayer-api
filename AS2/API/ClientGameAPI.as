
	class ClientGameAPI extends BaseGameAPI
	{
		public function ClientGameAPI(parameters:Object) {
			super(parameters);
		}

		// Got functions. You may override these callbacks.
		public function got_general_info(keys:Array/*String*/, values:Array/*Object*/):Void {}
		public function got_user_info(user_id:Number, keys:Array/*String*/, values:Array/*Object*/):Void {}
		public function got_my_user_id(my_user_id:Number):Void {}
		public function got_match_started(user_ids:Array/*Number*/, extra_match_info:Object, match_started_time:Number):Void {}
		public function got_match_over(user_ids:Array/*Number*/):Void {}
		public function got_start_turn_of(user_id:Number):Void {}
		public function got_end_turn_of(user_id:Number):Void {}
		public function got_stored_match_state(user_ids:Array/*Number*/, keys:Array/*String*/, values:Array/*Object*/):Void {}
		public function got_message(user_id:Number, value:Object):Void {}
		public function got_timer(from_user_id:Number, key:String, pass_back:Object):Void {}

		// Do functions. You may call these functions.
		public function do_agree_on_match_over(user_ids:Array/*Number*/, scores:Array/*Number*/, pot_percentages:Array/*Number*/):Void {
			sendDoOperation("do_agree_on_match_over", arguments);
		}
		public function do_start_my_turn():Void {
			sendDoOperation("do_start_my_turn", arguments);
		}
		public function do_end_my_turn(next_turn_of_player_ids:Array/*Number*/):Void {
			sendDoOperation("do_end_my_turn", arguments);
		}
		public function do_client_protocol_error_with_description(error_description:String):Void {			
			sendDoOperation("do_client_protocol_error_with_description", arguments);
		}
		public function do_store_match_state(key:String, value:Object):Void {
			sendDoOperation("do_store_match_state", arguments);
		}
		public function do_send_message(to_user_ids:Array/*Number*/, value:Object):Void {
			sendDoOperation("do_send_message", arguments);
		}
		public function do_set_timer(key:String, in_seconds:Number, pass_back:Object):Void {
			sendDoOperation("do_set_timer", arguments);
		}
	}