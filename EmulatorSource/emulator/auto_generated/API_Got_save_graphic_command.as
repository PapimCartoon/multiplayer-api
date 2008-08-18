package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	public  class API_Got_save_graphic_command extends API_Message {
		public var arr:Array/*int*/;
		public var pos:int;
		public function API_Got_save_graphic_command(arr:Array/*int*/, pos:int) { super('got_save_graphic_command',arguments); 
			this.arr = arr;
			this.pos = pos;
		}
		override public function getParametersAsString():String { return 'arr=' + JSON.stringify(arr)+', pos=' + JSON.stringify(pos); }
	}
}
