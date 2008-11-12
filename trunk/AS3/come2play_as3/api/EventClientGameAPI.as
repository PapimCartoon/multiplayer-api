package come2play_as3.api
{
	import come2play_as3.api.auto_generated.API_Message;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class EventClientGameAPI extends ClientGameAPI
	{
		public var dispatcher:EventDispatcher;
		public function EventClientGameAPI(someMovieClip:MovieClip)
		{
			super(someMovieClip);
			dispatcher = new EventDispatcher();
		}
		public function addEventListener(type:String,listener:Function,useCapture:Boolean = false,priority:int = 0,useWeakReference:Boolean = false ):void
		{
			dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		override public function dispatchMessage(msg:API_Message):void
		{
			dispatcher.dispatchEvent(msg);
		}
		
	}
}