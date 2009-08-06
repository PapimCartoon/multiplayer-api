package come2play_as3.dominoGame.graphicClasses
{
	import come2play_as3.dominoGame.LogicClasses.MiddleBoard;
	import come2play_as3.dominoGame.serverClasses.DominoMove;
	import come2play_as3.dominoGame.usefullFunctions.Tools;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class MiddleBoardGraphic extends Sprite
	{
		private var middle:DominoBrickGraphic
		private var right:Array = []
		private var left:Array = []	
		
		
		private function safeRemove(brick:DominoBrickGraphic):void{
			if(brick == null)	return;
			if(brick.parent!=null)	brick.parent.removeChild(brick);
		}
		private function clearArr(arr:Array):void{
			for each(var brick:DominoBrickGraphic in arr){
				safeRemove(brick)
			}
		}
		
		public function clear():void{
			clearArr(left)
			clearArr(right)
			safeRemove(middle)
			delayedBricks = []
			left = []
			right = []
			middle = null
		}
			
		public function canAddCenter():Boolean{
			return middle==null
		}	
		
		private var delayedBricks:Array
		private var isInAnimation:Boolean
		private function finishedAnimation():void{
			isInAnimation = false;
			if(delayedBricks.length>0){
				var delayedAnimation:Object = delayedBricks.shift()
				addBrick(delayedAnimation.cube,delayedAnimation.move)
			}
		}
		
		public function addBrick(cube:DominoBrickGraphic,move:DominoMove):void{
			if(isInAnimation){
				delayedBricks.push({cube:cube,move:move})
				return;
			}		
			isInAnimation = true
			var oldPoint:Point = Tools.globalToLocal(this,cube.x*Tools.scaleX,cube.y*Tools.scaleY);
			addChild(cube)
			cube.x = oldPoint.x
			cube.y = oldPoint.y
			if(move.connectToRight){
				if(right.length == 0)	rightBrick.isHeadRight = true
				handleAddBrick(rightBrick,cube,rightBrick.rightBrickNum,move)
				if(rightBrick.rightBrickNum == move.dominoCube.down){
					cube.rightBrickNum = move.dominoCube.up
				}else{
					cube.rightBrickNum = move.dominoCube.down
					cube.flipSide()
				}
				right.push(cube)
			}else{
				if(left.length == 0)	leftBrick.isHeadRight = false
				handleAddBrick(leftBrick,cube,leftBrick.leftBrickNum,move)
				if(leftBrick.leftBrickNum == move.dominoCube.down){
					cube.leftBrickNum = move.dominoCube.up
				}else{
					cube.leftBrickNum = move.dominoCube.down
					cube.flipSide()		
				}
				left.push(cube)
			}	
			cube.returnBrick(finishedAnimation)
		}
		
		public function addCenter(cube:DominoBrickGraphic):void{
			isInAnimation = true
			middle = cube
			if(middle.dominoCube.isDouble()){
				cube.setStartPoint(150,160)
				cube.placeBrick(DominoBrickGraphic.UP,false)
			}else{
				cube.setStartPoint(150,160)
				cube.placeBrick(DominoBrickGraphic.RIGHT,true)
			}
			addChild(cube)
			cube.returnBrick(finishedAnimation)
		}
		private function get rightBrick():DominoBrickGraphic{
			return right.length == 0?middle:right[right.length-1]
		}
		private function get leftBrick():DominoBrickGraphic{
			return left.length == 0?middle:left[left.length-1]
		}
		private var hitTestDistance:int = 1800
		private function handleAddBrick(brick:DominoBrickGraphic,cube:DominoBrickGraphic,connectNum:int,move:DominoMove):void{
			if(brick.isDouble()){
				brick.addNormal(cube,connectNum == move.dominoCube.up,false)
			}else if(cube.isDouble()){
				brick.addDouble(cube,false)
			}else{	
				brick.connectBrickToThis(cube,connectNum == move.dominoCube.up,move.brickOrientation,false)
			}	
		}
		
		private function handleConnectBrick(brick:DominoBrickGraphic,heldBrick:DominoBrickGraphic,connectNum:int,cubePoint:Point):void{
			if(brick.isDouble()){	
				brick.addNormal(heldBrick,heldBrick.dominoCube.up == connectNum)
			}else if(heldBrick.isDouble()){
				brick.addDouble(heldBrick)
			}else{
				brick.connectBrick(heldBrick,cubePoint,heldBrick.dominoCube.up == connectNum)
			}	
		}
		
		public function checkHit(heldBrick:DominoBrickGraphic,cubePoint:Point):Boolean{//returns hit direction
			if(middle==null)	return false;
			var leftPoint:Point = leftBrick.getLeftPoint();
			var rightPoint:Point = rightBrick.getRightPoint();
			var leftDistance:int = MiddleBoard.canAddLeft(heldBrick.dominoCube)?DominoBrickGraphic.getDistance(leftPoint,cubePoint):int.MAX_VALUE
			var rightDistance:int = MiddleBoard.canAddRight(heldBrick.dominoCube)?DominoBrickGraphic.getDistance(rightPoint,cubePoint):int.MAX_VALUE
		//	trace("leftDistance: "+leftDistance+"rightDistance: "+rightDistance)
			if((leftDistance<hitTestDistance) || (rightDistance<hitTestDistance)){
				if(leftDistance>rightDistance){
					if(right.length == 0)	rightBrick.isHeadRight = true
					handleConnectBrick(rightBrick,heldBrick,rightBrick.rightBrickNum,cubePoint)
					heldBrick.isConnectedToRight = true;
				}else{ 
					if(left.length == 0)	leftBrick.isHeadRight = false
					handleConnectBrick(leftBrick,heldBrick,leftBrick.leftBrickNum,cubePoint)
					heldBrick.isConnectedToRight = false;
				}
				return true;
			}	
			return false;
		}
		
	}
}