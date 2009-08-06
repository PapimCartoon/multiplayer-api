package come2play_as3.dominoGame.graphicClasses
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.dominoGame.events.AnimationEvent;
	import come2play_as3.dominoGame.events.DrawEvent;
	import come2play_as3.dominoGame.events.GrabEvent;
	import come2play_as3.dominoGame.serverClasses.DominoCube;
	
	import flash.display.Sprite;

	public class HandGraphic extends Sprite
	{
		private var brickY:int;
		private var goingToDraw:Array =[];
		private var myHand:Array = [];
		private var isDrawing:Boolean;
		private var handX:int;
		private var pileX:int;
		private var pileY:int;
		public function HandGraphic(brickY:int,pileX:int,pileY:int):void{
			this.brickY = brickY;
			this.pileX = pileX;
			this.pileY = pileY;
		}
		public function clear():void{
			handX = 10;
			isDrawing = false;
			goingToDraw = []
			for each(var brick:DominoBrickGraphic in myHand){
				if(brick.parent!=null)	brick.parent.removeChild(brick);
			}
			myHand = []
		}
		
		public function getBrick(key:Object):DominoBrickGraphic{
			var len:int = myHand.length;
			var foundBrick:DominoBrickGraphic
			var index:int
			for(var i:int=0;i<len;i++){
				var myBrickGraphic:DominoBrickGraphic = myHand[i]
				if(foundBrick==null){
					if(myBrickGraphic.isSame(key)){
						index = i
						foundBrick = myBrickGraphic
					}	
				}else{					
					myBrickGraphic.spaceBack()
					myBrickGraphic.returnBrick()
				}
			}
			handX -= 25
			myHand.splice(index,1);
			return foundBrick;
		}
		public function get dominoInHand():int{
			return myHand.length;
		}
		public function get isWithQueue():Boolean{
			return goingToDraw.length != 0
		}
		public function drawNext():void{
			isDrawing = false
			if(goingToDraw.length>0){
				var obj:Object = goingToDraw.pop()
				draw(obj.key,obj.dominoCube)
			}else if(hasStartedGraphic){
				dispatchEvent(new AnimationEvent(false,"drawing done"))
				hasStartedGraphic = false;
			} 
		}
		private var hasStartedGraphic:Boolean
		public function draw(key:Object,dominoCube:DominoCube=null):void{
			if(isDrawing){
				goingToDraw.push({key:key,dominoCube:dominoCube})
				return;
			}	
			isDrawing = true
			var blockGraphic:DominoBrickGraphic = new DominoBrickGraphic(key,dominoCube)
			if(dominoCube!=null){
				AS3_vs_AS2.myAddEventListener("DominoBlock",blockGraphic,GrabEvent.GRAB_BRICK,reDispatch)
				AS3_vs_AS2.myAddEventListener("DominoBlock",blockGraphic,GrabEvent.LEAVE_BRICK,reDispatch)
			}	
			if(!hasStartedGraphic){
				hasStartedGraphic = true;
				dispatchEvent(new AnimationEvent(true,"drawing done"))
			}
			dispatchEvent(new DrawEvent())
			blockGraphic.x = pileX;
			blockGraphic.y = pileY;
			blockGraphic.setStartPoint(handX,brickY)
			blockGraphic.returnBrick(drawNext)
			handX += 25;
			myHand.push(blockGraphic)
			addChildAt(blockGraphic,0)
		}
		private function reDispatch(ev:GrabEvent):void{
			addChild(ev.brick)
			dispatchEvent(new GrabEvent(ev.type,ev.brick))
		}
		
	}
}