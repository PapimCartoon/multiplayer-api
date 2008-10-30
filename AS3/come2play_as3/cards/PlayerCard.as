package come2play_as3.cards
{
	import come2play_as3.cards.Card;
	
	public class PlayerCard
	{
		public var card:Card;
		public var cardKey:int;
		public function PlayerCard(card:Card,cardKey:int)
		{
			this.cardKey = cardKey;
			this.card = card;
		}

	}
}