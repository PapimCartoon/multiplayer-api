//Do not change the code below because this class is automatically generated!

class ConnectedGameAPI extends BaseGameAPI {
	public function ConnectedGameAPI(parameters:Object) {
		super(parameters);
	}
	public function got_general_info(keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	public function got_user_info(user_id:Number, keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	public function got_my_user_id(my_user_id:Number):Void {}
	public function got_match_started(player_ids:Array/*int[]*/, extra_match_info:Object/*Serializable*/, match_started_time:Number):Void {}
	
	public function do_store_match_state(key:String, value:Object/*Serializable*/):Void { sendDoOperation('do_store_match_state', arguments); }
	public function got_stored_match_state(user_ids:Array/*int[]*/, keys:Array/*String[]*/, values:Array/*Serializable[]*/):Void {}
	
	public function do_connected_set_score(score:Number):Void { sendDoOperation('do_connected_set_score', arguments); }
	public function do_connected_match_over(did_win:Boolean):Void { sendDoOperation('do_connected_match_over', arguments); }
	public function got_match_over(player_ids:Array/*int[]*/):Void {}
	
	
	
}
