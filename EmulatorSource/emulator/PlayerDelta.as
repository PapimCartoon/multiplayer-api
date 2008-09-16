package emulator
{
	import emulator.auto_copied.SerializableClass;
	import emulator.auto_generated.ServerEntry;
	import flash.utils.ByteArray;

	public class PlayerDelta extends SerializableClass
	{
		public var playerIds:Array;
		public var serverEntries:Array;/*ServerEntry*/
		public var finishHistory:FinishHistory;
		static public function create(playerIds:Array/*int*/,serverEntries:Array/*ServerEntry*/,finishHistory:FinishHistory/*PlayerMatchOver*/):PlayerDelta
		{
			var res:PlayerDelta = new PlayerDelta();
			res.playerIds = playerIds;
			res.finishHistory = finishHistory;
			//the ByteArray is used so that when the user changes the server entries the resualt will stay the same
			var transferByteArray:ByteArray = new ByteArray()
			transferByteArray.writeObject(serverEntries);
			transferByteArray.position = 0;
			res.serverEntries = SerializableClass.deserialize(transferByteArray.readObject()) as Array;
			if(res.serverEntries == null)
				res.serverEntries =[];
			return res;
		}
		public function toString():String
		{
			var str:String = playerIds+" \n ";
			if(serverEntries.length > 0)
				str+=serverEntries.toString();
			else
				str+=finishHistory.toString();
			return str;
		}
	}
}