package come2play_as3.pseudoCode.trivia
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class Question extends SerializableClass
	{
		public var text:String;
		public function Question() { super("Question"); }
		public static function create(text:String):Question
		{
			var res:Question = new Question();
			res.text = text;
			return res;
		}
	}
}