package come2play_as3.tictactoe 
{
import come2play_as3.api.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
/**
 * The graphics raises the following events:
 * - TraceEvent - when a message should be traced
 * - MatchStateEvent - when a user performs a move that should update the match state
 * - GameOverEvent - when the game is over for some of the players
 * See the game rules in TicTacToe_logic.
 * When a player wins, he gets some of the stakes, and the rest continue playing, 
 * until there is only a single player left (and he doesn't get any stakes).
 * Each winner gets half of what the previous winner got,
 * so if we have 4 players:
 * 1st place gets: 4/7
 * 2nd place gets: 2/7
 * 3rd place gets: 1/7
 * and 4th place gets nothing!
 * Because the percentage are accumilative 
 * (the percentage are from the remainder of what is left in the pot),
 * we should rephrase the above as: 
 * 1st place gets: 4/7
 * 2nd place gets: 2/3 of the remainder (3/7 of the pot)
 * 3rd place gets: the remainder (1/7 of the pot)
 * 4th place gets nothing.
 * If you have 5 players:
 * 1st place gets: 8/15
 * 2nd place gets: 4/7 of the remainder (7/15 of the pot)
 * 3rd place gets: 2/3 of the remainder (3/15 of the pot)
 * 4th place gets: the remainder (1/15 of the pot)
 * 5th place gets nothing.
 * The formula for the I-th place (except last place) out of N players is:
 *  2^(N-I-1) / (2^(N-I) - 1)
 *  
 * Written by: Yoav Zibin (yoav@zibin.net)
 */
public final class TicTacToe_graphic extends EventDispatcher {
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	public var ROWS:int;
	public var COLS:int;
	public var WIN_LENGTH:int;
	public var PLAYERS_NUM_IN_SINGLE_PLAYER:int;
	
	private var graphics:MovieClip;
	private var squares:Array/*SquareGraphic[]*/;
	private var logic:TicTacToe_logic;
	private var all_player_ids:Array/*int*/;
	private var ongoing_colors:Array/*int*/;
	private var my_user_id:int;
	private var turnOfColor:int; // a number between 0 and all_player_ids.length
	public static const VIEWER:int = -1; 	
	private var myColor:int; // either VIEWER, or a number between 0 and player_ids.length
	private var disconnected_num:int;
	
	public function TicTacToe_graphic(graphics:MovieClip, ROWS:int, COLS:int, 
			WIN_LENGTH:int, PLAYERS_NUM_IN_SINGLE_PLAYER:int) {
		this.graphics = graphics;
		this.ROWS = ROWS;
		this.COLS = COLS;
		this.WIN_LENGTH = WIN_LENGTH;
		this.PLAYERS_NUM_IN_SINGLE_PLAYER = PLAYERS_NUM_IN_SINGLE_PLAYER;
		
		squares = new Array(ROWS);
		for(var row:int=0; row<ROWS; row++) {
			squares[row] = new Array(COLS);
			for(var col:int=0; col<COLS; col++)
				squares[row][col] = new SquareGraphic(this, graphics.getChildByName("Square_"+row+"_"+col) as MovieClip, row, col);				
		}
		
		// Important: do not call addKeyboardListener in the constructor,
		//   because "graphics.stage" is still null		 
	}
	
	private function assert(val:Boolean, ...args):void {
		if (!val) throw new Error("Assertion failed with arguments: "+args.join(" , "));
	}
	private function myTrace(key:String, ...args):void {
		trace("MyTrace "+key+": "+args.join(" , "));
		dispatchEvent( new TraceEvent(key, args) );
	}
	private function traceAndDispatch(event:Event):void {
		myTrace("DispatchingEvent", event);
		if (myColor!=VIEWER && (isSinglePlayer() || ongoing_colors.indexOf(myColor)!=-1)) //todo: judges also need to get the events
			dispatchEvent(event);
	}
	
	// Keyboard listener
	private var didAddKeyboardListener:Boolean = false;
	private function addKeyboardListener():void {		
		// Add keyboard listener (only fits if the board is of size 3x3)
		if (!didAddKeyboardListener && ROWS==3 && COLS==3) {
			didAddKeyboardListener = true; 
			graphics.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		}
	}
	private function reportKeyDown(event:KeyboardEvent):void {
		var charCode:int = event.charCode;
		myTrace("KeyboardEvent", "charCode=",charCode);
		var delta:int = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:int =  2-int(delta/3);
			var row:int =  (delta%3);
			dispatchMoveIfLegal(row, col);
		}
	}	
	
	// Public functions
	public function got_match_started(player_ids:Array/*int*/, my_user_id:int, match_state:Array/*UserEntry*/):void {
		this.all_player_ids = player_ids;
		this.my_user_id = my_user_id;
		assert(player_ids.length<=4, "The number of players the graphics of TicTacToe can handle is less or equal to 4");
		turnOfColor = 0;
		var index_of_my_user_id:int = player_ids.indexOf(my_user_id);
		myColor = index_of_my_user_id==-1 ? VIEWER : 
				index_of_my_user_id;
		disconnected_num = 0;
		var players_num:int = playersNumber();
		ongoing_colors = [];
		for (var color:int=0; color<players_num; color++)
			ongoing_colors.push(color);
		logic = new TicTacToe_logic(ROWS,COLS,WIN_LENGTH, players_num);
		addKeyboardListener();		
		for each (var user_entry:UserEntry in match_state) 			
			doUserEntry(user_entry);		
		setOnPress(true);
	}
	private function matchOverForColors(colors:Array/*int*/):void {		
		var shouldChange_turnOfColor:Boolean = false;
		for each (var color:int in colors) {		
			var ongoing_index:int = ongoing_colors.indexOf(color);
			if (ongoing_index==-1) continue; // already disconnected
			ongoing_colors.splice(ongoing_index, 1);
			if (color==turnOfColor) {
				shouldChange_turnOfColor = true;
			}
		}
		if (ongoing_colors.length==0) {
			setOnPress(false); // turns off the squares
			logic = null;
		} else if (shouldChange_turnOfColor) {
			update_turnOfColor();
			setOnPress(true);
		}		
	}
	public function got_match_over(finished_player_ids:Array/*int*/):void {
		if (logic==null) return; // match already ended
		var colors:Array/*int*/ = [];
		for each (var p_id:int in finished_player_ids) {
			var color_of_p_id:int = all_player_ids.indexOf(p_id);
			if (color_of_p_id==-1) continue; // a viewer disconnected
			colors.push(color_of_p_id);
		}
		disconnected_num += colors.length;
		matchOverForColors(colors);
		// if there is one player left (due to other users that disconnected),
		// then I don't end the game because the container will give the user an option
		// to either: win, cancel, or save the game.
	}
	// got_stored_match_state updates the match state
	// Each data in datas is an Array with [row, column]
	public function got_stored_match_state(user_entry:UserEntry):void {		
		// the moves are done in alternating turns: color 0, then color 1 (in a round robin)
		if (user_entry.user_id==my_user_id) return; // The player ignores his own got_stored_match_state, because he already updated the logic before he sent it to the server	
		doUserEntry(user_entry);
		setOnPress(true);
	}
	private function doUserEntry(user_entry:UserEntry):void {
		var user_id:int = user_entry.user_id;
		var color_of_user:int = all_player_ids.indexOf(user_id);
		if (color_of_user==-1) return;  // viewers can store match state, so we just ignore whatever a viewer placed in the match state
		if (ongoing_colors.indexOf(color_of_user)==-1) return; // player already disconnected
		// in SinglePlayer, the single player plays all turns.
		var expected_player_id:int = all_player_ids[isSinglePlayer() ? 0 : turnOfColor];
		assert(expected_player_id==user_id, "Got an entry from player=",user_id," but expecting one from player=", expected_player_id);
		var data:Array = user_entry.value as Array;
		makeMove(data[0], data[1]);		
	}
	// makeMove updates the logic and the graphics
	private function playersNumber():int {
		return isSinglePlayer() ? PLAYERS_NUM_IN_SINGLE_PLAYER : all_player_ids.length;
	}
	private function isSinglePlayer():Boolean {
		return all_player_ids.length==1;
	}
	private function update_turnOfColor():void {	
		while (true) {	
			turnOfColor++;
			if (turnOfColor==playersNumber()) turnOfColor = 0;
			if (ongoing_colors.indexOf(turnOfColor)!=-1) break;
		}		
	}
	public static function arrayCopy(arr:Array):Array {
		var res:Array = [];
		for each (var x:Object in arr) res.push(x);
		return res;			
	}
	public function makeMove(row:int, col:int):void {
		var didWin:Boolean = logic.makeMove(turnOfColor, row, col);
		var isBoardFull:Boolean = logic.isBoardFull();
		// update the graphics
		var square:SquareGraphic = squares[row][col];
		square.setColor(turnOfColor);
		if (!didWin && !isBoardFull) {
			update_turnOfColor();		
		} else {
			//game is over
			var finished_players:Array/*PlayerMatchOver*/ = [];
			trace("ongoing_colors.length="+ongoing_colors.length);
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
					//2^(N-I) / (2^(N-I-1) - 1)
					//winner is turnOfColor
					score = ongoing_colors.length-disconnected_num;					
					if (isBoardFull) {
						percentage = 100; // there won't be any other winners
					} else {
						// 1<<5 = 32
						var frac_top:int = 1 << (2*(playersNumber() - disconnected_num) - ongoing_colors.length - 2);
						var frac_bottom:int = frac_top*2 - 1;
						percentage = 100*Number(frac_top)/Number(frac_bottom);
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
								score = -1;
								percentage = 0;
							} else {
								score = 0;
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
			if (finished_players.length>0) 
				traceAndDispatch( new GameOverEvent(finished_players) );
			matchOverForColors(finished_colors);	
		}
	}
	
	public function dispatchMoveIfLegal(row:int, col:int):void {		
		myTrace("dispatchMoveIfLegal", "row=",row," col=",col);
		if (logic==null) return; // game not in progress
		if (myColor==VIEWER) return; // viewer cannot make a move
		if (!isSinglePlayer() && myColor!=turnOfColor) return; // not my turn
		if (!logic.isSquareAvailable(row, col)) return;
		dispatchEvent( new MatchStateEvent( new Entry(""+logic.getMoveNumber(), [row, col]) ) );
		makeMove(row, col);
		setOnPress(true);
	}
	private function setOnPress(isInProgress:Boolean):void {
		//trace("setOnPress with isInProgress="+isInProgress);
		if (logic==null) return; 
		if (isInProgress && !isSinglePlayer()) 
			traceAndDispatch( new TurnChangedEvent(all_player_ids[turnOfColor]) );		
		for(var row:int=0; row<ROWS; row++)
			for(var col:int=0; col<COLS; col++) {
				if (logic.isSquareAvailable(row, col)) {
					var square:SquareGraphic = squares[row][col];
					square.setOnPress(
						!isInProgress ? SquareGraphic.BTN_NONE : // the match was over
						myColor==VIEWER ? SquareGraphic.BTN_NONE : // a viewer never has the turn
						isSinglePlayer() ? turnOfColor : // single player always has the turn
						myColor==turnOfColor ?  
							turnOfColor : // I have the turn
							SquareGraphic.BTN_NONE); // not my turn		
				}							
			}
	}
}
}
import flash.display.MovieClip;
import flash.events.MouseEvent;
import come2play_as3.tictactoe.*;
	
class SquareGraphic {
	public static const BTN_NONE:int = -2; 	
	
	private var graphic:TicTacToe_graphic;
	private var square:MovieClip;
	private var btn:MovieClip;
	private var row:int;
	private var col:int;
	public function SquareGraphic(graphic:TicTacToe_graphic, square:MovieClip, row:int, col:int) {
		this.graphic = graphic;
		this.square = square;
		this.btn = square.getChildByName("Btn_X_O") as MovieClip;
		this.row = row;
		this.col = col;
	}
	public function setColor(color:int):void {
		square.gotoAndStop("Color_"+color);
		btn.gotoAndStop("Btn_None");
	}
	public function setOnPress(currentTurn:int):void {
		//trace("Changing square "+row+"x"+col+" to "+currentTurn);
		square.gotoAndStop("None");
		btn.gotoAndStop(currentTurn==BTN_NONE ? "Btn_None" : 
						"Btn_"+currentTurn);
		if (currentTurn!=BTN_NONE) {
			if (currentTurn<0) throw Error("Internal error!");
			btn.addEventListener(MouseEvent.CLICK, pressedOn);
		}
	}
	private function pressedOn(evt:MouseEvent):void  {
		btn.removeEventListener(MouseEvent.CLICK, pressedOn); //todo: is it needed?
		graphic.dispatchMoveIfLegal(row, col);		
	}
}