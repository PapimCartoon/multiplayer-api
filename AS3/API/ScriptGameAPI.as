package {
	public class ScriptGameAPI extends BaseGameAPI
	{
		public function ScriptGameAPI(parameters:Object):void {
			super(parameters);
		}

		// Got functions. You may override these callbacks.
		public function got_general_info(keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_user_info(user_id:int, keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_my_user_id(my_user_id:int):void {}
		public function got_match_started(user_ids:Array/*int*/, extra_match_info:Object, match_started_time:int):void {}
		public function got_match_over(user_ids:Array/*int*/):void {}
		public function got_start_turn_of(user_id:int):void {}
		public function got_end_turn_of(user_id:int):void {}
		public function got_stored_match_state(user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_message(user_id:int, value:Object):void {}
		public function got_timer(from_user_id:int, key:String, pass_back:Object):void {}
		public function got_from_script(type:String, from_player_id:user_id, message:String):void {}
		public function got_error_in_script_output(timed_out_url:Array/*String*/, url:String, url_output:String, url_output_headers:String, error_message:String):void {}

		// Do functions. You may call these functions.
		public function do_send_to_script(message:String):void {
			sendDoOperation("do_send_to_script", arguments);
		}
		public function do_store_match_state(key:String, value:Object):void {
			sendDoOperation("do_store_match_state", arguments);
		}
		public function do_send_message(to_user_ids:Array/*int*/, value:Object):void {
			sendDoOperation("do_send_message", arguments);
		}
		public function do_set_timer(key:String, in_seconds:int, pass_back:Object):void {
			sendDoOperation("do_set_timer", arguments);
		}
	}
}