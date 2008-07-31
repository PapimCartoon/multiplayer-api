package come2play_as3.tictactoe 
{
import come2play_as3.api.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
/**
 * This graphics handles both the insecure ClientAPI
 * as well as the SecureClientAPI, therefore it inherits from 
 * 	CombinedClientAndSecureGameAPI.
 *  
 * See the game rules in TicTacToe_logic.
 * 
 * When a player wins, he gets some of the stakes, and the rest continue playing, 
 * until only a single player remains (and he doesn't get any stakes).
 * The first winner will get 70% of the pot (can be changed using the flashvar "WINNER_PERCENTAGE"),
 * the second one will get 70% of what remained,
 * and so on, until the last winner will get the entire 100% of the remainder.
 * (and the loser gets nothing).
 * 
 * Written by: Yoav Zibin (yoav@zibin.net)
 */
public final class TicTacToe_graphic extends CombinedClientAndSecureGameAPI {
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	private var ROWS:int;
	private var COLS:int;
	private var WIN_LENGTH:int;
	private var PLAYERS_NUM_IN_SINGLE_PLAYER:int;
	private var WINNER_PERCENTAGE:int;
	
	private var graphics:MovieClip;
	private var squares:Array/*TicTacToe_SquareGraphic[]*/;
	private var logic:TicTacToe_logic;
	private var all_player_ids:Array/*int*/;
	private var ongoing_colors:Array/*int*/;
	private var my_user_id:int = -42;
	private var turnOfColor:int; // a number between 0 and all_player_ids.length
	private static const VIEWER:int = -1; 	
	private var myColor:int; // either VIEWER, or a number between 0 and player_ids.length
	private var isSecureAPI:Boolean;
	
	public function TicTacToe_graphic(graphics:MovieClip, ROWS:int, COLS:int) {
		super(graphics);
		this.graphics = graphics;
		this.ROWS = ROWS;
		this.COLS = COLS;
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(graphics);
		isSecureAPI = parameters["apiType"]=="SecureClientGameAPI";
		
		WIN_LENGTH = AS3_vs_AS2.convertToInt(parameters["WIN_LENGTH"]);
		PLAYERS_NUM_IN_SINGLE_PLAYER = AS3_vs_AS2.convertToInt(parameters["PLAYERS_NUM_IN_SINGLE_PLAYER"]);
		WINNER_PERCENTAGE = AS3_vs_AS2.convertToInt(parameters["WINNER_PERCENTAGE"]);
		
		if (WIN_LENGTH==0) WIN_LENGTH = 3; 
		if (PLAYERS_NUM_IN_SINGLE_PLAYER==0) PLAYERS_NUM_IN_SINGLE_PLAYER = 3;
		if (WINNER_PERCENTAGE==0) WINNER_PERCENTAGE = 70; 
		
		
		
		squares = new Array(ROWS);
		for(var row:int=0; row<ROWS; row++) {
			squares[row] = new Array(COLS);
			for(var col:int=0; col<COLS; col++)
				squares[row][col] = new TicTacToe_SquareGraphic(this, AS3_vs_AS2.getMovieChild(graphics,"Square_"+row+"_"+col), row, col);				
		}		
		do_register_on_server();	 
	}
	
	private function assert(val:Boolean, args:Array):void {
		if (!val) BaseGameAPI.throwError("Assertion failed with arguments: "+args.join(" , "));
	}
	public function myTrace(key:String, args:Array):void {
		trace("MyTrace "+key+": "+args.join(" , "));
		do_store_trace(key, args);
	}
	private function isJuror():Boolean {
		return my_user_id==-1;
	}
	private function getColor(player_id:int):int {
		return AS3_vs_AS2.IndexOf(all_player_ids, player_id);
	}
	
	// overriding functions	
	override public function got_keyboard_event(is_key_down:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void {
		if (!is_key_down) return;
		if (!(ROWS==3 && COLS==3)) return;
		var delta:int = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:int =  2-int(delta/3);
			var row:int =  (delta%3);
			dispatchMoveIfLegal(row, col);
		}
	}
	override public function got_my_user_id(my_user_id:int):void {
		this.my_user_id = my_user_id;
	}
	override public function got_general_info(entries:Array/*Entry*/):void {
		for each (var entry:Entry in entries) {
			if (entry.key=="logo_swf_full_url") {
				var logo_swf_full_url:String = entry.value.toString();	
				trace("logo_swf_full_url="+logo_swf_full_url)
				for(var row:int=0; row<ROWS; row++) 
					for(var col:int=0; col<COLS; col++)
						(squares[row][col] as TicTacToe_SquareGraphic).got_logo(logo_swf_full_url);
			}		
		}
	}
	override public function got_match_started(all_player_ids:Array/*int*/, finished_player_ids:Array/*int*/, extra_match_info:Object/*Serializable*/, match_started_time:int, match_state:Array/*UserEntry*/):void {
		this.all_player_ids = all_player_ids;
		assert(all_player_ids.length<=4, ["The graphics of TicTacToe can handle at most 4 players. all_player_ids=", all_player_ids]);
		turnOfColor = 0;
		var index_of_my_user_id:int = AS3_vs_AS2.IndexOf(all_player_ids,my_user_id);
		myColor = index_of_my_user_id==-1 ? VIEWER : 
				index_of_my_user_id;
		var players_num:int = playersNumber();
		ongoing_colors = [];
		for (var color:int=0; color<players_num; color++)
			ongoing_colors.push(color);
		logic = new TicTacToe_logic(ROWS,COLS,WIN_LENGTH, players_num);
		for each (var user_entry:UserEntry in match_state) {
			if (!isSinglePlayer()) turnOfColor = getColor(user_entry.user_id);	// some users may have disconnected in the middle of the game	
			doUserEntry(user_entry, true);	//we should not call do_agree_on_match_over when loading the match	
		}
		if (finished_player_ids.length>0)
			matchOverForPlayers(finished_player_ids);
		
		setOnPress(true);
	}
	override public function got_match_over(finished_player_ids:Array/*int*/):void {
		if (matchOverForPlayers(finished_player_ids))
			setOnPress(true); // need to call it only if the current color was changed
		// if there is one player left (due to other users that disconnected),
		// then I don't end the game because the container will give the user an option
		// to either: win, cancel, or save the game.
	}	
	override public function got_secure_stored_match_state(secret_level:int, user_entry:UserEntry):void {
		assert(secret_level==SecretLevels.PUBLIC, ["All communication in TicTacToe is PUBLIC, secret_level=",secret_level]);
		got_stored_match_state(user_entry);
	}
	override public function got_stored_match_state(user_entry:UserEntry):void {		
		// the moves are done in alternating turns: color 0, then color 1 (in a round robin)
		var user_id:int = user_entry.user_id;
		if (user_id==my_user_id) return; // The player ignores his own got_stored_match_state, because he already updated the logic before he sent it to the server
		var color_of_user:int = getColor(user_id);
		if (color_of_user==-1) return;  // viewers can store match state, so we just ignore whatever a viewer placed in the match state
		if (AS3_vs_AS2.IndexOf(ongoing_colors, color_of_user)==-1) return; // player already disconnected
		// In SinglePlayer: the player already called return before, but a viewer (there can be viewers even for singleplayer games!) still needs to call doUserEntry 
		if (!isSinglePlayer()) 
			assert(turnOfColor==color_of_user, ["Got an entry from player=",user_id," of color=",color_of_user," but expecting one from color=", turnOfColor]);			
		doUserEntry(user_entry, false);
	}
	
	private function matchOverForPlayers(finished_player_ids:Array/*int*/):Boolean {
		if (logic==null) return false; // match already ended
		var colors:Array/*int*/ = [];
		for each (var p_id:int in finished_player_ids) {
			var color_of_p_id:int = getColor(p_id);
			assert(color_of_p_id!=-1, ["Didn't find player_id=",p_id]); 
			colors.push(color_of_p_id);
		}
		return matchOverForColors(colors);
	}
	private function matchOverForColors(colors:Array/*int*/):Boolean {	
		var shouldChange_turnOfColor:Boolean = false;
		for each (var color:int in colors) {		
			var ongoing_index:int = AS3_vs_AS2.IndexOf(ongoing_colors, color);
			if (ongoing_index==-1) continue; // already finished (when the game ends normally, I immediately call matchOverForColors. see makeMove) 
			ongoing_colors.splice(ongoing_index, 1);
			if (color==myColor && !isSinglePlayer()) myColor = VIEWER; // I'm now a viewer
			if (color==turnOfColor) {
				shouldChange_turnOfColor = true;
			}
			myTrace("matchOverForColor",[color, " shouldChange_turnOfColor=",shouldChange_turnOfColor]);	
		}
		if (ongoing_colors.length==0) {
			setOnPress(false); // turns off the squares
			logic = null;
		} else if (shouldChange_turnOfColor) {
			turnOfColor = getNextTurnOfColor();
		}		
		return shouldChange_turnOfColor;
	}
	private function doUserEntry(user_entry:UserEntry, isSavedGame:Boolean):void {
		var data:Array = AS3_vs_AS2.asArray(user_entry.value);
		makeMove(data[0], data[1], isSavedGame);		
	}
	// makeMove updates the logic and the graphics
	private function playersNumber():int {
		return isSinglePlayer() ? PLAYERS_NUM_IN_SINGLE_PLAYER : all_player_ids.length;
	}
	private function isSinglePlayer():Boolean {
		return all_player_ids.length==1;
	}
	private function getNextTurnOfColor():int {
		var next_turn_of_color:int = turnOfColor;
		while (true) {	
			next_turn_of_color++;
			if (next_turn_of_color==playersNumber()) next_turn_of_color = 0;
			if (AS3_vs_AS2.IndexOf(ongoing_colors, next_turn_of_color)!=-1) break;
		}	
		return next_turn_of_color;
	}
	private static function arrayCopy(arr:Array):Array {
		var res:Array = [];
		for each (var x:Object in arr) {
			res.push(x);
		}
		return res;			
	}
	private function makeMove(row:int, col:int, isSavedGame:Boolean):void {
		logic.makeMove(turnOfColor, row, col);
		// update the graphics
		var square:TicTacToe_SquareGraphic = squares[row][col];
		square.setColor(turnOfColor);	
		
		var didWin:Boolean = logic.isWinner(row, col);
		var isBoardFull:Boolean = logic.isBoardFull();
		if (didWin || isBoardFull) {
			//game is over for one player (but the other players, if there are more than 2 remaining players, will continue playing)
			var finished_players:Array/*PlayerMatchOver*/ = [];
			var isGameOver:Boolean = 
				isBoardFull || ongoing_colors.length==2;
			if (isSinglePlayer()) {
				if (isGameOver) 
					finished_players.push(
						new PlayerMatchOver(all_player_ids[0], 0, -1) );				
			} else {
				var score:int;
				var percentage:int;
				if (didWin) {
					//winner is turnOfColor
					score = ongoing_colors.length;					
					if (isBoardFull || ongoing_colors.length==2) {
						percentage = 100; // there won't be any other winners
					} else {
						percentage = WINNER_PERCENTAGE; 
					}
					finished_players.push(
						new PlayerMatchOver(all_player_ids[turnOfColor], score, percentage) );	
					
					if (ongoing_colors.length==2) {
						// last player gets nothing
						var last_color_id:int = ongoing_colors[0]==turnOfColor ? ongoing_colors[1] : ongoing_colors[0];
						var last_player_id:int = all_player_ids[last_color_id];
						score = -1;
						percentage = 0;
						finished_players.push(
							new PlayerMatchOver(last_player_id, score, percentage) );
					}
				}		
				if (isBoardFull) { // Important: it can happen that someone won and the board has just filled up!					
					for each (var ongoing_color:int in ongoing_colors) {
						var ongoing_player_id:int = all_player_ids[ongoing_color];
						if (!PlayerMatchOver.isInArr(finished_players, ongoing_player_id)) {
							if (didWin) {
								// someone just won, and now the board is full. the other players get nothing!
								score = -1;
								percentage = 0;
							} else {
								// the board became full. With two players it means the game was tied/drawed.
								// so the remaining players split the pot between themselves.
								score = 0;
								// We can either say the percentage is:
								//  100/ongoing_colors.length  - divide the remainder evenly
								//  or 
								// 	-1  - return back the stakes (minus what was given to previous winners; the server will divide the left overs evenly among the remaining players.) 
								percentage = -1; 
							}
							finished_players.push(
								new PlayerMatchOver(ongoing_player_id, score, percentage) );
						}
					}
				}	
			}
			
			var finished_colors:Array/*int*/ = 
				isGameOver ? arrayCopy(ongoing_colors) : [turnOfColor];
			if (!isSavedGame && finished_players.length>0) { 
				if (!isSecureAPI) {
					if (myColor!=VIEWER) do_agree_on_match_over(finished_players);
				} else {
					if (isJuror()) do_juror_end_match(finished_players);
				}
			}
			matchOverForColors(finished_colors);	
		} else {
			// game still in progress
			turnOfColor = getNextTurnOfColor();
		}		
		
		if (!isSavedGame) setOnPress(true);
	}
	
	public function dispatchMoveIfLegal(row:int, col:int):void {		
		myTrace("dispatchMoveIfLegal", ["row=",row," col=",col]);
		if (logic==null) return; // game not in progress
		if (myColor==VIEWER) return; // viewer cannot make a move
		if (!isSinglePlayer() && myColor!=turnOfColor) return; // not my turn
		if (!logic.isSquareAvailable(row, col)) return; // already filled this square (e.g., if you press on the keyboard, you may choose a cell that is already full)
		// The order of API calls should be: 
		//  do_store_match_state, 
		//	maybe do_agree_on_match_over or do_juror_end_match
		// 	and finally do_end_my_turn
		// The other players will get the state, and then call: 
		// 	maybe do_agree_on_match_over or do_juror_end_match
		//	and maybe either do_start_my_turn or do_juror_set_turn
		do_store_match_state( new Entry(""+logic.getMoveNumber(), [row, col]) );		
		makeMove(row, col, false);
		// Important: note that do_end_my_turn is called after all other API calls (see its documentation)
		if (logic!=null && !isSinglePlayer() && !isSecureAPI)
			do_end_my_turn([all_player_ids[turnOfColor]]);
	}
	private function setOnPress(isInProgress:Boolean):void {
		//trace("setOnPress with isInProgress="+isInProgress);
		if (logic==null) return; 
						
		if (isInProgress && !isSinglePlayer()) {
			if (!isSecureAPI) {
				if (myColor==turnOfColor) do_start_my_turn();
			} else {
				if (isJuror()) do_juror_set_turn(all_player_ids[turnOfColor]);
			}
		}		
		for(var row:int=0; row<ROWS; row++)
			for(var col:int=0; col<COLS; col++) {
				if (logic.isSquareAvailable(row, col)) {
					var square:TicTacToe_SquareGraphic = squares[row][col];
					square.setOnPress(
						!isInProgress ? TicTacToe_SquareGraphic.BTN_NONE : // the match was over
						myColor==VIEWER ? TicTacToe_SquareGraphic.BTN_NONE : // a viewer never has the turn
						isSinglePlayer() ? turnOfColor : // single player always has the turn
						myColor==turnOfColor ?  
							turnOfColor : // I have the turn
							TicTacToe_SquareGraphic.BTN_NONE); // not my turn		
				}							
			}
	}
}
}
