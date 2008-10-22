package emulator
{
	import emulator.auto_copied.SerializableClass;

	public class FinishHistory extends SerializableClass
	{
		public static var wholePot:Number=100;
		public static var totalFinishingPlayers:int=0;
		public var pot:int;
		public var finishedPlayers:Array=new Array/*PlayerMatchOver*/;
		
		public function FinishHistory()
		{
			super("FinishHistory");
		}
		
		public function toMeaningfulString():String
		{
			return "pot: "+pot+" devided between :"+finishedPlayers;
		}
	}
}