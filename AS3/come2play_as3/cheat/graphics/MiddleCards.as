package come2play_as3.cheat.graphics
{
	import come2play_as3.cards.CardKey;
	import come2play_as3.cheat.caurina.transitions.Tweener;
	
	import flash.display.Sprite;

	public class MiddleCards extends Sprite
	{
		private var choosenCards:Sprite
		private var choosenCardsArray:Array/*CardGraphic*/
		private var thrownDeckArray:Array/*CardGraphic*/
		private var thrownDeck:Sprite
		private var cardEndY:int = 200
		private var cardEndX:int = 250
		private var cardValue:int = -1
		public function MiddleCards()
		{
			choosenCardsArray = new Array();
			thrownDeckArray = new Array();
			
			choosenCards = new Sprite()
			thrownDeck = new Sprite()
			addChild(thrownDeck)
			addChild(choosenCards)
		}
		public function haveMax():Boolean{
			return choosenCardsArray.length > 5
		}
		public function noDeck():Boolean{
			return thrownDeckArray.length == 0;
		}
		public function pickCard(cardGraphic:CardGraphic):void{
			choosenCardsArray.push(cardGraphic)
			choosenCards.addChild(cardGraphic)
			Tweener.addTween(cardGraphic, {time:0.2, x:cardEndX, y:cardEndY, transition:"easeOutSine",onComplete:cardPicked} );	
		}
		public function putFirst(cardGraphic:CardGraphic):void{
			cardValue = cardGraphic.getCardValue()
			thrownDeckArray.push(cardGraphic)
			thrownDeck.addChild(cardGraphic)
			Tweener.addTween(cardGraphic, {time:0.2, x:cardEndX, y:cardEndY, transition:"easeOutSine"} );
		}
		private function cardPicked():void{
			arrangeCards()
		}
		private function arrangeCards():void{
			var jump:int = choosenCardsArray.length <15?(80 - choosenCardsArray.length * 3):35
			var start:int = cardEndX - (jump * choosenCardsArray.length)/2
			for(var i:int = 0;i<choosenCardsArray.length;i++){
				var card:CardGraphic = choosenCardsArray[i];
				card.x = start + jump*i;
				choosenCards.addChild(card)
			}
		}
		public function setCardValue(value:int):void{
			cardValue = value;
		}
		public function getCardValue():int{
			return cardValue;
		}
		public function getCardKeys():Array/*CardKey*/{
			var keys:Array/*CardKey*/ = []
			for each(var card:CardGraphic in choosenCardsArray){
				keys.push(card.getCardKey())
			}
			return keys;
		}
		public function addCard(cardGraphic:CardGraphic):void{
			cardGraphic.setCard(null);
			thrownDeck.addChild(cardGraphic)
			Tweener.addTween(cardGraphic, {time:0.2, x:cardEndX, y:cardEndY, transition:"easeOutSine"} );
		}
		public function removeCard(cardKey:CardKey):CardGraphic{
			var cardGraphic:CardGraphic
			for(var i:int = 0;i<choosenCardsArray.length;i++){
				cardGraphic = choosenCardsArray[i]
				if(cardGraphic.isSame(cardKey)){	
					choosenCardsArray.splice(i,1);
					arrangeCards();
					return cardGraphic
				}	
			}
			return null;
		}
	}
}