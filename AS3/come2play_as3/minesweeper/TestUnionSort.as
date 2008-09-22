package come2play_as3.mineSweeper
{	
	public class TestUnionSort 
	{
		public function TestUnionSort()
		{
			var board:Array=new Array();
			for(var i:int = 0;i<10;i++)
			{
				board[i]=new Array();
				for(var j:int = 0;j<10;j++)
				{
					board[i][j] = 
						i==5 || i == 2 ? 0 : 10;					
				}
			}
			var union:UnionSort = new UnionSort(board,10,10); 
		}

	}
}