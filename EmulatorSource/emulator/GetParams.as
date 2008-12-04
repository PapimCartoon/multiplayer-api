package emulator {
	import emulator.auto_copied.JSON;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.external.*;
	import flash.net.SharedObject;
	import flash.text.TextField;

	public class GetParams extends MovieClip {
		public function GetParams() {
			stop();
			close_btn.addEventListener(MouseEvent.CLICK,closeFlash);
			try{
				var sharedObject:String = root.loaderInfo.parameters["sharedObject"];
				if ((sharedObject =="") || (sharedObject ==null)) throw new Error("SharedObject must have a name");
				var shrParams:SharedObject = SharedObject.getLocal(sharedObject,"/");
				var obj:Object = {};
				
				if(root.loaderInfo.parameters["Save"] == "true")
				{
					for(var str:String in root.loaderInfo.parameters)
						obj[str] = root.loaderInfo.parameters[str];	
					dataSaved_txt.text = JSON.stringify(obj)
					shrParams.data.params = obj;
					shrParams.flush();
				}
				else
				{	
					obj = shrParams.data.params
					trace("Loading values: "+JSON.stringify(obj))
					ExternalInterface.call("getParamsInit", obj);		
				}
			}catch(err:Error){
				if (ExternalInterface.available) {
						ExternalInterface.call("errorHandler","Error : "+err.message+" happend in Object "+JSON.stringify(obj));
						stop();
				}		
			}
		}
		private function closeFlash(ev:MouseEvent):void
		{
			ExternalInterface.call("dataSaved");
		}
		
		}
}