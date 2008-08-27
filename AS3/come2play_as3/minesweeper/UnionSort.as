package come2play_as3.minesweeper
{
	public class UnionSort
	{
		private var linkBoard:Array;
		public var groupArrays:Array;
		private var idArray:Array;
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
					if(sortBoard[xPos][yPos] < 9)
						linkBoard[xPos][yPos]=new Group();
			}
				
			for(yPos=0;yPos<width;yPos++)
				for(xPos=0;xPos<height;xPos++)
				{
					if(sortBoard[xPos][yPos] == 0 )
					{
						
						if(xPos>0)
							if(sortBoard[xPos-1][yPos-1] < 9)
								calcOne(-1,-1);
								
						if(sortBoard[xPos][yPos-1] < 9)
							calcOne(0,-1);
							
						if(xPos<(width -1))
							if(sortBoard[xPos+1][yPos-1] < 9)
								calcOne(1,-1);
								
						if(xPos>0)
							if(sortBoard[xPos-1][yPos] < 9)
								calcOne(-1,0);

					}
				}
				
		
			groupArrays= new Array();
			idArray= new Array()
			for(yPos=0;yPos<width;yPos++)
				for(xPos=0;xPos<height;xPos++)
					if(sortBoard[xPos][yPos] < 9)
					{
						var wasFound:Boolean = false;
						var p:Group = linkBoard[xPos][yPos];
						for(var i:int = 0;i<idArray.length;i++)
							if(idArray[i] == p.findRoot().id)
							{
								groupArrays[i].push({xPos:xPos ,yPos:yPos, bordering:sortBoard[xPos][yPos]})
								wasFound=true;
							}
						if(!wasFound)	
						{
							groupArrays.push([{xPos:xPos ,yPos:yPos, bordering:sortBoard[xPos][yPos]}]);
							idArray.push(p.findRoot().id);
						}

					}
					
					
					
			//var group:Group;	
			//var neighborGroup:Group	
			//var allGroups:Array/*Group*/ = [];
			/*for(yPos=0;yPos<width;yPos++)
				for(xPos=0;xPos<height;xPos++) 
					if(sortBoard[xPos][yPos] ==0 ) {
						group = linkBoard[xPos][yPos];
						group = group.findRoot();
						if (allGroups.indexOf(group)==-1) allGroups.push(group);
						*/
						//var neighborGroups:Array/*Group*/ = [];
						/*for (var deltaX:int=-1; deltaX<=1; deltaX++)
							for (var deltaY:int=-1; deltaY<=1; deltaY++) {
								var newX:int = xPos+deltaX;
								var newY:int = yPos+deltaY;
								if (!isInBoard(newX,newY)) continue;
								neighborGroup = linkBoard[newX][newY];
								neighborGroup = neighborGroup.findRoot();
								if (neighborGroups.indexOf(neighborGroup)==-1) 
									neighborGroups.push(neighborGroup);
							}
							neighborGroup.allCells = new Array();
						for each(neighborGroup in neighborGroups)
							neighborGroup.allCells.push({xPos:xPos,yPos:yPos});							
					}
			
			trace("All groups:");
			for each (group in allGroups)
				trace("Group id="+group.id+" allCells="+group.allCells);
				*/
		}
		public function isInBoard(x:int, y:int):Boolean {
			return x>=0 && x<width && y>=0 && y<height;
		}
		public function getId(index:int):int
		{
			return idArray[index];
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

class Group {
	//var allCells:Array = null;
	public var group:Group = null;
	public var size:int = 1;
	public static var groupId:int = 0;
	public var id:int = groupId++;
	
	public function findRoot():Group { // find
		var p:Group = this;
		if (p.group!=null) {
			while (p.group!=null) p = p.group;
			this.group = p;
		}
		return p;
	}
	public function union(other:Group):void {
		var otherRoot:Group = other.findRoot();
		var myRoot:Group = findRoot();
		var otherSize:int = otherRoot.size;
		
		if (myRoot!=otherRoot) {
			var isMeSmaller:Boolean = size<otherSize;
			var smallerGroup:Group = isMeSmaller ? myRoot : otherRoot;
			var biggerGroup:Group = isMeSmaller ? otherRoot : myRoot;
			smallerGroup.group = biggerGroup;
			biggerGroup.size += smallerGroup.size;
		}
	}
}