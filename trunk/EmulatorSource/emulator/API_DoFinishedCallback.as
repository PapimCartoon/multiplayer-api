package emulator {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;
	public  class API_DoFinishedCallback extends API_Message {
		public var method_name:String;
		public function API_DoFinishedCallback(method_name:String) { super('do_finished_callback',arguments); 
			this.method_name = method_name;
		}
		override public function toString():String { return '{API_DoFinishedCallback' + ': method_name=' + JSON.stringify(method_name)+'}'; }
	}
}
