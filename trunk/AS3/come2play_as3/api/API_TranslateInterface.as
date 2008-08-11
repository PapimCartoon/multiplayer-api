package come2play_as3.api {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public interface API_TranslateInterface  {
		/*public*/ function translate_got_keyboard_event(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Array; /*interface method*/
		/*public*/ function translate_got_general_info(keys:Array/*String*/, values:Array/*Serializable*/):Array; /*interface method*/
		/*public*/ function translate_got_user_info(user_id:int, keys:Array/*String*/, values:Array/*Serializable*/):Array; /*interface method*/
		/*public*/ function translate_got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, user_ids:Array/*int*/, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array; /*interface method*/
		/*public*/ function translate_do_agree_on_match_over(finished_player_ids:Array/*int*/, scores:Array/*int*/, pot_percentages:Array/*int*/):Array; /*interface method*/
		/*public*/ function translate_do_store_match_state(entries:Array/*Entry*/):Array; /*interface method*/
		/*public*/ function translate_got_stored_match_state(user_id:int, keys:Array/*String*/, values:Array/*Serializable*/, secret_levels:Array/*int*/):Array; /*interface method*/
		/*public*/ function translate_do_all_reveal_state(entries:Array/*RevealEntry*/):Array; /*interface method*/
	}
}
