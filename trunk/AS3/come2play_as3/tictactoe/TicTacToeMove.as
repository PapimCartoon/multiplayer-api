package come2play_as3.tictactoe
{
	import come2play_as3.util.*;
	import come2play_as3.api.auto_copied.*;
	
	public final class TicTacToeMove extends SerializableClass
	{
		public var row:int, col:int;
		public static function create(row:int, col:int):TicTacToeMove {			
			var res:TicTacToeMove = new TicTacToeMove();
		    res.row = row;
		    res.col = col;
		    return res;
		}
		public function getParametersAsString():String { return 'row=' + row+', col=' + col; }
		public function toString():String { return '{TicTacToeMove: ' + getParametersAsString() + '}'; }
	}
}