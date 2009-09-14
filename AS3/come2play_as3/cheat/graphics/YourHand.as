package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.AS3_Timer;
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.StaticFunctions;
	import come2play_as3.cards.CardChange;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;

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
			var gameWidth:int = 550;
			maxX = gameWidth * 0.7
			minX = gameWidth * 0.3
		}
		private function moveCard(ev:TimerEvent):void{
			if(isMoveRight){
				if(maxHolderX>cardHolder.x)	cardHolder.x+=15
			}else{
				if(minHolderX<cardHolder.x)	cardHolder.x-=15
			}
		}
		override public function updateData(card:CardChange):Boolean{
			StaticFunctions.assert(cardsToDraw.length ==0,"can't have cards waitng")
			for each(var cardGraphic:CardGraphic in cards){
				if(cardGraphic.isSameCard(card.card)){
					cardGraphic.setKey(card.cardKey)
					return true;
				}
			}
			return false;
		}
		private function tryMovingCards(ev:MouseEvent):void{
			var point:Point = globalToLocal(new Point(ev.stageX,ev.stageY))
			if(point.x > maxX){
				isMoveRight = false;
				cardMover.start();
			}else if(point.x <minX){
				isMoveRight = true;
				cardMover.start();
			}else{
				cardMover.stop();
			}
			
		}
		
		
	}
}