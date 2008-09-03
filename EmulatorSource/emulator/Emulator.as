package emulator
{
	import flash.display.MovieClip;

	public class Emulator extends MovieClip
	{
		public function Emulator()
		{
			if(root.loaderInfo.parameters["isServer"]=="true")
			{
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