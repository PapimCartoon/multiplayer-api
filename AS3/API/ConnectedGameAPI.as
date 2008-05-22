package {
	public class ConnectedGameAPI extends BaseGameAPI {
		public function ConnectedGameAPI(parameters:Object):void {
			super(parameters);
		}

		// Got functions. You may override these callbacks.
		public function got_general_info(keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_connected_user_info(keys:Array/*String*/, values:Array/*Object*/):void {}
		public function got_connected_match_started(extra_match_info:Object, match_started_time:int):void {}
		public function got_connected_match_over():void {}
		public function got_connected_stored_match_state(keys:Array/*String*/, values:Array/*Object*/):void {}
		
		// Do functions. You may call these functions.
		public function do_store_match_state(key:String, value:Object):void {
			sendDoOperation("do_store_match_state", arguments);
		}
		public function do_connected_match_over(score:int, did_win:Boolean):void {
			sendDoOperation("do_connected_match_over", arguments);
		}
	}
}