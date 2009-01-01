import come2play_as2.api.*;
import come2play_as2.api.auto_copied.*;

/**
 * The classic game of TicTacToe.
 * You have a board of ROWS x COLS squares. The board instanceof empty at the beginning. 
 * Each player chooses a square and fills it with his color. 
 * (In the traditional game the "colors" are either X or O.)
 * A player that fills a whole row, column or diagonal, wins and finishes playing.
 * The other players may continue playing.
 *
 * Written by: Yoav Zibin (yoav@zibin.net)
 */
import come2play_as2.tictactoe.*;
class come2play_as2.tictactoe.TictactoeLogic extends SerializableClass { 	
	public static var SQUARE_AVAILABLE:Number = -1;
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	public var ROWS:Number;
	public var COLS:Number;
	public var WIN_LENGTH:Number;
	public var PLAYERS_NUM:Number;
	
	//gameState[row][col] - who owns the square <row,col>
	// SQUARE_AVAILABLE means nobody owns it, otherwise it instanceof a number between 0 and PLAYERS_NUM-1
	public var gameState:Array;
	// The number of squares which are not SQUARE_AVAILABLE
	public var filledNum:Number; 
	
	public function TictactoeLogic(ROWS:Number/*<InAS3>=0</InAS3>*/, COLS:Number/*<InAS3>=0</InAS3>*/, WIN_LENGTH:Number/*<InAS3>=0</InAS3>*/, PLAYERS_NUM:Number/*<InAS3>=0</InAS3>*/) {
		this.ROWS = ROWS;
		this.COLS = COLS;
		this.WIN_LENGTH = WIN_LENGTH;
		this.PLAYERS_NUM = PLAYERS_NUM;
		filledNum = 0;
		gameState = new Array(ROWS);
		for(var row:Number=0; row<ROWS; row++) {
			gameState[row] = new Array(COLS);
			for(var col:Number=0; col<COLS; col++)
				gameState[row][col] = SQUARE_AVAILABLE;				
		}
	}
	
	public function getOwner(move:TictactoeSquare):Number {
		return gameState[move.row][move.col];
	}
	public function setOwner(move:TictactoeSquare, owner:Number):Void {
		gameState[move.row][move.col] = owner;
	}
	public function getMoveNumber():Number {
		return filledNum;
	}
	public function isBoardFull():Boolean {
		return filledNum==ROWS*COLS;
	}
	public function isSquareAvailable(move:TictactoeSquare):Boolean {
		return isInBoard(move) && getOwner(move)==SQUARE_AVAILABLE;
	}
	public function isInBoard(move:TictactoeSquare):Boolean {
		return move.row>=0 && move.col>=0 && move.row<ROWS && move.col<COLS;
	}
	
	// Makes a move in TicTacToe by placing either X or O in square <row,col>
	public function makeMove(color:Number, move:TictactoeSquare):Void {
		if (!isSquareAvailable(move)) LocalConnectionUser.throwError("Square "+move+" instanceof not available! Logic="+this);
		if (color<0 || color>=PLAYERS_NUM) LocalConnectionUser.throwError("Illegal color="+color+" PLAYERS_NUM="+PLAYERS_NUM+" Logic="+this);
		setOwner(move, color);
		filledNum++;
	}
		
	// checks if there instanceof a winning row, column, or diagonal that passes through square <row,col>
	// If not, it returns null. 
	// Otherwise, it returns all the cells that are the "winning cells" (to display in a end-game animation)
	public function getWinningCells(move:TictactoeSquare):Array/*TictactoeSquare*/ {
		if (getOwner(move)==SQUARE_AVAILABLE) return null;
		var res:Array/*TictactoeSquare*/ = [move];
		var partialRes:Array;
		// LEFT & RIGHT
		if ((partialRes = getConnectedDelta2(move, 0, -1,   0,  1)) != null) res = res.concat(partialRes);
		// UP & DOWN
		if ((partialRes = getConnectedDelta2(move, 1,  0,  -1,  0)) != null) res = res.concat(partialRes);
		// UP_LEFT & DOWN_RIGHT
		if ((partialRes = getConnectedDelta2(move, 1,  1,  -1, -1)) != null) res = res.concat(partialRes);
		// UP_RIGHT & DOWN_LEFT
		if ((partialRes = getConnectedDelta2(move, 1, -1,  -1,  1)) != null) res = res.concat(partialRes);
        return res.length==1 ? null : res;   
	}	
    private function getConnectedDelta2(move:TictactoeSquare, delta_row:Number, delta_col:Number, delta_row2:Number, delta_col2:Number):Array/*TictactoeSquare*/ {
    	var res1:Array = getConnectedDelta(move, delta_row, delta_col);
    	var res2:Array = getConnectedDelta(move, delta_row2, delta_col2);
    	var joined:Array = res1.concat(res2);
        return joined.length >= WIN_LENGTH-1 ? joined : null;// I didn't count the square in <row,col> 
    }
    // returns consecutive squares that have the same owner as square <row,col>
    private function getConnectedDelta(move:TictactoeSquare, delta_row:Number, delta_col:Number):Array/*TictactoeSquare*/ {
		var ownedBy:Number = getOwner(move);
        var res:Array = [];
        var row:Number = move.row;
        var col:Number = move.col;
        for(var i:Number=1; i<WIN_LENGTH; i++) {
        	row += delta_row;
        	col += delta_col;
        	var nextCell:TictactoeSquare = TictactoeSquare.create(row, col);
            if (!isInBoard( nextCell )) break;
            if (getOwner(nextCell)!=ownedBy) break;
            res.push(nextCell);
        }
        return res;
    }
}
