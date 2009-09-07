package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_Timer;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	public class YourHand extends CardHand
	{
		private var cardMover:AS3_Timer = new AS3_Timer("cardMover",80,0);
		private var maxX:int
		private var minX:int
		private var isMoveRight:Boolean
		public function YourHand()
		{
			super()
			cardEndY = 400;
			AS3_vs_AS2.myAddEventListener("CardHand",this,MouseEvent.MOUSE_MOVE,tryMovingCards,true)
			AS3_vs_AS2.myAddEventListener("cardMover",cardMover,TimerEvent.TIMER,moveCard)
			var gameWidth:int = T.custom(API_Message.CUSTOM_INFO_KEY_gameWidth,400) as int;
			maxX = gameWidth * 0.8
			minX = gameWidth * 0.2
		}
		private function moveCard(ev:TimerEvent):void{
			var arr:Array = []
			arr.push(["isMoveRight=",isMoveRight])
			arr.push(["cardHolder.x",cardHolder.x])
			arr.push(["minHolderX=",minHolderX])
			arr.push(["maxHolderX=",maxHolderX])
			arr.push("*******************")
			//trace(arr.join("\n"))
			if(isMoveRight){
				if(maxHolderX>cardHolder.x)	cardHolder.x+=15
			}else{
				if(minHolderX<cardHolder.x)	cardHolder.x-=15
			}
		}
		private function tryMovingCards(ev:MouseEvent):void{
			if(ev.stageX > maxX){
				isMoveRight = false;
				cardMover.start();
			}else if(ev.stageX <minX){
				isMoveRight = true;
				cardMover.start();
			}else{
				cardMover.stop();
			}
			
		}
		
		
	}
}