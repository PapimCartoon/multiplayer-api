package come2play_as3.cheat.events
{
	import flash.events.Event;

	public class MenuClickEvent extends Event
	{
		static public const DRAW_CARD:String = "DrawCard"
		static public const DECLARE_LOWER:String = "DeclareLower"
		static public const DECLARE_HIGHER:String = "DeclareHigher"
		static public const CALL_CHEATER:String = "CallCheater"
		static public const DO_NOT_CALL_CHEATER:String = "DoNotCallCheater"
		static public const MENU_EVENT:String = "MenuEvent"
		
		public var action:String
		public function MenuClickEvent(action:String)
		{
			super(MENU_EVENT)
			this.action = action;
		}
		
	}
}