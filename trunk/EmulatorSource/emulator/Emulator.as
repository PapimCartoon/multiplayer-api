package emulator
{	
	import emulator.auto_copied.ObjectDictionary;
	
	import flash.display.MovieClip;

	public class Emulator extends MovieClip
	{
		public function Emulator()
		{	
			
			if(root.loaderInfo.parameters["isServer"]=="true")
			{
			(new ObjectDictionary()).register();
			(new DeltaHistory).register();
			(new PlayerDelta).register();
			(new SavedGame).register();
			var server:Server = new Server(); 
			addChild(server);
			server.constructServer();
			}
			else
			{
			var infoContainer:InfoContainer = new InfoContainer();
			addChild(infoContainer);
			infoContainer.constructInfoContainer();
			}
		}
		
	}
}