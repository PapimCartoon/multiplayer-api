package emulator {
	import emulator.auto_copied.JSON;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.external.*;
	import flash.net.SharedObject;

	public class GetParams extends MovieClip {
		private var _height:int = 20;
		private var savePopUp:savePopup;
		private var loadButtons:Array/*AvailableSave*/ = new Array();
		public function GetParams() {
			stop();
			trace("I am version 6");
			close_btn.addEventListener(MouseEvent.CLICK,closeFlash);		
			if(root.loaderInfo.parameters["Save"] == "true")
			{
				savePopUp = new savePopup();
				savePopUp.x= (stage.stageWidth - savePopUp.width)/2;
				savePopUp.y= (stage.stageHeight - savePopUp.height)/2;
				savePopUp.save_btn.addEventListener(MouseEvent.CLICK,saveGame);
				addChild(savePopUp);
			}
			else
			{	
				loadGames();
				//obj = shrParams.data.params
				//trace("Loading values: "+JSON.stringify(obj))
				//ExternalInterface.call("getParamsInit", obj);		
			}

		}
		private function loadGames():void{
			var sharedObject:String = root.loaderInfo.parameters["sharedObject"];
			if ((sharedObject =="") || (sharedObject ==null)) throw new Error("SharedObject must have a name");
			var shrParams:SharedObject = SharedObject.getLocal(sharedObject,"/");
			for(var str:String in shrParams.data){
				var availableSave:AvailableSave = new AvailableSave();
				_height = availableSave.height;
				availableSave.saveName_txt.text = str;
				availableSave.y = loadButtons.length * (_height+3);
				availableSave.delete_btn.addEventListener(MouseEvent.CLICK,deleteSave)
				availableSave.Load_btn.addEventListener(MouseEvent.CLICK,loadSave)
				addChild(availableSave)
				loadButtons.push(availableSave)		
			}
			
		}
		private function getNumber(ypos:int):int{
			return Math.floor(ypos/(_height+3));
		}
		private function deleteSave(ev:MouseEvent):void{
			var sharedObject:String = root.loaderInfo.parameters["sharedObject"];
			if ((sharedObject =="") || (sharedObject ==null)) throw new Error("SharedObject must have a name");
			var shrParams:SharedObject = SharedObject.getLocal(sharedObject,"/");
			var pos:int = getNumber(ev.stageY);
			delete shrParams.data[loadButtons[pos].saveName_txt.text] ;
			shrParams.flush();
			for each(var availableSave:AvailableSave in loadButtons)
				removeChild(availableSave);
			loadButtons = new Array();
			loadGames();
		}
		private function loadSave(ev:MouseEvent):void{
			var pos:int = getNumber(ev.stageY);
			var sharedObject:String = root.loaderInfo.parameters["sharedObject"];
			if ((sharedObject =="") || (sharedObject ==null)) throw new Error("SharedObject must have a name");
			var shrParams:SharedObject = SharedObject.getLocal(sharedObject,"/");
			var obj:Object = shrParams.data[loadButtons[pos].saveName_txt.text]
			trace("Loading values: "+JSON.stringify(obj))
			ExternalInterface.call("getParamsInit", obj.params);	
		}
		private function saveGame(ev:MouseEvent):void{
			try{
				var sharedObject:String = root.loaderInfo.parameters["sharedObject"];
				if ((sharedObject =="") || (sharedObject ==null)) throw new Error("SharedObject must have a name");
				var shrParams:SharedObject = SharedObject.getLocal(sharedObject,"/");
				var obj:Object = {};
				for(var str:String in root.loaderInfo.parameters)
					obj[str] = root.loaderInfo.parameters[str];	
				if(savePopUp.saveName_txt.text !=null)
				{
					if(shrParams.data[savePopUp.saveName_txt.text]==null) shrParams.data[savePopUp.saveName_txt.text] = new Object();
					shrParams.data[savePopUp.saveName_txt.text].params = obj;
					shrParams.flush();
					removeChild(savePopUp);
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