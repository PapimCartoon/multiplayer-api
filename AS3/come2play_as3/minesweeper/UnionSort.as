package come2play_as3.minesweeper
{
	import flash.utils.Dictionary;
	
	public class UnionSort
	{
		// algorithm output
		public var blankBoxArrays:Array/*BlankBox[]*/;
		private var index2id:Array;
		
		private var xPos:int;
		private var yPos:int;
		private var width:int,height:int; 
		private var sortedBoard:Array;
		
		// returns an array where arr[i][j] 
		// is the id of the group of cell <i,j>
		// if cell <i,j> is a mine, then the id is -1
		private function findGroups(sortBoard:Array):Array {
			var linkBoard:Array = [];
			for(xPos=0;xPos<width;xPos++) {
				linkBoard[xPos] = [];
				for(yPos=0;yPos<height;yPos++)
					if(sortBoard[xPos][yPos] == 0 )
						linkBoard[xPos][yPos]=new Group();
			}
				
			for(xPos=0;xPos<height;xPos++)
				for(yPos=0;yPos<width;yPos++)
				{
					if(sortBoard[xPos][yPos] == 0 )
					{
						
						if(xPos>0)
							calcOne(linkBoard, -1,-1);
								
						calcOne(linkBoard, 0,-1);
							
						if(xPos<(width -1))
							calcOne(linkBoard, 1,-1);
								
						if(xPos>0)
							calcOne(linkBoard, -1,0);

					}
				}
			
			var res:Array = [];
			var group2id:Dictionary = new Dictionary();
			var nextId:int = 0;
			for(xPos=0;xPos<height;xPos++) {
				res[xPos] = [];
				for(yPos=0;yPos<width;yPos++) {
					if(sortBoard[xPos][yPos] == 0 ) {
						var group:Group = linkBoard[xPos][yPos].findRoot();
						if (group2id[group]==null) {
							group2id[group] = nextId++;							
						}
						res[xPos][yPos] = group2id[group];
					} else {
						res[xPos][yPos] = -1;						
					}
				}
			}
			return res;
		}
		public function UnionSort(sortBoard:Array, width:int,height:int)
		{
			this.width = width;
			this.height = height;
			
			sortedBoard = findGroups(sortBoard);
							
			var neighborGroup:int;	
			var id2blankBoxArr:Object = {};
			var blankBoxArr:Array;
			index2id = new Array();
			for(yPos=0;yPos<width;yPos++)
				for(xPos=0;xPos<height;xPos++) {
					var neighborGroups:Array/*int*/ = [];					
					for (var deltaX:int=-1; deltaX<=1; deltaX++)
						for (var deltaY:int=-1; deltaY<=1; deltaY++) {
							var newX:int = xPos+deltaX;
							var newY:int = yPos+deltaY;
							if (!isInBoard(newX,newY)) continue;
							neighborGroup = sortedBoard[newX][newY];
							if (neighborGroup != -1)
							{
								if (neighborGroups.indexOf(neighborGroup)==-1) 
									neighborGroups.push(neighborGroup); 
							}
						}
						
					for each(neighborGroup in neighborGroups)
					{						
						blankBoxArr = id2blankBoxArr[neighborGroup];
						if (blankBoxArr==null) {
							blankBoxArr = new Array();
							id2blankBoxArr[neighborGroup] = blankBoxArr;						
						}
						blankBoxArr.push(ServerBox.create(false,sortBoard[xPos][yPos],xPos,yPos));	
					}			
				} 
			
			
			blankBoxArrays = [];
			for (var id:String in id2blankBoxArr)
			{
				index2id.push(id)
				blankBoxArrays.push( id2blankBoxArr[id] );
			}

				
		}
		public function isInBoard(x:int, y:int):Boolean {
			return x>=0 && x<width && y>=0 && y<height;
		}
		public function getId(index:int):int
		{
			return index2id[index];
		}
		public function getBrick(xPos:int,yPos:int):int
		{
			return sortedBoard[xPos][yPos];
		}
		private function calcOne(linkBoard:Array, xMod:int,yMod:int):void
		{
			var p:Group = linkBoard[xPos + xMod][yPos + yMod];
			if (p==null) return;
			p.union(linkBoard[xPos][yPos]);			
		}
	}
}