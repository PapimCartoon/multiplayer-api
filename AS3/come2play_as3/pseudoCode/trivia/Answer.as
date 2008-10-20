package come2play_as3.pseudoCode.trivia
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class Answer extends SerializableClass
	{
		public var text:String,playerId:int,isCorrect:Boolean;
		public function Answer() { super("Answer"); }
		public static function create(text:String,playerId:int,isCorrect:Boolean):Answer
		{
			var res:Answer = new Answer();
			res.text = text;
			res.playerId = playerId;
			res.isCorrect = isCorrect;
			return res;
		}
	}
}