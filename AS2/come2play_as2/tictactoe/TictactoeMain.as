import come2play_as2.api.*;
import come2play_as2.api.auto_copied.*;
import come2play_as2.api.auto_generated.*;

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
import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TictactoeMain extends ClientGameAPI {
	private static var VIEWER:Number = -1; 	
	
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
	private var myUserId:Number = -42;
	private var turnOfColor:Number; // a number between 0 and allPlayerIds.length	
	private var shouldSendMove:Boolean; // to prevent the user sending his move several times
	private var myColor:Number; // either VIEWER, or a number between 0 and allPlayerIds.length
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
	private var winLength:Number;
	public static var playersNumInSinglePlayer:Number = 3;
	private var winnerPercentage:Number;	
	private var logoFullUrl:String;
	private var customSymbolsStringArray:Array/*String*/;
	private var gameHeight:Number;
	private var gameWidth:Number;
	
	
	public function TictactoeMain(graphics:MovieClip) {
		super(graphics);	
			
		new TictactoeSquare().register();	 
		this.graphics = graphics;	
		// It's best to hide the board until the game starts.
		AS3_vs_AS2.setVisible(graphics,false);	
		graphics.stop();
				
		AS3_vs_AS2.waitForStage(graphics, AS3_vs_AS2.delegate(this,this.constructGame));
	}
	public function constructGame():Void {
		userId2Avatar = {};		
		doRegisterOnServer();
	}
	private function ROWS():Number {
		return grid.ROWS;
	}
	private function COLS():Number {
		return grid.COLS;
	}
	
	private function getColor(playerId:Number):Number {
		return AS3_vs_AS2.IndexOf(allPlayerIds, playerId);
	}
	private function getSquareGraphic(move:TictactoeSquare):TictactoeSquareGraphic {
		return squares[move.row][move.col];
	}
	private function setSquareGraphic(move:TictactoeSquare, sqaure:TictactoeSquareGraphic):Void {
		squares[move.row][move.col] = sqaure;
	}
	
	// overriding functions	
	/*override*/ public function gotKeyboardEvent(isKeyDown:Boolean, charCode:Number, keyCode:Number, keyLocation:Number, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):Void { 
		if (!isKeyDown) return;
		if (!(ROWS()==3 && COLS()==3)) return;
		var delta:Number = charCode - '1'.charCodeAt(0); 
		if (delta>=0 && delta<9) {
			var col:Number =  2-int(delta/3);
			var row:Number =  (delta%3);
			userMadeHisMove( TictactoeSquare.create(row, col) );
		}
	}
	/*override*/ public function gotUserInfo(userId:Number, entries:Array/*InfoEntry*/):Void {
		// From the userInfo, we use only the user's avatars (so we do not keep all the info entries) 
		for (var i106:Number=0; i106<entries.length; i106++) { var entry:InfoEntry = entries[i106]; 
			if (entry.key==USER_INFO_KEY_avatar_url) {
				userId2Avatar[userId] = entry.value.toString();
			}
		}
	}

	private function loadLogo():Void {
		for (var i114:Number=0; i114<allCells.length; i114++) { var square:TictactoeSquare = allCells[i114]; 
			getSquareGraphic(square).gotLogo(logoFullUrl);
		}	
	}	
	private function replaceSymbol(color:Number, symbolUrl:String):Void {		
		var thisObj:TictactoeMain = this; // for AS2
		cacheImage(symbolUrl, graphics,
			function (isSucc:Boolean):Void {
				if (isSucc) thisObj.replaceCachedSymbol(color, symbolUrl);
			});
	}
	private function replaceCachedSymbol(color:Number, symbolUrl:String):Void {
		for (var i126:Number=0; i126<allCells.length; i126++) { var cell:TictactoeSquare = allCells[i126]; 
			getSquareGraphic(cell).gotSymbol(color,symbolUrl);
		}		
	}
	/*override*/ public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, userStateEntries:Array/*ServerEntry*/):Void {
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
			for(var row:Number=0; row<ROWS(); row++) {
				squares[row] = new Array(COLS());
				for(var col:Number=0; col<COLS(); col++) {
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
			for (var i:Number=0; i<customSymbolsStringArray.length; i++) {
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
				function (isSucc:Boolean):Void { 
					if (isSucc) thisObj.loadLogo(); 
				});
		}
			
		
		// we scale the TicTacToe size according to the grid size
		var newHeight:Number = AS3_vs_AS2.as_int(T.custom(CUSTOM_INFO_KEY_gameHeight, 400));
		var newWidth:Number = AS3_vs_AS2.as_int(T.custom(CUSTOM_INFO_KEY_gameWidth, 400));
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
			for (var colorId:Number=0; colorId<allPlayerIds.length; colorId++) {
				var playerId:Number = allPlayerIds[colorId];
				var avatarUrl:String = userId2Avatar[playerId];
				if (avatarUrl!=null && avatarUrl!='' && avatarUrlExists[avatarUrl]==null) {
					avatarUrlExists[avatarUrl] = true; // to mark that we saw this avatarUrl 
					replaceSymbol(colorId, avatarUrl);
				}
			}
		}
		
		turnOfColor = 0;
		var indexOfMyUserId:Number = AS3_vs_AS2.IndexOf(allPlayerIds,myUserId);
		myColor = indexOfMyUserId==-1 ? VIEWER : 
				indexOfMyUserId;
		var playersNum:Number = playersNumber();
		StaticFunctions.storeTrace(["myUserId=",myUserId," myColor=",myColor, " playersNum=",playersNum]);
		ongoingColors = [];
		for (var color:Number=0; color<playersNum; color++)
			ongoingColors.push(color);
		logic = new TictactoeLogic(ROWS(),COLS(),winLength, playersNum);
		for (var i226:Number=0; i226<userStateEntries.length; i226++) { var serverEntry:ServerEntry = userStateEntries[i226]; 
			if (!isSinglePlayer()) turnOfColor = getColor(serverEntry.storedByUserId);	// some users may have disconnected in the middle of the game	
			performMove(TictactoeSquare(serverEntry.value), true);	//we should not call doAllEndMatch when loading the match	
		}
		if (finishedPlayerIds.length>0)
			matchOverForPlayers(finishedPlayerIds);
		
		for (var i233:Number=0; i233<allCells.length; i233++) { var move:TictactoeSquare = allCells[i233]; 
			getSquareGraphic(move).clearWinAnimation();
		}
		startMove(true);
	}
	/*override*/ public function gotMatchEnded(finishedPlayerIds:Array/*int*/):Void {
		if (matchOverForPlayers(finishedPlayerIds))
			startMove(true); // need to call it only if the current color was changed
		// if there is one player left (due to other users that disconnected),
		// then I don't end the game because the container will give the user an option
		// to either: win, cancel, or save the game.
	}	
	/*override*/ public function gotStateChanged(serverEntries:Array/*ServerEntry*/):Void {
		// the moves are done in alternating turns: color 0, then color 1 (in a round robin)	
		assert(serverEntries.length==1, ["there is one entry per move in TicTacToe"]);	
		var entry:ServerEntry = serverEntries[0];
		assert(entry.visibleToUserIds==null, ["All communication in TicTacToe is PUBLIC"]);
		
		var userId:Number = entry.storedByUserId;
		var colorOfUser:Number = getColor(userId);
		assert(colorOfUser!=-1, ["viewers cannot store match state in TicTacToe"]);

		var expectedKey:Number = getEntryKey();
		assert(entry.key==expectedKey, ["Expecting key=",expectedKey]);

		// In SinglePlayer: the player already called return before, but a viewer (there can be viewers even for singleplayer games!) still needs to call performMove 
		if (!isSinglePlayer()) {
			if (AS3_vs_AS2.IndexOf(ongoingColors, colorOfUser)==-1) return; // player already disconnected 
			assert(turnOfColor==colorOfUser, ["Got an entry from player=",userId," of color=",colorOfUser," but expecting one from color=", turnOfColor]);
		}
		performMove(TictactoeSquare(entry.value), false);
	}
	
	private function matchOverForPlayers(finishedPlayerIds:Array/*int*/):Boolean {
		if (logic==null) return false; // match already ended
		var colors:Array/*int*/ = [];
		if (isSinglePlayer()) {
			assert(finishedPlayerIds.length==1 && finishedPlayerIds[0]==allPlayerIds[0], ["The single player has finished playing, i.e., he had a timeout, chose to lose, or disconnected"])
			colors = ongoingColors.concat(); // to clone the array
		} else {
			for (var i273:Number=0; i273<finishedPlayerIds.length; i273++) { var playerId:Number = finishedPlayerIds[i273]; 
				var colorOfPlayerId:Number = getColor(playerId);
				assert(colorOfPlayerId!=-1, ["Didn't find playerId=",playerId]); 
				colors.push(colorOfPlayerId);
			}
		}
		return matchOverForColors(colors);
	}
	private function matchOverForColors(colors:Array/*int*/):Boolean {	
		var shouldChangeTurnOfColor:Boolean = false;
		for (var i283:Number=0; i283<colors.length; i283++) { var color:Number = colors[i283]; 
			var ongoingIndex:Number = AS3_vs_AS2.IndexOf(ongoingColors, color);
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
	private function playersNumber():Number {
		return isSinglePlayer() ? playersNumInSinglePlayer : allPlayerIds.length;
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
		for (var i318:Number=0; i318<arr.length; i318++) { var x:Object = arr[i318]; 
			res.push(x);
		}
		return res;			
	}
	private function performMove(move:TictactoeSquare, isSavedGame:Boolean):Void {
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
	public function moveAnimationEnded(move:TictactoeSquare, isSavedGame:Boolean):Void {
		// to display the winning animation (after the move animation ends)
		var winningCells:Array/*TictactoeSquare*/ = logic.getWinningCells(move);
		var didWin:Boolean = winningCells!=null;
		if (didWin) {
			for (var i340:Number=0; i340<winningCells.length; i340++) { var winCell:TictactoeSquare = winningCells[i340]; 
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
				var score:Number;
				var percentage:Number;
				if (didWin) {
					//winner is turnOfColor
					score = ongoingColors.length;					
					if (isBoardFull || ongoingColors.length==2) {
						percentage = 100; // there won't be any other winners
					} else {
						percentage = winnerPercentage; 
					}
					var winnerId:Number = allPlayerIds[turnOfColor];
					finishedPlayers.push(
						PlayerMatchOver.create(winnerId, score, percentage) );	
					
					if (ongoingColors.length==2) {
						// last player gets nothing
						var loserColorId:Number = ongoingColors[0]==turnOfColor ? ongoingColors[1] : ongoingColors[0];
						var loserPlayerId:Number = allPlayerIds[loserColorId];
						score = -1;
						percentage = 0;
						finishedPlayers.push(
							PlayerMatchOver.create(loserPlayerId, score, percentage) );
					}
				}		
				if (isBoardFull) { // Important: it can happen that someone won and the board has just filled up!				
					var finishedPlayersIds:Array/*int*/ = [];
					for (var i382:Number=0; i382<finishedPlayers.length; i382++) { var playerMatchOver:PlayerMatchOver = finishedPlayers[i382]; 
						finishedPlayersIds.push(playerMatchOver.playerId);
					}					
					for (var i385:Number=0; i385<ongoingColors.length; i385++) { var ongoingColor:Number = ongoingColors[i385]; 
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
	private function getEntryKey():Number {
		return logic.getMoveNumber();
	}
	public function userMadeHisMove(move:TictactoeSquare):Void {		
		doTrace("dispatchMoveIfLegal", [move]);
		if (!shouldSendMove) return; // user already sent his move
		if (logic==null) return; // game not in progress
		if (!isMyTurn()) return; // not my turn
		if (!logic.isSquareAvailable(move)) return; // already filled this square (e.g., if you press on the keyboard, you may choose a cell that is already full)

		shouldSendMove = false;		
		for (var i436:Number=0; i436<allCells.length; i436++) { var square:TictactoeSquare = allCells[i436]; 
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
	private function startMove(isInProgress:Boolean):Void {
		//trace("startMove with isInProgress="+isInProgress);
		if (logic==null) return; 
						
		if (isInProgress) {
			doAllSetTurn(isSinglePlayer() ? allPlayerIds[0] : allPlayerIds[turnOfColor],-1);
		}		
		if (isMyTurn()) shouldSendMove = true;
		for (var i458:Number=0; i458<allCells.length; i458++) { var square:TictactoeSquare = allCells[i458]; 
			if (!logic.isSquareAvailable(square)) continue;
			var squareGraphics:TictactoeSquareGraphic = getSquareGraphic(square);
			squareGraphics.startMove(
				T.custom(CUSTOM_INFO_KEY_isBack,false) ? TictactoeSquareGraphic.BTN_NONE : // the user pressed on back
				!isInProgress ? TictactoeSquareGraphic.BTN_NONE : // the match was over
				myColor==VIEWER ? TictactoeSquareGraphic.BTN_NONE : // a viewer never has the turn
				isSinglePlayer() ? turnOfColor : // single player always has the turn
				myColor==turnOfColor ?  
					turnOfColor : // I have the turn
					TictactoeSquareGraphic.BTN_NONE); // not my turn
		}
	}
}
