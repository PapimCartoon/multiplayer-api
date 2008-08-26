package come2play_as3.minesweeper
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
	public class MineSweeper_Main extends ClientGameAPI
	{
		private static var boardHeight:int=5;
		private static var boardWidth:int=5;
		private static var mineAmount:int=2;
		//calculator variables
		private var emptyBoxes:Array;
		private var newCalculatorBoard:Array
		
		private var startGraphic:Starter;
		private var mineSweeper_Logic:MineSweeper_Logic;
		private var myUserId:int;
		private var users:Array;
	/** 
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function MineSweeper_Main(graphics:MovieClip)
		{
			super(graphics);
			users = new Array(); 
			mineSweeper_Logic  = new MineSweeper_Logic(this,graphics,boardWidth,boardHeight);
			startGraphic= new Starter()
			startGraphic.x=170;
			startGraphic.y=160;
			startGraphic.stop();
			graphics.addChild(startGraphic);
			startGraphic.addEventListener("starterEnd",startGame);
			setTimeout(doRegisterOnServer,100);
		}
		private function startGame(ev:Event)
		{
			mineSweeper_Logic.buildBoard(users);
		}
		public function doesExist(pos:Object,arr:Array):Boolean
		{
			for each(var arrPos:Object in arr)
			{
				if((arrPos.xPos == pos.xPos) && (arrPos.yPos == pos.yPos))
					return true;
			}
			return false;
		}
		private function getEmptyBoxes(pos:Object):void
		{
			if(newCalculatorBoard[pos.xPos][pos.yPos] == 0)
				if(!doesExist(pos,emptyBoxes))
				{
					emptyBoxes.push(pos);
					if ((pos.xPos+1) < boardWidth)
					{
						getEmptyBoxes({xPos:pos.xPos+1 ,yPos:pos.yPos+1})
						getEmptyBoxes({xPos:pos.xPos+1 ,yPos:pos.yPos})
						getEmptyBoxes({xPos:pos.xPos+1 ,yPos:pos.yPos-1})
					}
					getEmptyBoxes({xPos:pos.xPos ,yPos:pos.yPos+1})
					getEmptyBoxes({xPos:pos.xPos ,yPos:pos.yPos-1})
					if(pos.xPos > 0)
					{
						getEmptyBoxes({xPos:pos.xPos-1 ,yPos:pos.yPos+1})
						getEmptyBoxes({xPos:pos.xPos-1 ,yPos:pos.yPos})
						getEmptyBoxes({xPos:pos.xPos-1 ,yPos:pos.yPos-1})
					}
				}
			
		}
		private function isGrouped(pos:Object,arr:Array):int
		{
			var len:int=arr.length;
			for(var i:int=0 ;i<len;i++)
			{
				if(doesExist(pos,arr[i]))
					return i;
			}
			return -1;
		}
		public function pressMine(xPos:int,yPos:int,isMine:Boolean):void
		{
			var playerMove:PlayerMove = new PlayerMove();
			playerMove.isMine = isMine;
			playerMove.takingPlayer = myUserId;
			playerMove.xPos = xPos;
			playerMove.yPos = yPos;
			doStoreState([UserEntry.create(myUserId+"_"+xPos+"_"+ yPos,playerMove,false)]);
		}
		
		//override functions
		
		override public function gotCustomInfo(infoEntries:Array):void
		{
				
		}
		override public function gotRequestStateCalculation(serverEntries:Array):void
		{
		
			var serverEntry:ServerEntry = serverEntries[0];
			var randomSeed:int = serverEntry.value + Math.random()*100;
			var mines:Array = new Array();
			var place:int = 1;
			//create mine positions
			while(mines.length < mineAmount)
			{
				var mineUncalculated:int = (randomSeed * place) %(boardHeight * boardWidth);
				var newPos:Object = {xPos: int(mineUncalculated/boardWidth),yPos:(mineUncalculated%boardWidth)};
				if (!doesExist(newPos,mines))
					mines.push(newPos);
				place++;
			}
			//initialize a blank board
			newCalculatorBoard= new Array();
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
				
			//find connected squares to each white square and create ServerEntries
			var deadSpace:Array = new Array();
			var userEntries:Array= new Array();
			for(i=0;i<boardWidth;i++)
				for(j=0;j<boardHeight;j++)	
				{
					var serverBox:ServerBox = new ServerBox();
					serverBox.xPos = i ;
					serverBox.yPos = j ;
					if(newCalculatorBoard[i][j]>9)
					{
						serverBox.isMine = true;
						userEntries.push(UserEntry.create(i+"_"+j,serverBox,true));
					}
					else if((newCalculatorBoard[i][j]!=0))
					{
						serverBox.isMine = false;
						serverBox.borderingMines =newCalculatorBoard[i][j];
						userEntries.push(UserEntry.create(i+"_"+j,serverBox,true));
					}
					
					if(newCalculatorBoard[i][j] == 0)
					{
						var isGroup:int = isGrouped({xPos:i , yPos:j},deadSpace)
						if(isGroup == -1)
						{
							emptyBoxes = new Array();
							getEmptyBoxes({xPos:i , yPos:j});
							deadSpace.push(emptyBoxes);
							isGroup =deadSpace.length;
						}
						//serverBox.borderingMines = 0;
						//userEntries.push(UserEntry.create(i+"_"+j,serverBox,true));
						userEntries.push(UserEntry.create(i+"_"+j,"deadSpace_"+isGroup,true)); 
					}
					
				}
				for(i=0;i<deadSpace.length;i++)
					userEntries.push(UserEntry.create("deadSpace_"+i,deadSpace[i],true));
				doAllStoreStateCalculation(userEntries);
				
			
		}
		override public function gotMyUserId(myUserId:int):void
		{
			this.myUserId = myUserId;
			mineSweeper_Logic.myUserId = myUserId;
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			users.push({userId:userId,entries:entries});
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
		{
			
			
			if(serverEntries.length == 0)
			{
				doAllRequestRandomState("randomSeed",true);
				doAllRequestStateCalculation(["randomSeed"]);
			}
			else
			{
				//load game or viewer
				startGraphic.play();
			}
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0]
			
			trace(JSON.stringify(serverEntries));
				
			if(serverEntries.length > boardHeight * boardWidth)
			{
				//got calculations made by calculator	
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				startGraphic.play();
			}
			else if(serverEntry.value is PlayerMove)
			{
				var playerMove:PlayerMove = serverEntry.value as PlayerMove;
				if(playerMove.takingPlayer != serverEntry.storedByUserId) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data for another user")
				if(!mineSweeper_Logic.isMoveTaken(playerMove))					
					doAllRevealState([RevealEntry.create(playerMove.xPos+"_"+playerMove.yPos,null,2)]);	
				if(myUserId == playerMove.takingPlayer)
					doStoreState([UserEntry.create(playerMove.takingPlayer+"_"+playerMove.xPos+"_"+playerMove.yPos,null,false)]);
			}
			else if(serverEntry.value is ServerBox)
			{
				var serverBox:ServerBox = serverEntry.value as ServerBox;
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");
				var tempPlayerBox:PlayerBox = mineSweeper_Logic.addBoxesServer(serverBox);
				doAllStoreState([UserEntry.create(tempPlayerBox.xPos+"_"+tempPlayerBox.yPos,tempPlayerBox,false)]);
			}
			else if(serverEntry.value is Array)
			{
				var blankSquares:Array = serverEntry.value as Array;
				if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,serverEntry.storedByUserId+" stored the data and not the calculator");	
				var userEntries:Array= mineSweeper_Logic.addBlankBoxesServer(blankSquares);
				doAllStoreState(userEntries);
			}
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			
		}
	}
}