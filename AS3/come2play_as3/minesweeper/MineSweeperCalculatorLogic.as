package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.RandomGenerator;
	import come2play_as3.api.auto_generated.UserEntry;
	
	public class MineSweeperCalculatorLogic
	{
		static public function doesExist(newPos:Object,mineArray:Array/*Object*/):Boolean
		{
			for each (var oldMine:Object in mineArray)
			{
				if ((newPos.xPos == oldMine.xPos) && (newPos.yPos == oldMine.yPos))
					return true;
			}
			return false;
			
		}
		
		static public function createMineBoard(randomSeed:int,mineAmount:int,boardWidth:int,boardHeight:int):Array/*UserEntry*/
		{
			var randomSeedGenerator:RandomGenerator = new RandomGenerator(randomSeed);
			var mines:Array = new Array();
			//create mine positions
			while(mines.length < mineAmount)
			{
				var mineUncalculated:int = randomSeedGenerator.nextInRange(0, boardHeight * boardWidth);
				var newPos:Object = {xPos: int(mineUncalculated/boardWidth),yPos:(mineUncalculated%boardWidth)};
				if (!doesExist(newPos,mines))
					mines.push(newPos);
			}
			//initialize a blank board
			var newCalculatorBoard:Array = new Array();
			for(var i:int=0;i<boardWidth;i++)
			{
				newCalculatorBoard[i] = new Array();
				for(var j:int=0;j<boardHeight;j++)
					newCalculatorBoard[i][j]=0		
			}
			//put mines on board		
			for(i=0;i<boardWidth;i++)
				for(j=0;j<boardHeight;j++)
				{
					if(doesExist({xPos:i,yPos:j},mines))
					{
						newCalculatorBoard[i][j] = 10;
						newCalculatorBoard[i][j-1]++;
						newCalculatorBoard[i][j+1]++;
						if(i > 0)
						{
							newCalculatorBoard[i-1][j]++;
							newCalculatorBoard[i-1][j+1]++;
							newCalculatorBoard[i-1][j-1]++;
						}
						if((i+1) < boardWidth)
						{
							newCalculatorBoard[i+1][j]++;
							newCalculatorBoard[i+1][j+1]++;
							newCalculatorBoard[i+1][j-1]++;
						}
					}
				}
				
				
			var sort:UnionSort = new UnionSort(newCalculatorBoard,boardWidth,boardHeight);
			var userEntries:Array= new Array();
			var serverBox:ServerBox;	
			//find connected squares to each white square and create ServerEntries
			
			
			for(i=0;i<boardWidth;i++)
				for(j=0;j<boardHeight;j++)	
				{
					if(newCalculatorBoard[i][j] == 0)
						userEntries.push(UserEntry.create({xPos:i,yPos:j},{type:"deadSpace",id:sort.getBrick(i,j)},true));
					else
					{
						serverBox = ServerBox.create((newCalculatorBoard[i][j] > 9),newCalculatorBoard[i][j],i,j)
						userEntries.push(UserEntry.create({xPos:i,yPos:j},serverBox,true));
					}			
				}
				var deadSpaceGrpoups:Array = sort.blankBoxArrays;
				for(i=0;i<deadSpaceGrpoups.length;i++)
				{
					userEntries.push(UserEntry.create({type:"deadSpace",id:sort.getId(i)},deadSpaceGrpoups[i],true));
				}
				return userEntries;
		}

	}
}