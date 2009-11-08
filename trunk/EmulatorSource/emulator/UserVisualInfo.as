package emulator
{
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class UserVisualInfo extends UserVisualInfo_mc
	{
		public var loader:Loader;
		
		public function UserVisualInfo(x:int, y:int)
		{
			this.x = x;
			this.y = y;
			
			this.frame.gotoAndStop("blue");
			
			loader  = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.bck.addChild(loader);
		}
		
		public function load(url:String):void
		{
			 try {
               loader.load( new URLRequest(url) );
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
		}
		
		public function setTurn( myTurn:Boolean):void
		{
			if ( myTurn ) frame.gotoAndStop("red");
			else frame.gotoAndStop("blue");
		}
		
		
		public function set userName( name:String ):void
		{
			this.userName_txt.text = "name: " + name;
		}
		
		public function set userId( id:int ):void
		{
			this.userId_txt.text = "id: " + id.toString(); 
		}
		
		 private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }


	}
}