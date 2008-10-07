package come2play_as3.cards
{
	import come2play_as3.api.auto_generated.ClientGameAPI;
	
	import flash.display.MovieClip;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.api.auto_generated.RevealEntry;
	import come2play_as3.api.auto_generated.ServerEntry;
	
	public class CardsAPI extends ClientGameAPI
	{
		private var currentCard:int;
		private var availableCards:int;
		private var storedDecks:Boolean;
		public function CardsAPI(graphics:MovieClip)
		{
			super(graphics);
		}
		
		public function drawCards(numberOfCards:int,playerId:int):void
		{
			var revealEntries:Array/*RevealEntry*/ = new Array();
			for(var i:int = currentCard;i<numberOfCards;i++)
			{
				revealEntries.push(RevealEntry.create({type:"Card",num:currentCard},[playerId]))
				currentCard++;
			}
			doAllRevealState(revealEntries);
		}
		public function gotCards(cards:Array/*Card*/):void
		{
			
		}
		
		public function storeDecks(numberOfDecs:int,withJokers:Boolean):void
		{
			currentCard = 1;
			var count:int = 1;
			
			var userEntries:Array/*UserEntry*/ = new Array();
			var keys:Array/*String*/ = new Array();
			for(var i:int=0;i<numberOfDecs;i++)
			{
				for(var j:int = 0;j<13;j++)
				{
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(1,j),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(2,j),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(3,j),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(4,j),true));
					
				}
				if(withJokers)
				{
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(5,100),true));
					keys.push({type:"Card",num:count});
					userEntries.push(UserEntry.create({type:"Card",num:count++},Card.createByNumber(5,100),true));		
				}
			}
			storedDecks = true;
			availableCards = count - 1;
			doAllStoreState(userEntries);
			doAllShuffleState(keys);
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry;
			
			if(storedDecks)
			{
				var countedCards:int = 0;
				for each(serverEntry in serverEntries)
				{
					if(serverEntry.key.type == "Card")
					{
						if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"this card was stored by a single player");
						countedCards++;
					}
						
				}
				if(countedCards != availableCards)
					doAllFoundHacker(serverEntry.storedByUserId,"Wrong number of cards recived");
				else
					storedDecks = false;
			}
			
			var drawnCards:Array/*Card*/ = new Array();
			
			for each(serverEntry in serverEntries)
			{
				if(serverEntry.value is Card)
				{
					if(serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"this card was stored by a single player");
					drawnCards.push(serverEntry.value as Card);
				}
				if(drawnCards.length > 0)
					gotCards(drawnCards);
			}
		}	
		
	}
}