	import come2play_as2.api.auto_copied.*;
	
import come2play_as2.tictactoe.*;
	class come2play_as2.tictactoe.TicTacToeMove extends SerializableClass
	{
		public function TicTacToeMove() {
			
		}
		public var row:Number, col:Number;
		public static function create(row:Number, col:Number):TicTacToeMove {			
			var res:TicTacToeMove = new TicTacToeMove();
		    res.row = row;
		    res.col = col;
		    return res;
		}
		public function getParametersAsString():String { return 'row=' + row+', col=' + col; }
		public function toString():String { return '{TicTacToeMove: ' + getParametersAsString() + '}'; }
	}
