package emulator
{	
	import emulator.auto_copied.ObjectDictionary;
	
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class PathChocie extends MovieClip
	{
		public function PathChocie(stage:Stage)
		{	
			
			if(stage.loaderInfo.parameters["isServer"]=="true"){
				(new ObjectDictionary()).register();
				(new DeltaHistory).register();
				(new PlayerDelta).register();
				(new SavedGame).register();
				var server:Server = new Server(); 
				stage.addChild(server);
				server.constructServer();
			}else if(stage.loaderInfo.parameters["isServer"]=="false"){
				var infoContainer:InfoContainer = new InfoContainer();
				stage.addChild(infoContainer);
				infoContainer.constructInfoContainer();
			}
		}
		
	}
}