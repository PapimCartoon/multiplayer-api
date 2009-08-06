package come2play_as3.dominoGame
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.dominoGame.LogicClasses.MiddleBoard;
	import come2play_as3.dominoGame.events.GrabEvent;
	import come2play_as3.dominoGame.events.WinnerEvent;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	import come2play_as3.dominoGame.serverClasses.DominoMove;
	
	import flash.events.EventDispatcher;
	
	public class DominoGameLogic extends EventDispatcher
	{	
		private var moveNum:int;
		private var opponentsBrickCount:Array/*int*/
		private var myBrickCount:int
		private var myHandCubes:Array
		private var myHandKeys:Array
		private var middleBoardLogic:MiddleBoard
		private var dominoGraphic:DominoGameGraphic
		private var myUserId:int
		private var rivalUserIds:Array/*int*/
		public var dominoAmount:int
		
		public function DominoGameLogic(dominoGraphic:DominoGameGraphic)
		{
			this.dominoGraphic = dominoGraphic;
			AS3_vs_AS2.myAddEventListener("dominoGraphic",dominoGraphic,GrabEvent.PUT_BRICK,userChoseBrick)
		}
		public function startGame(myUserId:int,rivalUserIds:Array):void{
			myBrickCount = 0
			opponentsBrickCount = [];
			for each(var id:int in rivalUserIds){
				opponentsBrickCount.push(0);
			}	
			this.myUserId = myUserId;
			this.rivalUserIds = rivalUserIds;
			moveNum = 0;
			myHandKeys = [];
			myHandCubes = [];
			dominoAmount = (DominoGameMain.dominoMax +1)*(DominoGameMain.dominoMax+2)/2 
			middleBoardLogic = new MiddleBoard()
			dominoGraphic.startGraphic(dominoAmount,rivalUserIds.length == 2)
		}
		public function takeDominoBrick(serverEntry:ServerEntry):void{
			if(serverEntry.visibleToUserIds.indexOf(myUserId)!=-1){
				takeBrick(serverEntry.value as DominoCube,serverEntry.key)
			}else{
				for(var i:int=0;i<rivalUserIds.length;i++){
					if(serverEntry.visibleToUserIds.indexOf(rivalUserIds[i])!=-1){
						takeOpponentBrick(serverEntry.key,i);
						return;
					}
				}
				
			}
			
			
		}
		
		//add a brick to your hand
		public function takeBrick(domino:DominoCube,key:Object):void{
			myBrickCount++;
			myHandCubes.push(domino);
			myHandKeys.push(key);
			dominoGraphic.draw(domino,key)
				
		}
		//add a brick to your rival hand
		public function takeOpponentBrick(key:Object,rivalNum:int):void{
			opponentsBrickCount[rivalNum]++;
			dominoGraphic.rivalDraw(key,rivalNum);
		}
		private function findBiggestBlock():int{
			var index:int
			var len:int = myHandCubes.length;
			var oldDomino:DominoCube = myHandCubes[0];
			var newDomino:DominoCube;
			for(var i:int=0;i<len;i++){
				newDomino = myHandCubes[i];
				if(newDomino.isDouble() && oldDomino.isDouble()){
					if(newDomino.up>oldDomino.up){
						oldDomino = newDomino;
						index = i;
					} 
				}else if(newDomino.isDouble() && (!oldDomino.isDouble())){
					oldDomino = newDomino;
					index = i;
				}else if((!newDomino.isDouble()) && (!oldDomino.isDouble())){
					if(newDomino.value()>oldDomino.value()){
						oldDomino = newDomino;
						index = i;
					}	 
				}
			}	
			
			return index;
		}
		private function userChoseBrick(ev:GrabEvent):void{
			var dominoMove:DominoMove = DominoMove.create(myUserId,ev.brick.key,ev.brick.dominoCube,ev.brick.isConnectedToRight,ev.brick.brickOrientation,moveNum++);
			dispatchEvent(dominoMove)
		}
		
		public function getMoveNum():int{
			return moveNum++;
		}
		
		public function putBrick(dominoMove:DominoMove):void{
			var isMine:Boolean = (dominoMove.playerId == myUserId)
			if(isMine){
				myBrickCount--
			}else{	
				opponentsBrickCount[rivalUserIds.indexOf(dominoMove.playerId)]--;
			}	
			if(middleBoardLogic.canAddCenter()){
				middleBoardLogic.addCenter(dominoMove.dominoCube)	
			}else if(dominoMove.connectToRight){
				middleBoardLogic.addRight(dominoMove.dominoCube)
			}else{
				middleBoardLogic.addLeft(dominoMove.dominoCube)
				
			}
			searchWinner()
			var putWhere:int = -1
			for(var i:int=0;i<rivalUserIds.length;i++){
				if(rivalUserIds[i] == dominoMove.playerId)	putWhere=i;
			}
		
			
			dominoGraphic.putBrick(dominoMove,putWhere);
			
		}
		private function searchWinner():void{
			if(myBrickCount == 0){
				dispatchEvent(new WinnerEvent(myUserId))
			}else{
				for(var i:int=0;i<opponentsBrickCount.length;i++){
					if(opponentsBrickCount[i] == 0){
						dispatchEvent(new WinnerEvent(rivalUserIds[i]))
						return;
					}
				}	
			}
		}
		
		public function setTurn(userTurn:int):void{
			if(userTurn!=myUserId){
				dominoGraphic.disableButtons(true,rivalUserIds.indexOf(userTurn))
				return
			}
			dominoGraphic.disableButtons(false,rivalUserIds.indexOf(userTurn))
			var cube:DominoCube;
			if(middleBoardLogic.canAddCenter()){//auto make move
				var index:int = findBiggestBlock()
				var key:Object = myHandKeys.splice(index,1).pop()
				cube = myHandCubes.splice(index,1).pop()	
				var dominoMove:DominoMove = DominoMove.create(myUserId,key,cube,false,0,moveNum++);
				dispatchEvent(dominoMove)
			}else{//allow making a move
				dominoGraphic.allowMove()
			}
		}

	}
}