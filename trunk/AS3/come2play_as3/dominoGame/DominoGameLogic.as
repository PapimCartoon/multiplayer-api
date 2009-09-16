package come2play_as3.dominoGame
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.JSON;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.dominoGame.LogicClasses.MiddleBoard;
	import come2play_as3.dominoGame.events.GrabEvent;
	import come2play_as3.dominoGame.events.WinnerEvent;
	import come2play_as3.dominoGame.serverClasses.DominoComputerDraw;
	import come2play_as3.dominoGame.serverClasses.DominoComputerMove;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	import come2play_as3.dominoGame.serverClasses.DominoMove;
	import come2play_as3.dominoGame.serverClasses.DominoPass;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class DominoGameLogic extends EventDispatcher
	{	
		private var moveNum:int;
		private var opponentsBrickAvailable:Array/*Dictonary*/
		private var openBricks:Dictionary
		private var myHandBricks:Dictionary
		private var computerBricks:Dictionary
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
		private function returnDomino(dic:Dictionary,key:String):DominoCube{
			StaticFunctions.assert(dic[key]!=null,"can't put a non existing brick",key);
			return dic[key] as DominoCube
		}
		
		public function declareWinner(serverEntries:Array):void{
			var serverDic:Dictionary = new Dictionary()
			for each(var severEntry:ServerEntry in serverEntries){
				serverDic[JSON.stringify(severEntry.key)] = severEntry.value as DominoCube
			}
			var opponentDic:Dictionary = opponentsBrickAvailable[0]
			var myScore:int = 0 
			var opponentScore:int = 0 
			for(var key:String in opponentDic){
				var cube:DominoCube = returnDomino(serverDic,key);
				dominoGraphic.rivalShow(key,cube);
				opponentScore+=cube.value();
			}
			for(key in myHandBricks){
			 	cube = returnDomino(serverDic,key);
			 	dominoGraphic.myShow(key,cube);
			 	myScore+=cube.value();
			}
			if(myScore > opponentScore){
				dispatchEvent(new WinnerEvent(rivalUserIds[0]))
			}else if(myScore<opponentScore){
				dispatchEvent(new WinnerEvent(myUserId))
			}else{
				dispatchEvent(new WinnerEvent(-10))
			}
			
		}
		
		public function dominoToReveal():Array{
			if(opponentsBrickAvailable.length >1)	return [];
			var revealArr:Array = new Array()
			var opponentDic:Dictionary = opponentsBrickAvailable[0]
			for(var key:String in opponentDic){
				revealArr.push(JSON.parse(key))
			}
			for(key in myHandBricks){
				revealArr.push(JSON.parse(key))
			}
			var revealEntries:Array = []
			revealArr.sortOn("brickNum")
			for each(var keyObject:Object in revealArr){
				revealEntries.push(RevealEntry.create(keyObject,null))
			}
			return revealEntries;
		}
		public function startGame(myUserId:int,rivalUserIds:Array):void{			
			moveNum = 0;
			myHandBricks = new Dictionary()
			computerBricks = new Dictionary()
			openBricks = new Dictionary()
			opponentsBrickAvailable = []
			for each(var id:int in rivalUserIds){
				opponentsBrickAvailable.push(new Dictionary());
			}	
			this.myUserId = myUserId;
			this.rivalUserIds = rivalUserIds;
			dominoAmount = (DominoGameMain.dominoMax +1)*(DominoGameMain.dominoMax+2)/2 
			middleBoardLogic = new MiddleBoard()
			dominoGraphic.startGraphic(dominoAmount,rivalUserIds.length == 2)
		}
		public function takeDominoBrick(serverEntry:ServerEntry,forceRival:Boolean=false):void{
			var key:String = JSON.stringify(serverEntry.key)
			if(serverEntry.visibleToUserIds == null){
				openBricks[key] = serverEntry.value as DominoCube
				return;
			}else if((serverEntry.visibleToUserIds.indexOf(myUserId)!=-1) && (!forceRival)){
				takeBrick(serverEntry.value as DominoCube,key)
			}else{
				if( (DominoGameMain.isSinglePlayer)&&(serverEntry.visibleToUserIds.indexOf(myUserId)!=-1)){
					computerBricks[key] = serverEntry.value as DominoCube;
					takeOpponentBrick(key,0);
				}else{
					for(var i:int=0;i<rivalUserIds.length;i++){
						if( serverEntry.visibleToUserIds.indexOf(rivalUserIds[i])!=-1){
							takeOpponentBrick(key,i);
						}
					}
				}		
			}
		}
		
		//add a brick to your hand
		private function takeBrick(domino:DominoCube,key:String):void{
			myHandBricks[key] = domino;
			dominoGraphic.draw(domino,key)
				
		}
		//add a brick to your rival hand
		private function takeOpponentBrick(key:String,rivalNum:int):void{
			opponentsBrickAvailable[rivalNum][key] = 1
			dominoGraphic.rivalDraw(key,rivalNum);
		}

		private function findBiggestBlockKey(dic:Dictionary):String{
			var oldDominoKey:String = null;
			var newDomino:DominoCube;
			var oldDomino:DominoCube;		
			for(var key:String in  dic){
				newDomino = dic[key];
				if(oldDomino == null){
					oldDominoKey = key;
					oldDomino = newDomino;
				}else if(newDomino.isDouble() && oldDomino.isDouble()){
					if(newDomino.up>oldDomino.up){
						oldDominoKey = key;
						oldDomino = newDomino;
					} 
				}else if(newDomino.isDouble() && (!oldDomino.isDouble())){
					oldDominoKey = key;
					oldDomino = newDomino;
				}else if((!newDomino.isDouble()) && (!oldDomino.isDouble())){
					if(newDomino.value()>oldDomino.value()){
						oldDominoKey = key;
						oldDomino = newDomino;
					}	 
				}
			}	
			
			return oldDominoKey;
		}
		private function userChoseBrick(ev:GrabEvent):void{
			var dominoMove:DominoMove = DominoMove.create(myUserId,ev.brick.key,ev.brick.isConnectedToRight,ev.brick.brickOrientation,moveNum);
			dispatchEvent(dominoMove)
		}
		public function madeMove():void{
			moveNum++
		}
		public function getMoveNum():int{
			return moveNum;
		}
		private function deleteFromDic(dic:Dictionary,key:String):void{
			StaticFunctions.assert(dic[key]!=null || openBricks[key]!=null,"can't put a non existing brick");
			delete dic[key]
		}
		
		
		public function putBrick(dominoMove:DominoMove,dominoCube:DominoCube,isLoad:Boolean=false):void{
			var isMine:Boolean = (DominoGameMain.isSinglePlayer?(!(dominoMove is DominoComputerMove)):(dominoMove.playerId == myUserId))
			if(isMine){
				deleteFromDic(myHandBricks,dominoMove.key)
			}else{	
				deleteFromDic(opponentsBrickAvailable[DominoGameMain.isSinglePlayer?0:rivalUserIds.indexOf(dominoMove.playerId)],dominoMove.key)
			}	
			if(middleBoardLogic.canAddCenter()){
				middleBoardLogic.addCenter(dominoCube)	
			}else if(dominoMove.connectToRight){
				middleBoardLogic.addRight(dominoCube)
			}else{
				middleBoardLogic.addLeft(dominoCube)
				
			}
			searchWinner()
			var putWhere:int = -1
			for(var i:int=0;i<rivalUserIds.length;i++){
				if(rivalUserIds[i] == dominoMove.playerId)	putWhere=i;
			}
			if((!isMine) && (DominoGameMain.isSinglePlayer))	putWhere = 0
			dominoGraphic.putBrick(dominoMove,dominoCube,putWhere,isLoad);
			
		}
		private function searchWinner():void{
			if(AS3_vs_AS2.dictionarySize(myHandBricks) == 0){
				dispatchEvent(new WinnerEvent(myUserId))
			}else{
				for(var i:int=0;i<opponentsBrickAvailable.length;i++){
					if(AS3_vs_AS2.dictionarySize(opponentsBrickAvailable[i]) == 0){
						dispatchEvent(new WinnerEvent(rivalUserIds[i]))
						return;
					}
				}	
			}
		}
		
		private function getAvailableComputerMove():DominoComputerMove{
			var dominoComputerMove:DominoComputerMove
			for(var key:String in computerBricks){
				var dominoCube:DominoCube = computerBricks[key];
				if(MiddleBoard.canAddLeft(dominoCube)){
					delete computerBricks[key]
					dominoComputerMove =DominoComputerMove.create(DominoMove.create(myUserId,key,false,Math.random()*4,moveNum));
					return dominoComputerMove;
				}else if(MiddleBoard.canAddRight(dominoCube)){
					delete computerBricks[key]
					dominoComputerMove =DominoComputerMove.create(DominoMove.create(myUserId,key,true,Math.random()*4,moveNum));
					return dominoComputerMove;
				}
			}
			return null;
		}
		
		public function makeComputerMove():void{
			var dominoComputerMove:DominoComputerMove = getAvailableComputerMove()
			if(dominoComputerMove==null){
				if(dominoGraphic.isNoMoreDomino() || (AS3_vs_AS2.dictionarySize(computerBricks)>=DominoGameMain.dominoMaxHand)){
					dispatchEvent(DominoPass.create())
				}else{
					dispatchEvent(DominoComputerDraw.create())
				}
				return
			}
			dispatchEvent(dominoComputerMove)
		}
		public function setTurn(userTurn:int):void{
			var key:String;
			if(userTurn!=myUserId){
				dominoGraphic.disableButtons(false,rivalUserIds.indexOf(userTurn))	
				if(DominoGameMain.isSinglePlayer){
					if(middleBoardLogic.canAddCenter()){//auto make move
						key = findBiggestBlockKey(computerBricks)
						var dominoComputerMove:DominoComputerMove=DominoComputerMove.create(DominoMove.create(myUserId,key,false,0,moveNum));
						delete computerBricks[key]
						dispatchEvent(dominoComputerMove)
					}else{//make computer move
						makeComputerMove()
					}
				}
				return
			}
			dominoGraphic.disableButtons(true,rivalUserIds.indexOf(userTurn))
			if(middleBoardLogic.canAddCenter()){//auto make move
				key = findBiggestBlockKey(myHandBricks)
				var dominoMove:DominoMove = DominoMove.create(myUserId,key,false,0,moveNum);
				dispatchEvent(dominoMove)
			}else{//allow making a move
				dominoGraphic.allowMove()
			}
		}

	}
}