package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_TranslateReturns  {
		public static function returns_got_keyboard_event(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Array { return arguments; }
		public static function returns_got_general_info(entries:Array/*Entry*/):Array { return arguments; }
		public static function returns_got_user_info(user_id:int, entries:Array/*Entry*/):Array { return arguments; }
		public static function returns_got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/):Array { return arguments; }
		public static function returns_do_agree_on_match_over(finished_player_ids:Array/*int*/, scores:Array/*int*/, pot_percentages:Array/*int*/):Array { return arguments; }
		public static function returns_do_store_match_state(keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array { return arguments; }
		public static function returns_got_stored_match_state(user_id:int, entries:Array/*Entry*/):Array { return arguments; }
		public static function returns_do_all_reveal_state(keys:Array/*String*/, user_ids:Array/*int*/):Array { return arguments; }
	}
}
