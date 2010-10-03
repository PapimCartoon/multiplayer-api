package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;

	public  class OldBoardGameAPI extends BaseGameAPI {
		public function OldBoardGameAPI(someMovieClip:DisplayObjectContainer) {
			super(someMovieClip);
		}
		public function doRegisterOnServer():void { sendMessage( API_DoRegisterOnServer.create() ); }
		public function doTrace(name:String, message:Object):void { sendMessage( API_DoTrace.create(name, message) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):void {}
		public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {}
		
		// IMPORTANT: all the functions that are specific to OldBoard must start with do_ or got_ (the UNDERSCORE is critical!)
		public function do_graphic_command_without_enum(movie_id:int, func_name:String, func_args:Array/*Object*/):void { sendMessage( API_Do_graphic_command_without_enum.create(movie_id, func_name, func_args) ); }
		public function got_graphic_command(new_movie_parents:Array/*int*/, new_movie_name_ids:Array/*int*/, graphic_commands:Array/*Object*/):void {}
		// Got_save_graphic_command is longer used (after we moved from LocalConnection to AS3)
		public function got_save_graphic_command(arr:Array/*int*/, pos:int):void {}
		public function got_old_move_turn_of(is_white:Boolean):void {}
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function got_no_available_moves(is_white:Boolean):void {}
		
		public function got_score(white_score:int, black_score:int):void {}
		public function got_move_number(current_move_num:int, total_moves_num:int):void {}
		public function got_can_cancel_move(is_enabled:Boolean):void {}
		public function do_cancel():void { sendMessage( API_Do_cancel.create() ); }
		public function got_can_roll_dice(is_enabled:Boolean):void {}
		public function do_roll_dice():void { sendMessage( API_Do_roll_dice.create() ); }
		public function do_automatic_roll(is_automatic:Boolean):void { sendMessage( API_Do_automatic_roll.create(is_automatic) ); }
		public function do_chess_3D_or_2D(is_3D:Boolean):void { sendMessage( API_Do_chess_3D_or_2D.create(is_3D) ); }

// This is a AUTOMATICALLY GENERATED! Do not change!

		// one_click_move is for backgammon (so one click moves with the bigger dice
		//do_enable_one_click_move(with_one_click_move:boolean)
		public function do_make_move_animations(with_animation:Boolean):void { sendMessage( API_Do_make_move_animations.create(with_animation) ); }
		public function do_make_dice_animations(with_animation:Boolean):void { sendMessage( API_Do_make_dice_animations.create(with_animation) ); }
		public function do_make_animations_on_forward(with_animation:Boolean):void { sendMessage( API_Do_make_animations_on_forward.create(with_animation) ); }
		
		
		
		// potPercentage==-1 means to return the stakes
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		// Seeing historical data:
		// Back - a player/viewer that goes several moves back in time
		//		The container will pass CONTAINER_isBack=true,
		//		and it will ignore any operation sent by the game.
		// View - viewing an ongoing game (the viewer doesn't see secret state)
		//		The container will pass CONTAINER_myUserId that is not a playerId.
		// Review - viewing a game that ended (the reviewer sees all the secret state)
		//		The container will pass CONTAINER_myUserId=REVIEW_USER_ID.
		

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
