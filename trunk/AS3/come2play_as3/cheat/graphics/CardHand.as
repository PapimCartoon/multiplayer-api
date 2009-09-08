package come2play_as3.cheat.graphics
{
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.caurina.transitions.Tweener;
	import come2play_as3.cheat.events.CardDrawEndedEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class CardHand extends MovieClip
	{
		protected var cards:Array
		protected var maxHolderX:int
		protected var minHolderX:int
		protected var cardEndX:int
		protected var cardEndY:int
		protected var isCardDirectionRight:Boolean
		protected var cardHolder:Sprite = new Sprite()
		private var cardAngle:int = 8
		public function CardHand()
		{
			addChild(cardHolder)
			cards = [];
			cardEndX = 300
			cardEndY = 30
			
		}
		public function myTurn(isYourTurn:Boolean):void{
			for each(var card:CardGraphic in cards){
				card.buttonMode = isYourTurn;
			}
		}
		public function drawCard(card:CardGraphic):void{
			cards.push(card)
			card.rotation = isCardDirectionRight?(Math.random() * cardAngle):(Math.random() * -cardAngle)
			cardHolder.addChild(card)	
			isCardDirectionRight = !isCardDirectionRight;
			Tweener.addTween(card, {time:0.2, x:cardEndX, y:cardEndY, transition:"linear",onComplete:cardDrawn} );	
		
		}	
		public function removeCard(cardData:CardKey):CardGraphic{
			var index:int = -1;
			for(var i:int = 0;i<cards.length;i++){
				var card:CardGraphic = cards[i]
				if(card.isSame(cardData)){	
					index = i;
					break;
				}
			}
			if(index == -1)	return null;
			cards.splice(index,1);
			arrangeCards();
			return card;
		}
		protected function arrangeCards():void{
			cards = cards.sortOn("cardValue",Array.NUMERIC)
			var jump:int = cards.length <15?(80 - cards.length * 3):35
			var start:int = cardEndX - (jump * cards.length)/2
			for(var i:int = 0;i<cards.length;i++){
				var card:CardGraphic = cards[i];
				card.x = start + jump*i;
				cardHolder.addChild(card)
			}
			maxHolderX = ((start + jump*(i - 1)) - 550 )/2
			minHolderX = (-maxHolderX)
		}
		private function cardDrawn():void{
			arrangeCards()
			dispatchEvent(new CardDrawEndedEvent())
		}
		
	}
}