import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.MyInterval 
	{
		private var timeout_id:Object = null;
		public var name:String;
		public function MyInterval(name:String)	{
			this.name = name;
		}
		public function toString():String {
			return name;
		}
		public function start(func:Function, milliseconds:Number):Void {
			clear();
			timeout_id = ErrorHandler.myInterval(name, func, milliseconds);
		}
		public function clear():Void {
			if (timeout_id!=null) {
				ErrorHandler.myClearInterval(name, timeout_id);
				timeout_id = null;
			}	
		}
	}
