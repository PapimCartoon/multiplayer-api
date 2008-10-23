package come2play_as3.cards.events
{
	import flash.events.Event;

	public class GraphicButtonClickEvent extends Event
	{
		static public var GraphicButtonClick:String = "GraphicButtonClick";
		public var name:String;
		public function GraphicButtonClickEvent(name:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.name = name;
			super(GraphicButtonClick, bubbles, cancelable);
		}
		
	}
}