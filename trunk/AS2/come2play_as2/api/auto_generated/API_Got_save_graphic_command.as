//Do not change the code below because this class was generated automatically!

	import come2play_as2.util.*;
	import come2play_as2.api.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_Got_save_graphic_command extends API_Message {
		public var arr:Array/*int*/;
		public var pos:Number;
		public function API_Got_save_graphic_command(arr:Array/*int*/, pos:Number) { super('got_save_graphic_command',arguments); 
			this.arr = arr;
			this.pos = pos;
		}
		/*override*/ public function getParametersAsString():String { return 'arr=' + JSON.stringify(arr)+', pos=' + JSON.stringify(pos); }
	}
