	import come2play_as2.util.*;
	
import come2play_as2.tictactoe.*;
	class come2play_as2.tictactoe.TicTacToeMove
	{
		public var row:Number, col:Number;
		public function TicTacToeMove(row:Number, col:Number)
		{			
		    this.row = row;
		    this.col = col;
		}
		public static function object2GameMove(obj:Object):TicTacToeMove {
			if (obj["row"]==null) throw new Error('Missing field "row" in creating object of type GameMove in object='+JSON.stringify(obj));
			if (obj["col"]==null) throw new Error('Missing field "col" in creating object of type GameMove in object='+JSON.stringify(obj));			
		    return new TicTacToeMove(obj["row"], obj["col"]);
		}
		public function getParametersAsString():String { return 'row=' + row+', col=' + col; }
		public function toString():String { return '{TicTacToeMove: ' + getParametersAsString() + '}'; }
	}
