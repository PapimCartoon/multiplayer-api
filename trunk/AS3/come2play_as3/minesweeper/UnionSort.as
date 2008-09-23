package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.JSON;
	
	public class UnionSort
	{
		// algorithm output
		public var blankBoxArrays:Array/*BlankBox[]*/;
		private var index2id:Array;
		private var linkBoard:Array;
		private var xPos:int;
		private var yPos:int;
		private var width:int,height:int; 
		public function UnionSort(sortBoard:Array, width:int,height:int)
		{
			this.width = width;
			this.height = height;
			linkBoard = new Array()
			for(xPos=0;xPos<width;xPos++) {
				linkBoard[xPos] = [];
				for(yPos=0;yPos<height;yPos++)
					if(sortBoard[xPos][yPos] == 0 )
						linkBoard[xPos][yPos]=new Group();
			}
				
				
			for(yPos=0;yPos<width;yPos++)
				for(xPos=0;xPos<height;xPos++)
				{
					if(sortBoard[xPos][yPos] == 0 )
					{
						
						if(xPos>0)
							if(sortBoard[xPos-1][yPos-1] == 0)
								calcOne(-1,-1);
								
						if(sortBoard[xPos][yPos-1] == 0)
							calcOne(0,-1);
							
						if(xPos<(width -1))
							if(sortBoard[xPos+1][yPos-1] == 0)
								calcOne(1,-1);
								
						if(xPos>0)
							if(sortBoard[xPos-1][yPos] == 0)
								calcOne(-1,0);

					}
				}
			var neighborGroup:Group	
			var id2blankBoxArr:Object = {};
			var blankBoxArr:Array;
			index2id = new Array();
			for(yPos=0;yPos<width;yPos++)
				for(xPos=0;xPos<height;xPos++) {
					var neighborGroups:Array/*Group*/ = [];					
					for (var deltaX:int=-1; deltaX<=1; deltaX++)
						for (var deltaY:int=-1; deltaY<=1; deltaY++) {
							var newX:int = xPos+deltaX;
							var newY:int = yPos+deltaY;
							if (!isInBoard(newX,newY)) continue;
							neighborGroup = linkBoard[newX][newY];
							if(neighborGroup != null)
							{
								neighborGroup = neighborGroup.findRoot();
								if (neighborGroups.indexOf(neighborGroup)==-1) 
									neighborGroups.push(neighborGroup); 
							}
						}
						
					for each(neighborGroup in neighborGroups)
					{						
						blankBoxArr = id2blankBoxArr[neighborGroup.id];
						if (blankBoxArr==null) {
							blankBoxArr = new Array();
							id2blankBoxArr[neighborGroup.id] = blankBoxArr;						
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
			var p:Group = linkBoard[xPos][yPos];
			return p.findRoot().id;
		}
		private function calcOne(xMod:int,yMod:int):void
		{
			var p:Group = linkBoard[xPos + xMod][yPos + yMod];
			p.union(linkBoard[xPos][yPos]);			
		}
	}
}