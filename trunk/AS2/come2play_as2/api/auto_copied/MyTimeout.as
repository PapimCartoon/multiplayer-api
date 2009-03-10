import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.MyTimeout 
	{
		private var timeout_id:Number = -1;
		public var name:String;
		public function MyTimeout(name:String)	{
			this.name = name;
		}
		public function toString():String {
			return name;
		}
		public function start(func:Function, milliseconds:Number):Void {
			clear();
			var thisObj:MyTimeout = this; // for AS2
			timeout_id = ErrorHandler.myTimeout(name, function () {
				thisObj.clearId();
				func();				
			}, milliseconds);
		}
		private function clearId():Void {
			timeout_id = -1;			
		}
		public function clear():Void {
			if (timeout_id!=-1) {
				ErrorHandler.myClearTimeout(name, timeout_id);
				clearId()
			}	
		}
	}
