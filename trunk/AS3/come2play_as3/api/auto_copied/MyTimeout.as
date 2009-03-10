package come2play_as3.api.auto_copied
{	
	public final class MyTimeout 
	{
		private var timeout_id:int = -1;
		public var name:String;
		public function MyTimeout(name:String)	{
			this.name = name;
		}
		public function toString():String {
			return name;
		}
		public function start(func:Function, milliseconds:int):void {
			clear();
			var thisObj:MyTimeout = this; // for AS2
			timeout_id = ErrorHandler.myTimeout(name, function () {
				thisObj.clearId();
				func();				
			}, milliseconds);
		}
		private function clearId():void {
			timeout_id = -1;			
		}
		public function clear():void {
			if (timeout_id!=-1) {
				ErrorHandler.myClearTimeout(name, timeout_id);
				clearId()
			}	
		}
	}
}