package come2play_as3.cards.graphic
{
	import come2play_as3.cards.Card;
	
	public class CardDictonery
	{
		private var arrangedCards:Array;
		private var cardsInHand:Array;
		private var index:int;
		private var order:Array = [Card.HEART,Card.DAIMOND,Card.CLUB,Card.SPADE,Card.REDJOKER,Card.BLACKJOKER];
		public function CardDictonery(cardsInHand:Array,isByNum:Boolean)
		{
			this.cardsInHand = cardsInHand;
			index = 0;
			var numberedArray:Array = new Array();
			for each(var str:String in order)
				numberedArray[str] = new Array()
			var currentArr:Array;
			for each(var cardGraphic:CardGraphicMovieClip in cardsInHand)
			{
				if(!cardGraphic.isSet) continue;
				currentArr = numberedArray[cardGraphic.playerCard.card.sign]	
				if(currentArr[cardGraphic.playerCard.card.value] == null)
					currentArr[cardGraphic.playerCard.card.value] = new Array();
				currentArr[cardGraphic.playerCard.card.value].push(cardGraphic);
			}
			var shapeArr:Array;
			arrangedCards = new Array();
			if(isByNum)
			{
				for each(shapeArr in numberedArray)
				{
					for each(var numArr:Array in shapeArr)
					{
						if(numArr !=null)
							arrangedCards = arrangedCards.concat(numArr);
					}
				}
			}
			else
			{
				for(var i:int = 1;i<14;i++)
				{
					for each(shapeArr in numberedArray)
					{
						if(shapeArr[i] != null)
							arrangedCards = arrangedCards.concat(shapeArr[i]);
					}
				}
				for each(shapeArr in numberedArray)
				{
					if(shapeArr[100] != null)
						arrangedCards = arrangedCards.concat(shapeArr[100]);
				}

			}
			
		}
		public function arangeNextCard():CardGraphicMovieClip
		{
			var oldPositionCard:CardGraphicMovieClip;
			var newPositionCard:CardGraphicMovieClip;
			for(var i:int = index;i<arrangedCards.length;i++)
			{
				oldPositionCard = cardsInHand[i]
				newPositionCard = arrangedCards[i]
				if(oldPositionCard == null)
					return null;
				if(newPositionCard == null)
					return null;
				if(!oldPositionCard.isEquel(newPositionCard.playerCard))
				{
					index = i;
					break;
				}
			}
			
			if(i<arrangedCards.length)
			{			
				var cardGraphicMovieClip:CardGraphicMovieClip;
				for(var j:int = 0 ;j<cardsInHand.length;j++)
				{
					cardGraphicMovieClip = cardsInHand[j];
					if(newPositionCard.isEquel(cardGraphicMovieClip.playerCard))
					{
						cardsInHand.splice(j,1);
						cardsInHand.splice(i,0,newPositionCard);
						return newPositionCard
					}
				}		
			}
			return null;
			
		}

	}
}