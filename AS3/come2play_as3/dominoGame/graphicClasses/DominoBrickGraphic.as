package come2play_as3.dominoGame.graphicClasses
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.dominoGame.caurina.transitions.Tweener;
	import come2play_as3.dominoGame.events.GrabEvent;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	import come2play_as3.dominoGame.usefullFunctions.Tools;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DominoBrickGraphic extends Sprite
	{
		static public const CENTER_X_CHANGE:int = 10
		static public const CENTER_Y_CHANGE:int = 20
		static public const RIGHT:int = 90;
		static public const LEFT:int = 270
		static public const UP:int = 0
		static public const DOWN:int = 180 
		
		private var blockGraphic:BlockGraphic;
		public var dominoCube:DominoCube;
		public var key:Object;
		public var rightBrickNum:int
		public var leftBrickNum:int
		/**
		 * 
		 */
		public var brickOrientation:int
		/*only one of these is active*/
		public var isHeadDown:Boolean;
		public var isHeadRight:Boolean;	
		/*----------------------------*/
		public var isConnectedToRight:Boolean
		private var direction:int
		private var isDrag:Boolean
		private var isGrabbed:Boolean
		private var grabTime:Number	
		private var startingPointX:int
		private var startingPointY:int
		private var rotationSprite:Sprite = new Sprite();
		
		
		public function DominoBrickGraphic(key:Object,dominoCube:DominoCube)
		{
			blockGraphic = new BlockGraphic();
			direction = UP;
			hasShadow(false)
			this.key = key;
			if(dominoCube!=null){
				allowDrag(true);
				show(dominoCube)
			}
			blockGraphic.stop();	
			addChild(rotationSprite)
			addChild(blockGraphic)
		}
		public function flipSide():void{
			isHeadDown = !isHeadDown;
			isHeadRight = !isHeadRight;
		}
		
		public function brickDirection(_direction:int):void{
			_direction = _direction%360;
			StaticFunctions.assert(_direction>=0,"smaller then 0")
			direction = _direction;
			isHeadDown = (direction==180);
			isHeadRight = (direction==90);
			rotation = direction;			
		}
		public function isDouble():Boolean{
			return dominoCube.isDouble();
		}
		
		public function show(dominoCube:DominoCube):void{
			this.dominoCube = dominoCube;
			blockGraphic.icon1.visible = false
			blockGraphic.icon2.visible = false
			changeUpperNum(dominoCube.up)
			changeLowerNum(dominoCube.down)
		}
		public function isSame(testKey:Object):Boolean{
			return (key["brickNum"] == testKey["brickNum"])
		}
		private function changeUpperNum(num:int):void{
			blockGraphic.numBmc.gotoAndStop(num+1)
		}
		private function changeLowerNum(num:int):void{
			blockGraphic.numAmc.gotoAndStop(num+1)
		}
		
		public function placeBrick(direction:int,isRight:Boolean):void{
			brickDirection(direction)
			if(dominoCube.isDouble()){
				rightBrickNum = leftBrickNum = dominoCube.up;
			}else if(direction == RIGHT){
				if(isRight){
					rightBrickNum =dominoCube.up
					leftBrickNum =dominoCube.down
				}else{
					rightBrickNum =dominoCube.down
					leftBrickNum = dominoCube.up
				}
			}else{
				if(isRight){
					rightBrickNum =dominoCube.down
					leftBrickNum = dominoCube.up
				}else{
					rightBrickNum =dominoCube.up
					leftBrickNum =dominoCube.down
				}
			}
			allowDrag(false)
		}
		
		public function allowDrag(value:Boolean):void{
			if(isDrag == value)	return;
			isDrag = value;
			if(isDrag){
				AS3_vs_AS2.myAddEventListener("DominoBlock",blockGraphic,MouseEvent.MOUSE_UP,leaveDomino)
				AS3_vs_AS2.myAddEventListener("DominoBlock",blockGraphic,MouseEvent.MOUSE_DOWN,grabDomino)
				AS3_vs_AS2.myAddEventListener("DominoBlock",blockGraphic,MouseEvent.CLICK,leaveDomino)
			}else{
				AS3_vs_AS2.myRemoveAllEventListeners("DominoBlock",blockGraphic)
			}
		}

		private function grabDomino(ev:MouseEvent):void{
			if(isGrabbed)	return
			isGrabbed = true;
			grabTime = getTimer();
			dispatchEvent(new GrabEvent(GrabEvent.GRAB_BRICK,this))
		}
		private function leaveDomino(ev:MouseEvent):void{
			ev.stopImmediatePropagation()
			if(!isGrabbed)	return
			if((getTimer() - grabTime)>300){
				isGrabbed = false
				dispatchEvent(new GrabEvent(GrabEvent.LEAVE_BRICK,this))
			}			
		}
		public function returnBrick(endFunc:Function=null):void{
			hasShadow(false)
			Tweener.addTween(this, {time:0.2, xPos:(startingPointX+10), yPos:startingPointY+20, transition:"linear",onComplete:endFunc} );	
		}
		public function setStartPoint(xPos:int,yPos:int):void{
			startingPointX = xPos;
			startingPointY = yPos;
		}
		public function spaceBack():void{
			startingPointX-=25
		}
		public function addNormal(brick:DominoBrickGraphic,isUp:Boolean,setPosition:Boolean = true):void{
			var rAngle:int
			if(isVertical){
				rAngle = isHeadRight?0:180 
			}else{
				rAngle = isHeadDown?90:270
			}
				
			rotationSprite.rotation = rAngle - rotation
			brick.brickDirection(rAngle+(isUp?270:90))
			var p:Point = Tools.localToGlobal(rotationSprite,CENTER_Y_CHANGE + CENTER_X_CHANGE,0);
			if(setPosition){
				brick.hasShadow(true);
				brick.x = p.x/Tools.scaleX;
				brick.y = p.y/Tools.scaleY;
			}else{
				p = Tools.globalToLocal(brick.parent,p.x,p.y)
				brick.setStartPoint(p.x-10,p.y-20)
			}	
		}
		
		public function addDouble(brick:DominoBrickGraphic,setPosition:Boolean = true):void{
			var rAngle:int =  myRotation()
			rotationSprite.rotation = rAngle - rotation
			brick.brickDirection(rAngle +90)
			brick.isHeadDown = isHeadDown
			brick.isHeadRight = isHeadRight
			var p:Point = Tools.localToGlobal(rotationSprite,0,-(CENTER_Y_CHANGE + CENTER_X_CHANGE))
			if(setPosition){
				brick.hasShadow(true);
				brick.x = p.x/Tools.scaleX;
				brick.y = p.y/Tools.scaleY;
			}else{
				p = Tools.globalToLocal(brick.parent,p.x,p.y)
				brick.setStartPoint(p.x-10,p.y-20)
			}	
		}
		public function connectBrickToThis(brick:DominoBrickGraphic,isUp:Boolean,orientation:int,setPosition:Boolean = true):void{	
			var rAngle:int = myRotation()
			rotationSprite.rotation =  rAngle - rotation
			brick.brickOrientation = orientation;
			var p:Point = new Point	
			switch(orientation){
				case 0://Center	
					brick.brickDirection(rAngle +(isUp?180:0))
					p = Tools.localToGlobal(rotationSprite,0,-CENTER_Y_CHANGE*2)
				break;
				case 1://Upper Left
					brick.brickDirection(rAngle +(isUp?90:270))
					p = Tools.localToGlobal(rotationSprite,-CENTER_X_CHANGE,-(CENTER_X_CHANGE + CENTER_Y_CHANGE))
				break;
				case 2://Lower Left
					brick.brickDirection(rAngle +(isUp?90:270))
					p = Tools.localToGlobal(rotationSprite,-(CENTER_X_CHANGE + CENTER_Y_CHANGE),-CENTER_X_CHANGE)
				break;
				case 3://Upper Right
					brick.brickDirection(rAngle +(isUp?270:90))
					p = Tools.localToGlobal(rotationSprite,CENTER_X_CHANGE,-(CENTER_X_CHANGE + CENTER_Y_CHANGE))
				break;
				case 4://Lower Right
					brick.brickDirection(rAngle +(isUp?270:90))
					p = Tools.localToGlobal(rotationSprite,CENTER_X_CHANGE + CENTER_Y_CHANGE,-CENTER_X_CHANGE)
				break;
			}
			if(setPosition){
				brick.hasShadow(true)
				brick.x = p.x/Tools.scaleX;
				brick.y = p.y/Tools.scaleY;
			}else{
				p = Tools.globalToLocal(brick.parent,p.x,p.y)
				brick.setStartPoint(p.x-10,p.y-20)
			}	
		}
		public function hasShadow(value:Boolean):void{
			blockGraphic.shadow_mc.visible = value;
		}
		
		public function connectBrick(brick:DominoBrickGraphic,brickPos:Point,isUp:Boolean):void{
			var orientation:int = findPointOrientation(brickPos)
			connectBrickToThis(brick,isUp,orientation)
		}

		private var lastSp:Sprite
		private function drawPoint(p:Point):void{
			if(lastSp!=null)	lastSp.parent.removeChild(lastSp)
			var sp:Sprite = new Sprite()
			sp.graphics.beginFill(0x000000)
			sp.graphics.lineStyle(1,0x000000);
			sp.graphics.drawCircle(p.x,p.y,1);
			sp.graphics.endFill();
			stage.addChild(sp)
			lastSp = sp;
		}
		
		private function findPointOrientation(placedPoint:Point):int{	
			var upperLeft:int = getDistance(getUpperLeft(),placedPoint)
			var lowerLeft:int = getDistance(getLowerLeft(),placedPoint)
			var upperRight:int = getDistance(getUpperRight(),placedPoint)
			var lowerRight:int = getDistance(getLowerRight(),placedPoint)
			var centerPoint:int = getDistance(getCenter(),placedPoint)
			var arr:Array = [centerPoint,upperLeft,lowerLeft,upperRight,lowerRight]
			var index:int = 0
			var len:int = arr.length
			for(var i:int=1;i<len;i++){
				if(arr[index]>arr[i])	index = i;
			}
			return index;
		}
		
		static public function getDistance(p1:Point,p2:Point):int{
			return Math.pow((p1.x -p2.x),2) +  Math.pow((p1.y -p2.y),2)
		}

		private function myRotation():int{
			if(isVertical)
				return isHeadDown?180:0;
			else
				return isHeadRight?90:270;
			return 0;
		}
		private function getCenter():Point{
			return Tools.localToGlobal(rotationSprite,0,-CENTER_Y_CHANGE)
		}
		private function getUpperLeft():Point{		
			return Tools.localToGlobal(rotationSprite,-CENTER_X_CHANGE,-CENTER_Y_CHANGE)
		}
		private function getUpperRight():Point{
			return Tools.localToGlobal(rotationSprite,CENTER_X_CHANGE,-CENTER_Y_CHANGE)
		}
		private function getLowerLeft():Point{
			return Tools.localToGlobal(rotationSprite,-CENTER_X_CHANGE,0)
		}
		private function getLowerRight():Point{
			return Tools.localToGlobal(rotationSprite,CENTER_X_CHANGE,0)
		}
		
		
		
		public function get isVertical():Boolean{
			return (direction == UP || direction == DOWN)
		}
		
		public function getLeftPoint():Point{		
			if(isVertical)	return Tools.localToGlobal(this,-CENTER_X_CHANGE,0)
			return Tools.localToGlobal(this,-CENTER_Y_CHANGE,0)
		}
		public function getRightPoint():Point{
			if(isVertical)	return Tools.localToGlobal(this,CENTER_X_CHANGE,0 )
			return Tools.localToGlobal(this,CENTER_Y_CHANGE,0)
		}
		public function set xPos(num:Number):void{
			super.x = num;
		}
		public function set yPos(num:Number):void{
			super.y = num
		}	
		public function get xPos():Number{
			return  super.x
		}
		public function get yPos():Number{
			return  super.y
		}

	}
}