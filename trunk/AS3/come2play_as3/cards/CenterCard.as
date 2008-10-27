package come2play_as3.cards
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CenterCard extends SerializableClass
	{
		public var playerId:int;
		public var cardKey:int;
		public var isVisible:Boolean;
		static public function create(playerId:int,cardKey:int,isVisible:Boolean):CenterCard
		{
			var res:CenterCard = new CenterCard();
			res.isVisible = isVisible;
			res.playerId = playerId;
			res.cardKey = cardKey;
			return res;
		}
		
	}
}