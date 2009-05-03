package
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class Guess extends SerializableClass
	{
		public var guessNumber:int;
		static public function create(guessNumber:int):Guess
		{
			var res:Guess = new Guess();
			res.guessNumber = guessNumber;
			return res;
		}
		
	}
}