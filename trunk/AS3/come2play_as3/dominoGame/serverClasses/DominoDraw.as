package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class DominoDraw extends SerializableClass
	{
		static public const DOMINO_DRAW:String = "DominoDraw"
		static public function create():DominoDraw{
			return new DominoDraw()
		}
	}
}