import come2play_as2.api.*;
import come2play_as2.util.*;

/**
 * We handle both the insecure ClientAPI
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
import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TicTacToe_Main extends ClientGameAPI {
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	private var ROWS:Number;
	private var COLS:Number;
	private var WIN_LENGTH:Number;
	private var PLAYERS_NUM_IN_SINGLE_PLAYER:Number;
	private var WINNER_PERCENTAGE:Number;
	
	private var graphics:MovieClip;
	private var squares:Array/*TicTacToe_SquareGraphic[]*/;
	private var logic:TicTacToe_logic;
	private var allPlayerIds:Array/*int*/;
	private var ongoingColors:Array/*int*/;
	private var myUserId:Number = -42;
	private var turnOfColor:Number; // a number between 0 and allPlayerIds.length
	private static var VIEWER:Number = -1; 	
	private var myColor:Number; // either VIEWER, or a number between 0 and allPlayerIds.length
	
	public function TicTacToe_Main(graphics:MovieClip) {
		super(graphics);
		var grid:CreateGrid = new CreateGrid(graphics,3,3,100);		
		graphics.stop();
		this.graphics = graphics;
		this.ROWS = grid.ROWS;
		this.COLS = grid.COLS;
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(graphics);
		
		WIN_LENGTH = AS3_vs_AS2.convertToInt(parameters["WIN_LENGTH"]);
		PLAYERS_NUM_IN_SINGLE_PLAYER = AS3_vs_AS2.convertToInt(parameters["PLAYERS_NUM_IN_SINGLE_PLAYER"]);
		WINNER_PERCENTAGE = AS3_vs_AS2.convertToInt(parameters["WINNER_PERCENTAGE"]);
		
		if (WIN_LENGTH==0) WIN_LENGTH = 3; 
		if (PLAYERS_NUM_IN_SINGLE_PLAYER==0) PLAYERS_NUM_IN_SINGLE_PLAYER = 3;
		if (WINNER_PERCENTAGE==0) WINNER_PERCENTAGE = 70; 
		
		
		
		squares = new Array(ROWS);
		for(var row:Number=0; row<ROWS; row++) {
			squares[row] = new Array(COLS);
			for(var col:Number=0; col<COLS; col++)
				squares[row][col] = new TicTacToe_SquareGraphic(this, AS3_vs_AS2.getMovieChild(graphics,"Square_"+row+"_"+col), row, col);				
		}		
		doRegisterOnServer();	 
	}
	
	private function getColor(playerId:Number):Number {
		return AS3_vs_AS2.IndexOf(allPlayerIds, playerId);
	}
	
	// overriding functions	
	/*override*/ public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void { 
		if (!isKeyDown) return;
		if (!(ROWS==3 && COLS==3)) return;
		var delta:Number = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:Number =  2-int(delta/3);
			var row:Number =  (delta%3);
			dispatchMoveIfLegal(row, col);
		}
	}
	/*override*/ public function gotMyUserId(myUserId:Number):Void {
		this.myUserId = myUserId;
	}
	
	/*override*/ public function gotCustomInfo(entries:Array/*Entry*/):Void {
		for (var i90:Number=0; i90<entries.length; i90++) { var entry:Entry = entries[i90]; 
			if (entry.key==API_Message.CUSTOM_INFO_KEY_logo_swf_full_url) {
				var logo_swf_full_url:String = entry.value.toString();	
				trace("Got logo_swf_full_url="+logo_swf_full_url)
				for(var row:Number=0; row<ROWS; row++) 
					for(var col:Number=0; col<COLS; col++)
						(squares[row][col] /*as TicTacToe_SquareGraphic*/).gotLogo(logo_swf_full_url);
			}		
		}
	}
	/*override*/ public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:Number, userStateEntries:Array/*UserStateEntry*/):Void {
		this.allPlayerIds = allPlayerIds;
		assert(allPlayerIds.length<=4, ["The graphics of TicTacToe can handle at most 4 players. allPlayerIds=", allPlayerIds]);
		turnOfColor = 0;
		var indexOfMyUserId:Number = AS3_vs_AS2.IndexOf(allPlayerIds,myUserId);
		myColor = indexOfMyUserId==-1 ? VIEWER : 
				indexOfMyUserId;
		var playersNum:Number = playersNumber();
		ongoingColors = [];
		for (var color:Number=0; color<playersNum; color++)
			ongoingColors.push(color);
		logic = new TicTacToe_logic(ROWS,COLS,WIN_LENGTH, playersNum);
		for (var i112:Number=0; i112<userStateEntries.length; i112++) { var userStateEntry:UserStateEntry = userStateEntries[i112]; 
			if (!isSinglePlayer()) turnOfColor = getColor(userStateEntry.userId);	// some users may have disconnected in the middle of the game	
			doEntry(userStateEntry.value, true);	//we should not call doAllEndMatch when loading the match	
		}
		if (finishedPlayerIds.length>0)
			matchOverForPlayers(finishedPlayerIds);
		
		setOnPress(true);
	}
	/*override*/ public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {
		if (matchOverForPlayers(finishedPlayerIds))
			setOnPress(true); // need to call it only if the current color was changed
		// if there is one player left (due to other users that disconnected),
		// then I don't end the game because the container will give the user an option
		// to either: win, cancel, or save the game.
	}	
	/*override*/ public function gotStoredState(userId:Number, stateEntries:Array/*StateEntry*/):Void {
		// the moves are done in alternating turns: color 0, then color 1 (in a round robin)	
		assert(stateEntries.length==1, ["there is one entry per move in TicTacToe"]);	
		var entry:StateEntry = stateEntries[0];
		assert(!entry.isSecret, ["All communication in TicTacToe is PUBLIC"]);
		if (userId==myUserId) return; // The player ignores his own stores, because he already updated the logic before he sent it to the server
		var colorOfUser:Number = getColor(userId);
		if (colorOfUser==-1) return;  // viewers can store match state, so we just ignore whatever a viewer placed in the match state
		if (AS3_vs_AS2.IndexOf(ongoingColors, colorOfUser)==-1) return; // player already disconnected
		// In SinglePlayer: the player already called return before, but a viewer (there can be viewers even for singleplayer games!) still needs to call doEntry 
		if (!isSinglePlayer()) 
			assert(turnOfColor==colorOfUser, ["Got an entry from player=",userId," of color=",colorOfUser," but expecting one from color=", turnOfColor]);
		var expectedKey:String = getStateKey();
		assert(entry.key==expectedKey, ["The state key is illegal! Expecting key=",expectedKey," but got key=",entry.key]);
		doEntry(entry.value, false);
	}
	
	private function matchOverForPlayers(finishedPlayerIds:Array/*int*/):Boolean {
		if (logic==null) return false; // match already ended
		var colors:Array/*int*/ = [];
		for (var i148:Number=0; i148<finishedPlayerIds.length; i148++) { var playerId:Number = finishedPlayerIds[i148]; 
			var colorOfPlayerId:Number = getColor(playerId);
			assert(colorOfPlayerId!=-1, ["Didn't find playerId=",playerId]); 
			colors.push(colorOfPlayerId);
		}
		return matchOverForColors(colors);
	}
	private function matchOverForColors(colors:Array/*int*/):Boolean {	
		var shouldChangeTurnOfColor:Boolean = false;
		for (var i157:Number=0; i157<colors.length; i157++) { var color:Number = colors[i157]; 
			var ongoingIndex:Number = AS3_vs_AS2.IndexOf(ongoingColors, color);
			if (ongoingIndex==-1) continue; // already finished (when the game ends normally, I immediately call matchOverForColors. see makeMove) 
			ongoingColors.splice(ongoingIndex, 1);
			if (color==myColor && !isSinglePlayer()) myColor = VIEWER; // I'm now a viewer
			if (color==turnOfColor) {
				shouldChangeTurnOfColor = true;
			}
			doTrace("matchOverForColor",[color, " shouldChangeTurnOfColor=",shouldChangeTurnOfColor]);	
		}
		if (ongoingColors.length==0) {
			setOnPress(false); // turns off the squares
			logic = null;
		} else if (shouldChangeTurnOfColor) {
			turnOfColor = getNextTurnOfColor();
		}		
		return shouldChangeTurnOfColor;
	}
	private function doEntry(value:Object, isSavedGame:Boolean):Void {
		var data:Array = AS3_vs_AS2.asArray(value);
		makeMove(data[0], data[1], isSavedGame);		
	}
	// makeMove updates the logic and the graphics
	private function playersNumber():Number {
		return isSinglePlayer() ? PLAYERS_NUM_IN_SINGLE_PLAYER : allPlayerIds.length;
	}
	private function isSinglePlayer():Boolean {
		return allPlayerIds.length==1;
	}
	private function getNextTurnOfColor():Number {
		var nextTurnOfColor:Number = turnOfColor;
		while (true) {	
			nextTurnOfColor++;
			if (nextTurnOfColor==playersNumber()) nextTurnOfColor = 0;
			if (AS3_vs_AS2.IndexOf(ongoingColors, nextTurnOfColor)!=-1) break;
		}	
		return nextTurnOfColor;
	}
	private static function arrayCopy(arr:Array):Array {
		var res:Array = [];
		for (var i197:Number=0; i197<arr.length; i197++) { var x:Object = arr[i197]; 
			res.push(x);
		}
		return res;			
	}
	private function makeMove(row:Number, col:Number, isSavedGame:Boolean):Void {
		logic.makeMove(turnOfColor, row, col);
		// update the graphics
		var square:TicTacToe_SquareGraphic = squares[row][col];
		square.setColor(turnOfColor);	
		
		var didWin:Boolean = logic.isWinner(row, col);
		var isBoardFull:Boolean = logic.isBoardFull();
		if (didWin || isBoardFull) {
			//game is over for one player (but the other players, if there are more than 2 remaining players, will continue playing)
			var finishedPlayers:Array/*PlayerMatchOver*/ = [];
			var isGameOver:Boolean = 
				isBoardFull || ongoingColors.length==2;
			if (isSinglePlayer()) {
				if (isGameOver) 
					finishedPlayers.push(
						new PlayerMatchOver(allPlayerIds[0], 0, -1) );				
			} else {
				var score:Number;
				var percentage:Number;
				if (didWin) {
					//winner is turnOfColor
					score = ongoingColors.length;					
					if (isBoardFull || ongoingColors.length==2) {
						percentage = 100; // there won't be any other winners
					} else {
						percentage = WINNER_PERCENTAGE; 
					}
					var winnerId:Number = allPlayerIds[turnOfColor];
					finishedPlayers.push(
						new PlayerMatchOver(winnerId, score, percentage) );	
					
					if (ongoingColors.length==2) {
						// last player gets nothing
						var loserColorId:Number = ongoingColors[0]==turnOfColor ? ongoingColors[1] : ongoingColors[0];
						var loserPlayerId:Number = allPlayerIds[loserColorId];
						score = -1;
						percentage = 0;
						finishedPlayers.push(
							new PlayerMatchOver(loserPlayerId, score, percentage) );
					}
				}		
				if (isBoardFull) { // Important: it can happen that someone won and the board has just filled up!				
					var finishedPlayersIds:Array/*int*/ = [];
					for (var i246:Number=0; i246<finishedPlayers.length; i246++) { var playerMatchOver:PlayerMatchOver = finishedPlayers[i246]; 
						finishedPlayersIds.push(playerMatchOver.playerId);
					}					
					for (var i249:Number=0; i249<ongoingColors.length; i249++) { var ongoingColor:Number = ongoingColors[i249]; 
						var ongoingPlayerId:Number = allPlayerIds[ongoingColor];
						if (AS3_vs_AS2.IndexOf(finishedPlayersIds, ongoingPlayerId)==-1) {
							if (didWin) {
								// someone just won, and now the board is full. the other players get nothing!
								score = -1;
								percentage = 0;
							} else {
								// the board became full. With two players it means the game was tied/drawed.
								// so the remaining players split the pot between themselves.
								score = 0;
								// We can either say the percentage is:
								//  100/ongoingColors.length  - divide the remainder evenly
								//  or 
								// 	-1  - return back the stakes (minus what was given to previous winners; the server will divide the left overs evenly among the remaining players.) 
								percentage = -1; 
							}
							finishedPlayers.push(
								new PlayerMatchOver(ongoingPlayerId, score, percentage) );
						}
					}
				}	
			}
			
			var finishedColors:Array/*int*/ = 
				isGameOver ? arrayCopy(ongoingColors) : [turnOfColor];
			if (!isSavedGame && finishedPlayers.length>0) { 
				doAllEndMatch(finishedPlayers);				
			}
			matchOverForColors(finishedColors);	
		} else {
			// game still in progress
			turnOfColor = getNextTurnOfColor();
		}		
		
		if (!isSavedGame) setOnPress(true);
	}
	private function getStateKey():String {
		return ""+logic.getMoveNumber();
	}
	public function dispatchMoveIfLegal(row:Number, col:Number):Void {		
		doTrace("dispatchMoveIfLegal", ["row=",row," col=",col]);
		if (logic==null) return; // game not in progress
		if (myColor==VIEWER) return; // viewer cannot make a move
		if (!isSinglePlayer() && myColor!=turnOfColor) return; // not my turn
		if (!logic.isSquareAvailable(row, col)) return; // already filled this square (e.g., if you press on the keyboard, you may choose a cell that is already full)
		doStoreState( [new StateEntry(getStateKey(), [row, col], false)] );		
		makeMove(row, col, false);		
	}
	private function setOnPress(isInProgress:Boolean):Void {
		//trace("setOnPress with isInProgress="+isInProgress);
		if (logic==null) return; 
						
		if (isInProgress && !isSinglePlayer()) {
			doAllSetTurn(allPlayerIds[turnOfColor],-1);
		}		
		for(var row:Number=0; row<ROWS; row++)
			for(var col:Number=0; col<COLS; col++) {
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
