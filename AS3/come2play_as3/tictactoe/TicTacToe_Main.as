package come2play_as3.tictactoe 
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
/**
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
public final class TicTacToe_Main extends ClientGameAPI {
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	private var grid:CreateGrid;
	private var ROWS:int;
	private var COLS:int;
	private var WIN_LENGTH:int;
	private var PLAYERS_NUM_IN_SINGLE_PLAYER:int;
	private var WINNER_PERCENTAGE:int;
	
	private var graphics:MovieClip;
	private var allCells:Array/*TicTacToeMove*/;
	private var squares:Array/*TicTacToe_SquareGraphic[]*/;
	private var logic:TicTacToe_logic;
	private var allPlayerIds:Array/*int*/; // never changes since starting the game
	private var ongoingColors:Array/*int*/; // when a player finishes (wins/disconnects) we remove him from ongoingColors 
	private var myUserId:int = -42;
	private var turnOfColor:int; // a number between 0 and allPlayerIds.length
	private static const VIEWER:int = -1; 	
	private var myColor:int; // either VIEWER, or a number between 0 and allPlayerIds.length
	
	// We may use the player's avatars instead of the default symbols (of "X" and "O")
	private var shouldUseAvatars:Boolean = true; 
	private var userId2Avatar:Object;
	
	public function TicTacToe_Main(graphics:MovieClip) {
		super(graphics);
		
		// we might get resized later (when the height and width are passed), 
		// so it's best to hide the board until the game starts.
		AS3_vs_AS2.setVisible(graphics,false);
		 
		grid = new CreateGrid(graphics, "TicTacToeSquare", 3,3,84,100,50);		
		graphics.stop();
		this.graphics = graphics;
		this.ROWS = grid.ROWS;
		this.COLS = grid.COLS;
		userId2Avatar = {};
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(graphics);
		
		WIN_LENGTH = AS3_vs_AS2.convertToInt(parameters["WIN_LENGTH"]);
		PLAYERS_NUM_IN_SINGLE_PLAYER = AS3_vs_AS2.convertToInt(parameters["PLAYERS_NUM_IN_SINGLE_PLAYER"]);
		WINNER_PERCENTAGE = AS3_vs_AS2.convertToInt(parameters["WINNER_PERCENTAGE"]);
		
		if (WIN_LENGTH==0) WIN_LENGTH = 3; 
		if (PLAYERS_NUM_IN_SINGLE_PLAYER==0) PLAYERS_NUM_IN_SINGLE_PLAYER = 3;
		if (WINNER_PERCENTAGE==0) WINNER_PERCENTAGE = 70; 
		
		allCells = [];
		squares = new Array(ROWS);
		for(var row:int=0; row<ROWS; row++) {
			squares[row] = new Array(COLS);
			for(var col:int=0; col<COLS; col++) {
				var cell:TicTacToeMove = TicTacToeMove.create(row, col);
				setSquareGraphic(cell, new TicTacToe_SquareGraphic(this, AS3_vs_AS2.getMovieChild(graphics,"Square_"+row+"_"+col), cell) ); 
				allCells.push(cell);
			}
		}		
		doRegisterOnServer();	
	}
	
	private function getColor(playerId:int):int {
		return AS3_vs_AS2.IndexOf(allPlayerIds, playerId);
	}
	private function getSquareGraphic(move:TicTacToeMove):TicTacToe_SquareGraphic {
		return squares[move.row][move.col];
	}
	private function setSquareGraphic(move:TicTacToeMove, sqaure:TicTacToe_SquareGraphic):void {
		squares[move.row][move.col] = sqaure;
	}
	
	// overriding functions	
	override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void { 
		if (!isKeyDown) return;
		if (!(ROWS==3 && COLS==3)) return;
		var delta:int = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:int =  2-int(delta/3);
			var row:int =  (delta%3);
			userMadeHisMove( TicTacToeMove.create(row, col) );
		}
	}
	override public function gotMyUserId(myUserId:int):void {
		this.myUserId = myUserId;
	}
	override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void {
		// we use only the user's avatars
		for each (var entry:InfoEntry in entries) {
			if (entry.key==API_Message.USER_INFO_KEY_avatar_url) {
				userId2Avatar[userId] = entry.value.toString();
			}
		}
	}

	// To change the symbols of TicTacToe from the default ones (which are "X" and "O"),
	// use custom info keys: TicTacToeSymbol_0, ..., TicTacToeSymbol_3
	public static var TicTacToeSymbol:String = "TicTacToeSymbol_";
	override public function gotCustomInfo(entries:Array/*InfoEntry*/):void {
		for each (var entry:InfoEntry in entries) {
			var key:String = entry.key;
			var value:String = entry.value.toString();
			if (key==API_Message.CUSTOM_INFO_KEY_logoFullUrl) {
				for each (var cell:TicTacToeMove in allCells) {
					getSquareGraphic(cell).gotLogo(value);
				}
			} else if (key==API_Message.CUSTOM_INFO_KEY_gameHeight) {
				var height:int = int(value);
				// we scale the TicTacToe size according to the grid size
				AS3_vs_AS2.scaleMovieY(graphics, 100*height/grid.height());		
			} else if (key==API_Message.CUSTOM_INFO_KEY_gameWidth) {
				var width:int = int(value);
				AS3_vs_AS2.scaleMovieX(graphics, 100*width/grid.width());	
			} else if (key=="TicTacToe_shouldUseAvatars") {
				shouldUseAvatars = Boolean(value);					
			} else if (StaticFunctions.startsWith(key,TicTacToeSymbol)) {
				var color:int = int(key.substr(TicTacToeSymbol.length));				
				replaceSymbol(color, value);				
			}	
		}
	}
	private function replaceSymbol(color:int, symbolUrl:String):void {
		for each (var cell:TicTacToeMove in allCells) {
			getSquareGraphic(cell).gotSymbol(color,symbolUrl);
		}
	}
	override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, extraMatchInfo:Object/*Serializable*/, matchStartedTime:int, userStateEntries:Array/*ServerEntry*/):void {
		AS3_vs_AS2.setVisible(graphics,true);
		this.allPlayerIds = allPlayerIds;
		assert(allPlayerIds.length<=TicTacToe_SquareGraphic.MAX_SYMBOLS, ["The graphics of TicTacToe can handle at most ",TicTacToe_SquareGraphic.MAX_SYMBOLS," players. allPlayerIds=", allPlayerIds]);
		
		if (shouldUseAvatars) {
			// set the player's avatars instead of the default TicTacToe symbols
			// Sometimes two players uses the same avatar. In that case I do not replace one of the symbols. 
			var avatarUrlExists:Object = {};
			for (var colorId:int=0; colorId<allPlayerIds.length; colorId++) {
				var playerId:int = allPlayerIds[colorId];
				var avatarUrl:String = userId2Avatar[playerId];
				if (avatarUrl!=null && avatarUrl!='' && avatarUrlExists[avatarUrl]==null) {
					avatarUrlExists[avatarUrl] = true; // to mark that we saw this avatarUrl 
					replaceSymbol(colorId, avatarUrl);
				}
			}
		}
		
		turnOfColor = 0;
		var indexOfMyUserId:int = AS3_vs_AS2.IndexOf(allPlayerIds,myUserId);
		myColor = indexOfMyUserId==-1 ? VIEWER : 
				indexOfMyUserId;
		var playersNum:int = playersNumber();
		ongoingColors = [];
		for (var color:int=0; color<playersNum; color++)
			ongoingColors.push(color);
		logic = new TicTacToe_logic(ROWS,COLS,WIN_LENGTH, playersNum);
		for each (var serverEntry:ServerEntry in userStateEntries) {
			if (!isSinglePlayer()) turnOfColor = getColor(serverEntry.storedByUserId);	// some users may have disconnected in the middle of the game	
			performMove(serverEntry.value, true);	//we should not call doAllEndMatch when loading the match	
		}
		if (finishedPlayerIds.length>0)
			matchOverForPlayers(finishedPlayerIds);
		
		for each (var move:TicTacToeMove in allCells) {		
			getSquareGraphic(move).clearWinAnimation();
		}
		startMove(true);
	}
	override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void {
		if (matchOverForPlayers(finishedPlayerIds))
			startMove(true); // need to call it only if the current color was changed
		// if there is one player left (due to other users that disconnected),
		// then I don't end the game because the container will give the user an option
		// to either: win, cancel, or save the game.
	}	
	override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
		// the moves are done in alternating turns: color 0, then color 1 (in a round robin)	
		assert(serverEntries.length==1, ["there is one entry per move in TicTacToe"]);	
		var entry:ServerEntry = serverEntries[0];
		assert(entry.visibleToUserIds==null, ["All communication in TicTacToe is PUBLIC"]);
		
		var expectedKey:int = getEntryKey();
		if (entry.key!=expectedKey) return; // if the user pressed several times and therefore sent his move several times
		
		var userId:int = entry.storedByUserId;
		var colorOfUser:int = getColor(userId);
		if (colorOfUser==-1) return;  // viewers cannot store match state in TicTacToe, so we just ignore whatever a viewer placed in the match state		
		// In SinglePlayer: the player already called return before, but a viewer (there can be viewers even for singleplayer games!) still needs to call performMove 
		if (!isSinglePlayer()) {
			if (AS3_vs_AS2.IndexOf(ongoingColors, colorOfUser)==-1) return; // player already disconnected 
			assert(turnOfColor==colorOfUser, ["Got an entry from player=",userId," of color=",colorOfUser," but expecting one from color=", turnOfColor]);
		}
		performMove(entry.value, false);
	}
	
	private function matchOverForPlayers(finishedPlayerIds:Array/*int*/):Boolean {
		if (logic==null) return false; // match already ended
		var colors:Array/*int*/ = [];
		for each (var playerId:int in finishedPlayerIds) {
			var colorOfPlayerId:int = getColor(playerId);
			assert(colorOfPlayerId!=-1, ["Didn't find playerId=",playerId]); 
			colors.push(colorOfPlayerId);
		}
		return matchOverForColors(colors);
	}
	private function matchOverForColors(colors:Array/*int*/):Boolean {	
		var shouldChangeTurnOfColor:Boolean = false;
		for each (var color:int in colors) {		
			var ongoingIndex:int = AS3_vs_AS2.IndexOf(ongoingColors, color);
			if (ongoingIndex==-1) continue; // already finished (when the game ends normally, I immediately call matchOverForColors. see performMove) 
			ongoingColors.splice(ongoingIndex, 1);
			if (color==myColor && !isSinglePlayer()) myColor = VIEWER; // I'm now a viewer
			if (color==turnOfColor) {
				shouldChangeTurnOfColor = true;
			}
			doTrace("matchOverForColor",[color, " shouldChangeTurnOfColor=",shouldChangeTurnOfColor]);	
		}
		if (ongoingColors.length==0) {
			startMove(false); // turns off the squares
			logic = null;
		} else if (shouldChangeTurnOfColor) {
			turnOfColor = getNextTurnOfColor();
		}		
		return shouldChangeTurnOfColor;
	}
	private function playersNumber():int {
		return isSinglePlayer() ? PLAYERS_NUM_IN_SINGLE_PLAYER : allPlayerIds.length;
	}
	private function isSinglePlayer():Boolean {
		return allPlayerIds.length==1;
	}
	private function getNextTurnOfColor():int {
		var nextTurnOfColor:int = turnOfColor;
		while (true) {	
			nextTurnOfColor++;
			if (nextTurnOfColor==playersNumber()) nextTurnOfColor = 0;
			if (AS3_vs_AS2.IndexOf(ongoingColors, nextTurnOfColor)!=-1) break;
		}	
		return nextTurnOfColor;
	}
	private static function arrayCopy(arr:Array):Array {
		var res:Array = [];
		for each (var x:Object in arr) {
			res.push(x);
		}
		return res;			
	}
	private function performMove(move:TicTacToeMove, isSavedGame:Boolean):void {
		doTrace("performMove",["move=",move," isSavedGame=",isSavedGame]);
		logic.makeMove(turnOfColor, move);
		// update the graphics
		var square:TicTacToe_SquareGraphic = getSquareGraphic(move);
		square.setColor(turnOfColor);
		if (!isSavedGame) {
			square.startMoveAnimation();
		}	
		
		var winningCells:Array/*TicTacToeMove*/ = logic.getWinningCells(move);
		var didWin:Boolean = winningCells!=null;
		if (didWin) {
			for each (var winCell:TicTacToeMove in winningCells) {
				getSquareGraphic(winCell).startWinAnimation();
			}
		}
		
		var isBoardFull:Boolean = logic.isBoardFull();
		if (didWin || isBoardFull) {
			//game is over for one player (but the other players, if there are more than 2 remaining players, will continue playing)
			var finishedPlayers:Array/*PlayerMatchOver*/ = [];
			var isGameOver:Boolean = 
				isBoardFull || ongoingColors.length==2;
			if (isSinglePlayer()) {
				if (isGameOver) 
					finishedPlayers.push(
						PlayerMatchOver.create(allPlayerIds[0], 0, -1) );				
			} else {
				var score:int;
				var percentage:int;
				if (didWin) {
					//winner is turnOfColor
					score = ongoingColors.length;					
					if (isBoardFull || ongoingColors.length==2) {
						percentage = 100; // there won't be any other winners
					} else {
						percentage = WINNER_PERCENTAGE; 
					}
					var winnerId:int = allPlayerIds[turnOfColor];
					finishedPlayers.push(
						PlayerMatchOver.create(winnerId, score, percentage) );	
					
					if (ongoingColors.length==2) {
						// last player gets nothing
						var loserColorId:int = ongoingColors[0]==turnOfColor ? ongoingColors[1] : ongoingColors[0];
						var loserPlayerId:int = allPlayerIds[loserColorId];
						score = -1;
						percentage = 0;
						finishedPlayers.push(
							PlayerMatchOver.create(loserPlayerId, score, percentage) );
					}
				}		
				if (isBoardFull) { // Important: it can happen that someone won and the board has just filled up!				
					var finishedPlayersIds:Array/*int*/ = [];
					for each (var playerMatchOver:PlayerMatchOver in finishedPlayers) {
						finishedPlayersIds.push(playerMatchOver.playerId);
					}					
					for each (var ongoingColor:int in ongoingColors) {
						var ongoingPlayerId:int = allPlayerIds[ongoingColor];
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
								PlayerMatchOver.create(ongoingPlayerId, score, percentage) );
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
		
		if (!isSavedGame) startMove(true);
	}
	private function getEntryKey():int {
		return logic.getMoveNumber();
	}
	public function userMadeHisMove(move:TicTacToeMove):void {		
		doTrace("dispatchMoveIfLegal", [move]);
		if (logic==null) return; // game not in progress
		if (myColor==VIEWER) return; // viewer cannot make a move
		if (!isSinglePlayer() && myColor!=turnOfColor) return; // not my turn
		if (!logic.isSquareAvailable(move)) return; // already filled this square (e.g., if you press on the keyboard, you may choose a cell that is already full)
		doStoreState( [UserEntry.create(getEntryKey(), move, false)] );		
		// We do not update the graphics here. We update the graphics only after the server called gotStateChanged
		// Note that as a result, if the user presses quickly on the same button, there might be several identical calls to doStoreState.
	}
	private function startMove(isInProgress:Boolean):void {
		//trace("startMove with isInProgress="+isInProgress);
		if (logic==null) return; 
						
		if (isInProgress && !isSinglePlayer()) {
			doAllSetTurn(allPlayerIds[turnOfColor],-1);
		}		
		for each (var move:TicTacToeMove in allCells) {				
			if (logic.isSquareAvailable(move)) {
				var square:TicTacToe_SquareGraphic = getSquareGraphic(move);
				square.startMove(
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