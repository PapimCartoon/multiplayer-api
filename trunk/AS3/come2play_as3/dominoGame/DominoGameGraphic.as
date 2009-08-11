package come2play_as3.dominoGame
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.cards.events.AnimationEndedEvent;
	import come2play_as3.dominoGame.events.AnimationEvent;
	import come2play_as3.dominoGame.events.DrawEvent;
	import come2play_as3.dominoGame.events.GrabEvent;
	import come2play_as3.dominoGame.graphicClasses.DominoBrickGraphic;
	import come2play_as3.dominoGame.graphicClasses.DominoButton;
	import come2play_as3.dominoGame.graphicClasses.HandGraphic;
	import come2play_as3.dominoGame.graphicClasses.MiddleBoardGraphic;
	import come2play_as3.dominoGame.graphicClasses.MyHelpClip;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	import come2play_as3.dominoGame.serverClasses.DominoDraw;
	import come2play_as3.dominoGame.serverClasses.DominoMove;
	import come2play_as3.dominoGame.serverClasses.DominoPass;
	import come2play_as3.dominoGame.usefullFunctions.Tools;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	public class DominoGameGraphic extends Sprite
	{
		private var canGrab:Boolean
		private var helpScreen:MyHelpClip
		private var middleGraphic:MiddleBoardGraphic
		private var myHand:HandGraphic
		private var rivalHand:HandGraphic
		private var pileGraphic:DominoBrickGraphic
		private var dominoBack:GameBackground;
		private var currentDominoAmount:int
		
		private var dominoDraw:DominoButton
		private var dominoPass:DominoButton
		private var waitingScreen:WaitingFLV = new WaitingFLV();
		private var isViewer:Boolean
		public function DominoGameGraphic()
		{		
			var allWidth:int = T.custom(API_Message.CUSTOM_INFO_KEY_gameWidth,400) as int
			var allHeight:int = T.custom(API_Message.CUSTOM_INFO_KEY_gameHeight,400) as int
			waitingScreen.mouseEnabled = waitingScreen.mouseChildren = false;
			waitingScreen.x = allWidth - (waitingScreen.width + 70);
			waitingScreen.y = allWidth - (waitingScreen.height + 70)
			helpScreen = new MyHelpClip()
			dominoBack = new GameBackground()
			middleGraphic = new MiddleBoardGraphic()
			
			helpScreen.x = (allWidth - helpScreen.width)/2
			helpScreen.y = (allHeight - helpScreen.height)/2
			addChild(dominoBack);
			dominoDraw = new DominoButton(dominoBack.drawButton1,drawDomino)
			dominoPass = new DominoButton(dominoBack.passButton1,passTurn)
			pileGraphic = new DominoBrickGraphic(null,null)
			pileGraphic.x = dominoBack.pile1.x + 23
			pileGraphic.y = dominoBack.pile1.y + 25
			dominoBack.addChild(pileGraphic)
			myHand = new HandGraphic(330,pileGraphic.x,pileGraphic.y)
			rivalHand = new HandGraphic(5,pileGraphic.x,pileGraphic.y)
			
			AS3_vs_AS2.myAddEventListener("myHand",myHand,DrawEvent.DRAW_EVENT,takeDominoFromDeck)
			AS3_vs_AS2.myAddEventListener("rivalHand",rivalHand,DrawEvent.DRAW_EVENT,takeDominoFromDeck)
			
			AS3_vs_AS2.myAddEventListener("myHand",myHand,GrabEvent.GRAB_BRICK,grabBrick)
			AS3_vs_AS2.myAddEventListener("myHand",myHand,GrabEvent.LEAVE_BRICK,leaveBrick)
			
			dominoBack.table1.holder_mc.addChild(middleGraphic);
			
			
			AS3_vs_AS2.myAddEventListener("helpListener",dominoBack.helpBtn,MouseEvent.CLICK,showHelp)
			AS3_vs_AS2.myAddEventListener("tableListener",dominoBack.table1,MouseEvent.MOUSE_UP,stopTableDrag)
			AS3_vs_AS2.myAddEventListener("tableListener",dominoBack.table1,MouseEvent.MOUSE_DOWN,startTableDrag)
			
			AS3_vs_AS2.myAddEventListener("navButtonRight",dominoBack.navButtonRight,MouseEvent.CLICK,navRight)
			AS3_vs_AS2.myAddEventListener("navButtonLeft",dominoBack.navButtonLeft,MouseEvent.CLICK,navLeft)
			AS3_vs_AS2.myAddEventListener("navButtonDown",dominoBack.navButtonDown,MouseEvent.CLICK,navDown)
			AS3_vs_AS2.myAddEventListener("navButtonUp",dominoBack.navButtonUp,MouseEvent.CLICK,navUp)
			
			addChild(rivalHand)
			addChild(myHand)
			width = allWidth * DominoGameMain.myWidthMod;
			height = allHeight* DominoGameMain.myHeightMod;
		}
		private function navRight(ev:MouseEvent):void{
			middleGraphic.x+=10
		}
		private function navLeft(ev:MouseEvent):void{
			middleGraphic.x-=10
		}
		private function navDown(ev:MouseEvent):void{
			middleGraphic.y+=10
		}
		private function navUp(ev:MouseEvent):void{
			middleGraphic.y-=10
		}
		private function showHelp(ev:MouseEvent):void{
			addChild(helpScreen)
		}
		public function gameEnded():void{
			 brickPosed = canGrab = false;
			leaveBrick()
			filters = []
			if(waitingScreen.parent!=null)	waitingScreen.parent.removeChild(waitingScreen);
			dominoPass.enabled = false;
			dominoDraw.enabled = false;
		}
		private var isMyTurn:Boolean
		public function disableButtons(isMyTurn:Boolean,turn:int):void{
			dominoDraw.enabled = false;
			dominoPass.enabled = false
			this.isMyTurn = isMyTurn
			if(isMyTurn){
				dominoBack.turnIndicator1.gotoAndStop(1)
				filters = []
				if(waitingScreen.parent!=null)	waitingScreen.parent.removeChild(waitingScreen);
				tryEnableDraw()
				tryEnablePass()
			}else{
				if(isViewer){
					dominoBack.turnIndicator1.gotoAndStop(3+turn)	
				}else{
					dominoBack.turnIndicator1.gotoAndStop(2)
					filters = [createSaturationFilter(20)]
					addChild(waitingScreen)
				}
			}
		}
		private function tryEnableDraw():void{
			dominoDraw.enabled = ((currentDominoAmount>0) && (!didReachMaxHand()) && isMyTurn);
		}
		private function tryEnablePass():void{
			dominoPass.enabled = (!hasMoves() && (!dominoDraw.enabled))
		}
		private function hasMoves():Boolean{
			if(isViewer)	return false;
			return myHand.hasMoves();
		}
		public function isNoMoreDomino():Boolean{
			return (currentDominoAmount==0)
		}
		
		public function drawDomino(ev:MouseEvent):void{
			dispatchEvent(DominoDraw.create())
			tryEnableDraw()
		}

		public function didReachMaxHand():Boolean{
			return ((myHand.dominoInHand + dominoesDelayed.length ) >= DominoGameMain.dominoMaxHand) 
		}
		

		
		public function passTurn(ev:MouseEvent):void{
			canGrab = false;
			dominoPass.enabled = false
			dispatchEvent(DominoPass.create())
		}
		public function startGraphic(currentDominoAmount:int,isViewer:Boolean):void{
			this.isViewer = isViewer
			dominoesDelayed = []
			waitingPutBricks = []
			middleGraphic.x = -dominoBack.table1.x
			middleGraphic.y = -dominoBack.table1.y
			canGrab = false;
			middleGraphic.clear()
			myHand.clear()
			rivalHand.clear();
			this.currentDominoAmount = currentDominoAmount;			
		}
		public function rivalShow(key:String,dominoCube:DominoCube):void{
			var dominoGraphic:DominoBrickGraphic = rivalHand.findBrick(key)
			dominoGraphic.show(dominoCube)
		}
		public function myShow(key:String,dominoCube:DominoCube):void{
			if(!isViewer)	return
			var dominoGraphic:DominoBrickGraphic = rivalHand.findBrick(key)
			dominoGraphic.show(dominoCube)
		}
		public function rivalDraw(key:String,rivalNum:int):void{
			if(rivalNum==0)
				rivalHand.draw(key)	
			else
				myHand.draw(key);
		}

		public function draw(dominoCube:DominoCube,key:String):void{
			for(var i:int =0;i<dominoesDelayed.length;i++){
				var waitingKey:String = dominoesDelayed[i]
				if(key == waitingKey){
					dominoesDelayed.splice(i,1);
					break;
				}
			}
			myHand.draw(key,dominoCube)	
		}
		private var waitingPutBricks:Array 
		public function tryPutBricks():void{
			if(waitingPutBricks.length == 0)	return;
			var obj:Object = waitingPutBricks.shift()
			putBrick(obj.dominoMove,obj.dominoCube,obj.putWhere,obj.isLoad)
		}
		public function putBrick(dominoMove:DominoMove,dominoCube:DominoCube,putWhere:int,isLoad:Boolean):void{
			if(myHand.isWithQueue || rivalHand.isWithQueue){
				waitingPutBricks.push({dominoMove:dominoMove,putWhere:putWhere,dominoCube:dominoCube,isLoad:isLoad})
				return;
			}
			var cube:DominoBrickGraphic
			if(putWhere==-1){
				cube = myHand.getBrick(dominoMove.key)
			}else if(putWhere==0){
				cube = rivalHand.getBrick(dominoMove.key)
			}else if(putWhere==1){
				cube = myHand.getBrick(dominoMove.key)	
			}
			cube.show(dominoCube)
			if(middleGraphic.canAddCenter()){
				middleGraphic.addCenter(cube)
			}else{
				middleGraphic.addBrick(cube,dominoMove,dominoCube)
			}
			tryPutBricks()
			
		}
		public var dominoesDelayed:Array
		public function takeDominoFromDeck(ev:DrawEvent):void{
			currentDominoAmount--;
			dominoBack.stockText1.text = "x "+currentDominoAmount;
			tryEnableDraw()
			tryEnablePass()
			if(ev.isFinish)	tryPutBricks()
		}

		
		public function startStageListening():void{
			AS3_vs_AS2.myAddEventListener("keyboard-stage",stage,MouseEvent.MOUSE_MOVE,mouseMoved)
			AS3_vs_AS2.myAddEventListener("keyboard-stage",stage,MouseEvent.CLICK,leaveBrick)		
		}
		private var grabbedBrick:DominoBrickGraphic
		private var brickPosed:Boolean
		
		private function stopTableDrag(ev:MouseEvent):void{
			middleGraphic.stopDrag()
		}
		private function startTableDrag(ev:MouseEvent):void{
			middleGraphic.startDrag(false);	
		}
		
		private function mouseMoved(ev:MouseEvent):void{	
			if(grabbedBrick!=null){
				var point:Point = Tools.localToGlobal(ev.target as DisplayObject,ev.localX,ev.localY)
				brickPosed = middleGraphic.checkHit(grabbedBrick,point)
				if(brickPosed)	return;		
				grabbedBrick.hasShadow(false)
				grabbedBrick.brickDirection(DominoBrickGraphic.UP)
				grabbedBrick.xPos = point.x/Tools.scaleX
				grabbedBrick.yPos = point.y/Tools.scaleY
			}
		}
		public function allowMove():void{
			canGrab = true;
		}
		
		private function grabBrick(ev:GrabEvent):void{
			if(canGrab)
				grabbedBrick = ev.brick;
		}
		private function leaveBrick(ev:Event = null):void{
			if(grabbedBrick==null)	return;
			if(brickPosed){
				brickPosed = canGrab = false;
				grabbedBrick.allowDrag(false);
				dispatchEvent(new GrabEvent(GrabEvent.PUT_BRICK,grabbedBrick));
			}else{
				grabbedBrick.brickDirection(DominoBrickGraphic.UP);
				grabbedBrick.returnBrick()
			}
			
			grabbedBrick = null;
		}
		private static const rConst:Number = 0.2225
		private static const gConst:Number = 0.7169 
		private static const bConst:Number = 0.0606
		
		private static const rMod:Number = 1 - rConst 
		private static const gMod:Number = 1 - gConst 
		private static const bMod:Number = 1 - bConst
		
		private function createSaturationFilter(saturation:int):ColorMatrixFilter{
			var matrix:Array = new Array();
			var num:Number = saturation*0.01
			var rLum:Number =rConst+ num*(rMod);
	        var gLum:Number =gConst+ num*(gMod);
	        var bLum:Number =bConst+ num*(bMod);  
           	matrix = matrix.concat([rLum, gLum -(gLum*num), bLum-(bLum*num), 0, 0]); // red
           	matrix = matrix.concat([rLum-(rLum*num), gLum, bLum-(bLum*num), 0, 0]); // green
           	matrix = matrix.concat([rLum-(rLum*num), gLum-(gLum*num), bLum, 0, 0]); // blue	
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
            return new ColorMatrixFilter(matrix);
		}
	}
}