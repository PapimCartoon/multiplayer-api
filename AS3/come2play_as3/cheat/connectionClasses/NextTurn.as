package come2play_as3.cheat.connectionClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class NextTurn extends SerializableClass
	{
		public function NextTurn()
		{
			super("NextTurn");
		}
		static public function create():NextTurn
		{
			var res:NextTurn = new NextTurn();
			return res;
		}
	}
}