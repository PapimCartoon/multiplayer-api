package come2play_as3.tictactoe 
{
import come2play_as3.api.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
/**
 * The classic game of TicTacToe.
 * You have a board of ROWS x COLS squares. The board is empty at the beginning. 
 * Each player chooses a square and fills it with his color. 
 * (In the traditional game the "colors" are either X or O.)
 * A player that fills a whole row, column or diagonal, wins and finishes playing.
 * The other players may continue playing.
 *
 * Written by: Yoav Zibin (yoav@zibin.net)
 */
public final class TicTacToe_logic { 	
	public static const SQUARE_AVAILABLE:int = -1;
	
	// for example, you can have a board of size 5x5, with WIN_LENGTH=4
	public var ROWS:int;
	public var COLS:int;
	public var WIN_LENGTH:int;
	public var PLAYERS_NUM:int;
	
	//gameState[row][col] - who owns the square <row,col>
	// SQUARE_AVAILABLE means nobody owns it, otherwise it is a number between 0 and PLAYERS_NUM-1
	private var gameState:Array;
	// The number of squares which are not SQUARE_AVAILABLE
	private var filledNum:int; 
	
	public function TicTacToe_logic(ROWS:int, COLS:int, WIN_LENGTH:int, PLAYERS_NUM:int) {
		this.ROWS = ROWS;
		this.COLS = COLS;
		this.WIN_LENGTH = WIN_LENGTH;
		this.PLAYERS_NUM = PLAYERS_NUM;
		filledNum = 0;
		gameState = new Array(ROWS);
		for(var row:int=0; row<ROWS; row++) {
			gameState[row] = new Array(COLS);
			for(var col:int=0; col<COLS; col++)
				gameState[row][col] = SQUARE_AVAILABLE;				
		}
	}
	
	public function getOwner(move:TicTacToeMove):int {
		return gameState[move.row][move.col];
	}
	public function setOwner(move:TicTacToeMove, owner:int):void {
		gameState[move.row][move.col] = owner;
	}
	public function getMoveNumber():int {
		return filledNum;
	}
	public function isBoardFull():Boolean {
		return filledNum==ROWS*COLS;
	}
	public function isSquareAvailable(move:TicTacToeMove):Boolean {
		return isInBoard(move) && getOwner(move)==SQUARE_AVAILABLE;
	}
	public function isInBoard(move:TicTacToeMove):Boolean {
		return move.row>=0 && move.col>=0 && move.row<ROWS && move.col<COLS;
	}
	
	// Makes a move in TicTacToe by placing either X or O in square <row,col>
	public function makeMove(color:int, move:TicTacToeMove):void {
		if (!isSquareAvailable(move)) BaseGameAPI.throwError("Square "+move+" is not available");
		if (color<0 || color>=PLAYERS_NUM) BaseGameAPI.throwError("Illegal color="+color);
		setOwner(move, color);
		filledNum++;
	}
		
	// checks if there is a winning row, column, or diagonal that passes through square <row,col>
	public function isWinner(move:TicTacToeMove):Boolean {
		if (getOwner(move)==SQUARE_AVAILABLE) return false;
        return isConnectedDelta(move, 0, -1,   0,  1) || // LEFT & RIGHT
               isConnectedDelta(move, 1,  0,  -1,  0) || // UP & DOWN
               isConnectedDelta(move, 1,  1,  -1, -1) || // UP_LEFT & DOWN_RIGHT
               isConnectedDelta(move, 1, -1,  -1,  1);   // UP_RIGHT & DOWN_LEFT
	}	
    private function isConnectedDelta(move:TicTacToeMove, delta_row:int, delta_col:int, delta_row2:int, delta_col2:int):Boolean {
        return  numConnectedDelta(move, delta_row, delta_col) +
                numConnectedDelta(move, delta_row2, delta_col2) >= 
                	WIN_LENGTH-1;// I didn't count the square in <row,col> 
    }
    // Counts the number of consecutive squares that have the same owner as square <row,col>
    private function numConnectedDelta(move:TicTacToeMove, delta_row:int, delta_col:int):int {
		var ownedBy:int = getOwner(move);
        var res:int = 0;
        var row:int = move.row;
        var col:int = move.col;
        for(var i:int=1; i<WIN_LENGTH; i++) {
        	row += delta_row;
        	col += delta_col;
        	var nextCell:TicTacToeMove = new TicTacToeMove(row, col);
            if (!isInBoard( nextCell )) break;
            if (getOwner(nextCell)!=ownedBy) break;
            res++;
        }
        return res;
    }
}
}