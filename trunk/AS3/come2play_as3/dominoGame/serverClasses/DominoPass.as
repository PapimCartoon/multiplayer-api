package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;
	

	public class DominoPass extends SerializableClass
	{
		static public const DOMINO_PASS:String = "DominoPass"
		static public function create():DominoPass{
			return new DominoPass()
		}
	}
}