package come2play_as3.minesweeper
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class Come2PlayScoreConnect
	{
		static private var didFail:Boolean
		static private var scoreConnect:DisplayObject
		static private var waitingScores:Array/*Object*/ = []
		static private var myData:Object
		static private var sendChannel:String;
		static private var _stage:Stage
		//localConnection
		static private var initConnection:LocalConnection
		static private var receiving_lc:LocalConnection
		static private var sending_lc:LocalConnection
		
		static private var successFunc:Function
		static private var failFunc:Function
		static public function init(stage:Stage,game_id:String,successFunc:Function = null,failFunc:Function = null):void{
			if(stage == null)	throw new Error("Stage cannot be null")
			if(_stage != null)	{
				if(failFunc==null){
					throw new Error("cannot init more then once")
				}else{
					failFunc("cannot init more then once")
				}
				return;		
			}
			_stage = stage;
			myData = {game_id:game_id}
			for(var key:String in _stage.loaderInfo){
				myData[key] = _stage.loaderInfo[key]
			}
			myData["width"] = _stage.stageWidth
			myData["height"] = _stage.stageHeight
			myData["url"] = _stage.loaderInfo.url
			Come2PlayScoreConnect.successFunc = successFunc
			Come2PlayScoreConnect.failFunc = function(reason:Object):void{
				didFail = true;
				if(failFunc ==null)	return
				if(reason is Event){
					var ev:Event = reason as Event;
				}else{
					failFunc.apply(null,[reason as String])
					return
				}
				
				var errorText:String;
				
				if(ev.target is URLLoader){
					errorText = "failed loading bridge location"
				}else if(ev is IOErrorEvent){
					errorText = "IOErrorEvent loading bridge location "(ev as IOErrorEvent).text
				}else if(ev is SecurityErrorEvent){
					if(ev.target is LoaderInfo){
						errorText = "SecurityErrorEvent loading bridge location "+(ev as SecurityErrorEvent).text
					}else{
						errorText = "SecurityErrorEvent while connecting to local connection "(ev as SecurityErrorEvent).text
					}
				}else if(ev is AsyncErrorEvent){
					errorText = "AsyncErrorEvent while connecting to local connection "+(ev as AsyncErrorEvent).error
				}else{
					errorText = ev.toString();
				}
				trace(errorText)
				failFunc.apply(null,[errorText])
					
			}
			var clientCallbacks:Object = {}
			clientCallbacks.makeHandshake = Come2PlayScoreConnect.makeHandshake
			initConnection = new LocalConnection()
			initConnection.client = clientCallbacks;
			initConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,Come2PlayScoreConnect.failFunc)
			initConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,Come2PlayScoreConnect.failFunc)
			initConnection.addEventListener(StatusEvent.STATUS,handleStatusEvent)
			initConnection.allowDomain("*")
			initConnection.allowInsecureDomain("*")
			try{
				initConnection.connect("_bridgeSend")
			}catch(err:Error){
				didFail = true;
				if(failFunc !=null)	failFunc.apply(null,["_bridgeSend: "+err.message])
				return
			}
			var url:String = "http://www.come2play.com/shared/api/singlePlayer/get_swf_version.asp?type=singlePlayerBridgeAS2&game_id="+myData.game_id
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			var urlLoader:URLLoader = new URLLoader()
			urlLoader.load(request)
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,Come2PlayScoreConnect.failFunc)
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,Come2PlayScoreConnect.failFunc)
			urlLoader.addEventListener(Event.COMPLETE,loadBridge);
		}
		static private function scoreSent():void{
			trace("scoreSent")
			_stage.addChild(scoreConnect)	
			if(successFunc!=null)	successFunc();
		}
		static private function handleStatusEvent(ev:StatusEvent):void{

		}
		static private function scorefailed(str:String):void{
			_stage.addChild(scoreConnect)
		}
		static private var myClient:Object;
		static private function makeHandshake(channel:String,callBackChannel:String):void {
			initConnection.close();
			myClient = {}
			myClient.scoreSent = Come2PlayScoreConnect.scoreSent;
			myClient.scorefailed = Come2PlayScoreConnect.scorefailed;
			receiving_lc = new LocalConnection();
			receiving_lc.client = myClient;
			receiving_lc.allowInsecureDomain("*")
			receiving_lc.allowDomain("*")
			receiving_lc.connect(callBackChannel);
			receiving_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,failFunc)
			receiving_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failFunc)
			sendChannel = channel;
			sending_lc = new LocalConnection()
			sending_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,failFunc)
			sending_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failFunc)
			sending_lc.addEventListener(StatusEvent.STATUS,handleStatusEvent)
			sending_lc.send(sendChannel, "init", myData)
			if(successFunc!=null)	successFunc()
			var scoresToSend:Array = waitingScores.concat()
			for each(var score:Object in scoresToSend){
				sendScore(score.score,score.successFunc,score.failFunc)
			}
			waitingScores = [];
		}
		
		static public function loadBridge(event:Event):void{
			try{
				var urlLoader:URLLoader = event.target as URLLoader
				var urlVars:URLVariables = new URLVariables(urlLoader.data as String)
				if(urlVars["result"] != "true"){
					failFunc(event)	
					return;	
				}	
			}catch(err:Error){
				failFunc(err.message)
				return;
			}
			var loader:Loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadedScoreConnect)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failFunc)
			loader.load(new URLRequest(urlVars["file"]))
		}
		
		static public function sendScore(score:Number,successFunc:Function = null,failFunc:Function = null):void{
			if(failFunc==null){
				Come2PlayScoreConnect.failFunc = function(reason:String):void{
					throw new Error("unhandeld error: "+reason)
				}
			}
			Come2PlayScoreConnect.successFunc = successFunc;
			if(_stage == null)	failFunc("Must call Come2PlayScoreConnect.init before sending score")
			if(scoreConnect == null){
				if(didFail){
					failFunc("can't send message if init failed")
					return;
				}
				waitingScores.push({score:score,successFunc:successFunc,failFunc:failFunc})
			}else{
				try{
					sending_lc.send(sendChannel,"getScore",score)
				}catch(err:Error){
					failFunc(err.message)
				}
			}
		}
		static private function loadedScoreConnect(ev:Event):void{
			var loaderInfo:LoaderInfo = ev.target as LoaderInfo;
			scoreConnect = loaderInfo.content
			_stage.addChild(scoreConnect)
		}
	}
}