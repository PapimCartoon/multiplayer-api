package come2play_as3.pseudoCode.battleShips2
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class ShipData extends SerializableClass
	{
		public var ships:Array/*Ship*/;
		
		public static function create(ships:Array/*Ship*/):ShipData
		{
			var res:ShipData = new ShipData();
			res.ships = ships.concat();
			return res;
		}
	}
}




