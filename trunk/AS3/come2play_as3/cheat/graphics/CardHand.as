package come2play_as3.cheat.graphics
{
	import come2play_as3.cheat.caurina.transitions.Tweener;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	
	import flash.display.MovieClip;

	public class CardHand extends MovieClip
	{
		protected var cards:Array
		
		protected var cardEndX:int
		protected var cardEndY:int
		public function CardHand()
		{
			cards = [];
			cardEndX = 250
			cardEndY = 30
		}

		public function drawCard(card:CardGraphic):void{
			cards.push(card)
			addChild(card)
			Tweener.addTween(card, {time:0.2, x:cardEndX, y:cardEndY, transition:"linear",onComplete:cardDrawn} );	
		
		}
		protected function arrangeCards():void{
			
		}
		private function cardDrawn():void{
			arrangeCards()
			dispatchEvent(new CardDrawEndedEvent())
		}
		
	}
}