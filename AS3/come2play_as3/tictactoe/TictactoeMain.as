package come2play_as3.tictactoe 
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
/**
 * See the game rules in TictactoeLogic.
 * 
 * When a player wins, he gets some of the stakes, and the rest continue playing, 
 * until only a single player remains (and he doesn't get any stakes).
 * The first winner will get 70% of the pot (can be changed using customization),
 * the second one will get 70% of what remained,
 * and so on, until the last winner will get the entire 100% of the remainder.
 * (and the loser gets nothing).
 * 
 * Written by: Yoav Zibin (yoav@zibin.net)
 */
public final class TictactoeMain extends ClientGameAPI {
	private static const VIEWER:int = -1; 	
	
	// grid creates all the cell movieclips and places them in a grid
	private var grid:CreateGrid;
	// graphics is the root movieclip which will contain all the cell movieclips
	private var graphics:MovieClip;
	// allCells contains all TictactoeSquare objects
	private var allCells:Array/*TictactoeSquare*/;
	// squares[row][col] is the square at position TictactoeSquare(row,col)
	private var squares:Array/*TictactoeSquareGraphic[]*/;
	private var logic:TictactoeLogic;
	// allPlayerIds does not change since getting gotMatchStarted
	private var allPlayerIds:Array/*int*/; 
	// when a player finishes (wins/disconnects) we remove him from ongoingColors
	private var ongoingColors:Array/*int*/;  
	private var myUserId:int = -42;
	private var turnOfColor:int; // a number between 0 and allPlayerIds.length	
	private var shouldSendMove:Boolean; // to prevent the user sending his move several times
	private var myColor:int; // either VIEWER, or a number between 0 and allPlayerIds.length
	// contains a mapping from userId to his avatar (see gotUserInfo)
	private var userId2Avatar:Object;
	
	////////////////////////////////////////////////////
	// Customizable fields (see gotCustomInfo)
	// For example if we get an InfoEntry:
	// InfoEntry.create("shouldUseAvatars",true)
	// Then it updates the field 'shouldUseAvatars' to the value true. 
	////////////////////////////////////////////////////
	// We may use the player's avatars instead of the default symbols (of "X" and "O")
	private var shouldUseAvatars:Boolean = true; 
	// for example, you can have a board of size 5x5, with winLength=4
	private var winLength:int;
	private var playersNumInSinglePlayer:int;
	private var winnerPercentage:int;	
	private var logoFullUrl:String;
	private var customSymbolsStringArray:Array/*String*/;
	private var gameHeight:int;
	private var gameWidth:int;
	
	
	public function TictactoeMain(graphics:MovieClip) {
		super(graphics);	
			
		new TictactoeSquare().register();	 
		this.graphics = graphics;	
		// It's best to hide the board until the game starts.
		AS3_vs_AS2.setVisible(graphics,false);	
		graphics.stop();
				
		AS3_vs_AS2.waitForStage(graphics, AS3_vs_AS2.delegate(this,this.constructGame));
	}
	public function constructGame():void {
		userId2Avatar = {};		
		doRegisterOnServer();
	}
	private function ROWS():int {
		return grid.ROWS;
	}
	private function COLS():int {
		return grid.COLS;
	}
	
	private function getColor(playerId:int):int {
		return AS3_vs_AS2.IndexOf(allPlayerIds, playerId);
	}
	private function getSquareGraphic(move:TictactoeSquare):TictactoeSquareGraphic {
		return squares[move.row][move.col];
	}
	private function setSquareGraphic(move:TictactoeSquare, sqaure:TictactoeSquareGraphic):void {
		squares[move.row][move.col] = sqaure;
	}
	
	// overriding functions	
	override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void { 
		if (!isKeyDown) return;
		if (!(ROWS()==3 && COLS()==3)) return;
		var delta:int = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:int =  2-int(delta/3);
			var row:int =  (delta%3);
			userMadeHisMove( TictactoeSquare.create(row, col) );
		}
	}
	override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void {
		// From the userInfo, we use only the user's avatars (so we do not keep all the info entries) 
		for each (var entry:InfoEntry in entries) {
			if (entry.key==USER_INFO_KEY_avatar_url) {
				userId2Avatar[userId] = entry.value.toString();
			}
		}
	}

	private function loadLogo():void {
		for each (var square:TictactoeSquare in allCells) {
			getSquareGraphic(square).gotLogo(logoFullUrl);
		}	
	}	
	private function replaceSymbol(color:int, symbolUrl:String):void {		
		var thisObj:TictactoeMain = this; // for AS2
		cacheImage(symbolUrl, graphics,
			function (isSucc:Boolean):void {
				if (isSucc) thisObj.replaceCachedSymbol(color, symbolUrl);
			});
	}
	private function replaceCachedSymbol(color:int, symbolUrl:String):void {
		for each (var cell:TictactoeSquare in allCells) {
			getSquareGraphic(cell).gotSymbol(color,symbolUrl);
		}		
	}
	override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, userStateEntries:Array/*ServerEntry*/):void {
		// your userId may change if your game as the back&forward option
		myUserId = AS3_vs_AS2.as_int(T.custom(CUSTOM_INFO_KEY_myUserId,null));
		 
		shouldUseAvatars = AS3_vs_AS2.asBoolean(T.custom("shouldUseAvatars",true));			 
		winLength = AS3_vs_AS2.as_int(T.custom("winLength",3));
		assert(winLength>1 && winLength<=5, ["Illegal winLength=",winLength]);
		playersNumInSinglePlayer = AS3_vs_AS2.as_int(T.custom("playersNumInSinglePlayer",3));
		assert(playersNumInSinglePlayer>0 && playersNumInSinglePlayer<=5, ["Illegal playersNumInSinglePlayer=",playersNumInSinglePlayer]);
		winnerPercentage = AS3_vs_AS2.as_int(T.custom("winnerPercentage",70));
		assert(winnerPercentage>0 && winnerPercentage<=100, ["Illegal winnerPercentage=",winnerPercentage]);
		
		// the number of rows&cols cannot be changed
		if (grid==null) {  					
			grid = new CreateGrid(3,3,84,100,50);
			grid.createMovieClips(graphics, "TicTacToeSquare");
		
			allCells = [];
			squares = new Array(ROWS());
			for(var row:int=0; row<ROWS(); row++) {
				squares[row] = new Array(COLS());
				for(var col:int=0; col<COLS(); col++) {
					var cell:TictactoeSquare = TictactoeSquare.create(row, col);
					setSquareGraphic(cell, new TictactoeSquareGraphic(this, AS3_vs_AS2.getMovieChild(graphics,"Square_"+row+"_"+col), cell) ); 
					allCells.push(cell);
				}
			}		
		}
		
		
		
		// use customSymbolsStringArray to change the symbols of TicTacToe from the default ones (which are "X" and "O")
		var newCustomSymbolsStringArray:Array/*String*/ = 
			AS3_vs_AS2.asArray(T.custom("customSymbolsStringArray",null));
		if (customSymbolsStringArray!=newCustomSymbolsStringArray) {
			customSymbolsStringArray = newCustomSymbolsStringArray;
			for (var i:int=0; i<customSymbolsStringArray.length; i++) {
				var symbolUrl:String = customSymbolsStringArray[i];
				if (symbolUrl!=null) 
					replaceSymbol(i,symbolUrl);
			}	
		}
			
		var newLogoFullUrl:String = 
			AS3_vs_AS2.asString(T.custom(CUSTOM_INFO_KEY_logoFullUrl, null));
		if (logoFullUrl!=newLogoFullUrl) {
			logoFullUrl = newLogoFullUrl;
			var thisObj:TictactoeMain = this; // for AS2
			cacheImage(logoFullUrl, graphics,
				function (isSucc:Boolean):void { 
					if (isSucc) thisObj.loadLogo(); 
				});
		}
			
		
		// we scale the TicTacToe size according to the grid size
		var newHeight:int = AS3_vs_AS2.as_int(T.custom(CUSTOM_INFO_KEY_gameHeight, 400));
		var newWidth:int = AS3_vs_AS2.as_int(T.custom(CUSTOM_INFO_KEY_gameWidth, 400));
		assert(newHeight>10 && newWidth>10, ["Illegal gameHeight or gameWidth"]);	
		if (gameWidth!=newWidth || gameHeight!=newHeight) {
			gameWidth = newWidth;
			gameHeight = newHeight;			
			StaticFunctions.storeTrace(["dimensions=",gameHeight,"x",gameWidth," gridDimesions=",grid.height(),"x",grid.width()]);
			AS3_vs_AS2.scaleMovieY(graphics, 100*gameHeight/grid.height());	
			AS3_vs_AS2.scaleMovieX(graphics, 100*gameWidth/grid.width());
		}			
		AS3_vs_AS2.setVisible(graphics, true);	
		
		
		this.allPlayerIds = allPlayerIds;
		assert(allPlayerIds.length>=0 && allPlayerIds.length<=TictactoeSquareGraphic.MAX_SYMBOLS, ["The graphics of TicTacToe can handle at most ",TictactoeSquareGraphic.MAX_SYMBOLS," players. allPlayerIds=", allPlayerIds]);
		
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
		StaticFunctions.storeTrace(["myUserId=",myUserId," myColor=",myColor, " playersNum=",playersNum]);
		ongoingColors = [];
		for (var color:int=0; color<playersNum; color++)
			ongoingColors.push(color);
		logic = new TictactoeLogic(ROWS(),COLS(),winLength, playersNum);
		for each (var serverEntry:ServerEntry in userStateEntries) {
			if (!isSinglePlayer()) turnOfColor = getColor(serverEntry.storedByUserId);	// some users may have disconnected in the middle of the game	
			performMove(/*as*/serverEntry.value as TictactoeSquare, true);	//we should not call doAllEndMatch when loading the match	
		}
		if (finishedPlayerIds.length>0)
			matchOverForPlayers(finishedPlayerIds);
		
		for each (var move:TictactoeSquare in allCells) {		
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
		
		var userId:int = entry.storedByUserId;
		var colorOfUser:int = getColor(userId);
		assert(colorOfUser!=-1, ["viewers cannot store match state in TicTacToe"]);

		var expectedKey:int = getEntryKey();
		assert(entry.key==expectedKey, ["Expecting key=",expectedKey]);

		// In SinglePlayer: the player already called return before, but a viewer (there can be viewers even for singleplayer games!) still needs to call performMove 
		if (!isSinglePlayer()) {
			if (AS3_vs_AS2.IndexOf(ongoingColors, colorOfUser)==-1) return; // player already disconnected 
			assert(turnOfColor==colorOfUser, ["Got an entry from player=",userId," of color=",colorOfUser," but expecting one from color=", turnOfColor]);
		}
		performMove(/*as*/entry.value as TictactoeSquare, false);
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
		return isSinglePlayer() ? playersNumInSinglePlayer : allPlayerIds.length;
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
	private function performMove(move:TictactoeSquare, isSavedGame:Boolean):void {
		logic.makeMove(turnOfColor, move);
		// update the graphics
		var square:TictactoeSquareGraphic = getSquareGraphic(move);
		square.setColor(turnOfColor);
					
		if (!isSavedGame) {
			square.startMoveAnimation();
		} else {
			moveAnimationEnded(move, isSavedGame);
		}	
	}
	public function moveAnimationEnded(move:TictactoeSquare, isSavedGame:Boolean):void {
		// to display the winning animation (after the move animation ends)
		var winningCells:Array/*TictactoeSquare*/ = logic.getWinningCells(move);
		var didWin:Boolean = winningCells!=null;
		if (didWin) {
			for each (var winCell:TictactoeSquare in winningCells) {
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
						percentage = winnerPercentage; 
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
		
		if (!isSavedGame) {
			startMove(true);
			animationEnded(); // must be after we call all the doAll functions (and in startMove we have doAllSetTurn) 
		}
	}
	private function getEntryKey():int {
		return logic.getMoveNumber();
	}
	public function userMadeHisMove(move:TictactoeSquare):void {		
		doTrace("dispatchMoveIfLegal", [move]);
		if (!shouldSendMove) return; // user already sent his move
		if (logic==null) return; // game not in progress
		if (!isMyTurn()) return; // not my turn
		if (!logic.isSquareAvailable(move)) return; // already filled this square (e.g., if you press on the keyboard, you may choose a cell that is already full)

		shouldSendMove = false;		
		for each (var square:TictactoeSquare in allCells) {				
			if (!logic.isSquareAvailable(square)) continue;
			if (move.isEqual(square)) continue; // otherwise, it causes a slight blink because we show the logo and then immediately the move animation
			var squareGraphics:TictactoeSquareGraphic = getSquareGraphic(square);
			squareGraphics.startMove(TictactoeSquareGraphic.BTN_NONE); // to cancel mouseOver and mouseOut
		}
		
		doStoreState( [UserEntry.create(getEntryKey(), move, false)] );		
		// We do not update the graphics here. We update the graphics only after the server called gotStateChanged
		// Note that as a result, if the user presses quickly on the same button, there might be several identical calls to doStoreState.
	}
	private function isMyTurn():Boolean {
		return myColor!=VIEWER && (isSinglePlayer() || myColor==turnOfColor);
	}
	private function startMove(isInProgress:Boolean):void {
		//trace("startMove with isInProgress="+isInProgress);
		if (logic==null) return; 
						
		if (isInProgress && !isSinglePlayer()) {
			doAllSetTurn(allPlayerIds[turnOfColor],-1);
		}		
		if (isMyTurn()) shouldSendMove = true;
		for each (var square:TictactoeSquare in allCells) {				
			if (!logic.isSquareAvailable(square)) continue;
			var squareGraphics:TictactoeSquareGraphic = getSquareGraphic(square);
			squareGraphics.startMove(
				!isInProgress ? TictactoeSquareGraphic.BTN_NONE : // the match was over
				myColor==VIEWER ? TictactoeSquareGraphic.BTN_NONE : // a viewer never has the turn
				isSinglePlayer() ? turnOfColor : // single player always has the turn
				myColor==turnOfColor ?  
					turnOfColor : // I have the turn
					TictactoeSquareGraphic.BTN_NONE); // not my turn
		}
	}
}
}