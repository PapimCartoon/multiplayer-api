package emulator
{
	import emulator.auto_copied.SerializableClass;
	import emulator.auto_generated.ServerEntry;
	
	import flash.utils.ByteArray;

	public class PlayerDelta extends SerializableClass
	{
		public var playerId:int;
		public var serverEntries:Array;/*ServerEntry*/
		
		static public function create(playerId:int,serverEntries:Array/*ServerEntry*/):PlayerDelta
		{
			var res:PlayerDelta = new PlayerDelta();
			res.playerId = playerId;
			//the ByteArray is used so that when the user changes the server entries the resualt will stay the same
			var transferByteArray:ByteArray = new ByteArray()
			transferByteArray.writeObject(serverEntries);
			transferByteArray.position = 0;
			res.serverEntries = SerializableClass.deserialize(transferByteArray.readObject()) as Array;
			
			return res;
		}
		public function toString():String
		{
			var str:String = playerId+" : ";
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				str+="/n"+serverEntry.toString()	
			}
			return str;
		}
	}
}