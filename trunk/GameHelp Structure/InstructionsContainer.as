package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.SimpleButton
	public class InstructionsContainer extends MovieClip
	{
		private var page:int = 1;
		private var loader:Loader = new Loader();
		private var loadedMc:MovieClip;
		private var imageToLoad:String
		private var calledOnce:Boolean
		private var allLoaded:Boolean
		public function InstructionsContainer()
		{	
			imageToLoad = root.loaderInfo.parameters["loadHelp"]==null?"HowToPlay.swf":decodeURIComponent(root.loaderInfo.parameters["loadHelp"].replace(/\+/g," "));
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(ev:Event):void{
			if(calledOnce)	return;
			try{
			calledOnce = true;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadChild);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failedLoad)
			var urlRequest:URLRequest = new URLRequest(imageToLoad)
			loader.load(urlRequest);	
			
			back_btn.y = forward_btn.y = (stage.stageHeight - forward_btn.height)/2
			
			forward_btn.addEventListener(MouseEvent.CLICK,forward)
			back_btn.addEventListener(MouseEvent.CLICK,back)
			back_btn.visible = back_btn.enabled = false;
			}catch(err:Error){
				failedLoad()
			}
		}
		private function failedLoad(ev:Event = null):void{
			forward_btn.visible = forward_btn.enabled = false;
			dispatchEvent(new Event("Failed"))
		}
		private function loadChild(ev:Event):void{
			loadedMc = loader.content as MovieClip;
			loadedMc.stop();
			var bestScale:Number = Math.min(stage.stageWidth/loadedMc.width,stage.stageHeight/loadedMc.height)
			loadedMc.scaleX = loadedMc.scaleY = bestScale;
			loadedMc.x = (stage.stageWidth - loadedMc.width)/2
			loadedMc.y = (stage.stageHeight - loadedMc.height)/2
			
			loadedMc.background_mc.x = -loadedMc.x
			loadedMc.background_mc.y = -loadedMc.y;
			bestScale = int(bestScale)
			loadedMc.background_mc.width = stage.stageWidth / bestScale ;
			loadedMc.background_mc.height = stage.stageHeight / bestScale;
			
			addChildAt(loadedMc,0)
			dispatchEvent(new Event(Event.COMPLETE));
			allLoaded = true;
		}
		private function handlePaging(isUp:Boolean):void{
			if(!allLoaded)	return;
			if(isUp)	
				page++
			else
				page--
			if(page<=1){
				page = 1;
				back_btn.visible = back_btn.enabled = false;
			}else{
				back_btn.visible = back_btn.enabled = true;
			}
			if(page>=loadedMc.totalFrames){
				page = loadedMc.totalFrames;
				forward_btn.visible = forward_btn.enabled = false;
			}else{
				forward_btn.visible = forward_btn.enabled = true;
			}
		}
		
		private function forward(ev:MouseEvent):void{
			handlePaging(true)
			loadedMc.gotoAndStop(page)
		}
		private function back(ev:MouseEvent):void{
			handlePaging(false)
			loadedMc.gotoAndStop(page)
		}
		
	}
}