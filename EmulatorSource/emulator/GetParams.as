package emulator {
	import flash.display.*;
	import flash.external.*;
	import flash.net.SharedObject;

	public class GetParams extends MovieClip {
		public function GetParams() {
			try{
				var arr:Array;
				var shrParams:SharedObject = SharedObject.getLocal("Come2PlayParams","/");
				arr = shrParams.data.params;
				if (ExternalInterface.available) {
					ExternalInterface.call("getParams", arr);
				}			
				
				stop();
			}catch(err:Error){}
		}
	}
}