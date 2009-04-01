package come2play_as3.api.auto_copied
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
public final class AS3_Loader
{
	public static function tmpTrace(...args):void {
		StaticFunctions.tmpTrace(["AS3_Loader: ",args]);
	}
	
	private static var imageCache:Dictionary = new Dictionary();
	public static var imageLoadingRetry:int = 1;
	
	
	public static function object2URLVariables(msg:Object):URLVariables {
		var vars:URLVariables = new URLVariables();
		for (var k:String in msg) 
			vars[k] = msg[k];
		return vars;			
	}
	public static function sendToURL(vars:Object, method:String, url:String, successHandler:Function = null,failureHandler:Function = null):void {
		tmpTrace("sendToURL=",url);
		var request:URLRequest = new URLRequest(url);
		request.data = object2URLVariables(vars);
		request.method = method;
		loadText(request, successHandler, failureHandler)
	}        
	public static function loadText(urlRequest:URLRequest,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null):void {
		loadURL(urlRequest,successHandler,failureHandler,progressHandler)
	}
	private static var imagesInLoad:Array = new Array();
	private static var imagesInQueue:Array = new Array();	
	public static function loadImage(imageUrl:String,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null):void {
		StaticFunctions.assert(imageUrl!="",["can't load a blank image"]);
		if (failureHandler==null) {
			failureHandler = function (ev:Event):void {
				criticalError(ev,imageUrl);
			};			
		}
		if(successHandler == null){
			successHandler = traceHandler
		}	
		if((imageCache[imageUrl] == null) && (imagesInLoad.indexOf(imageUrl)==-1)){
			imagesInLoad.push(imageUrl)
			if((context ==null) || (!context.checkPolicyFile)){
				loadURL(imageUrl,function(ev:Event):void{
				imageCache[imageUrl] = ev;
				imagesInLoad.splice(imagesInLoad.indexOf(imagesInLoad),1);
				handleExistingImage(ev,successHandler,failureHandler,context);
				for(var i:int=0;i<imagesInQueue.length;i++){
					if(imagesInQueue[i].imageUrl == imageUrl){
						handleExistingImage(ev,imagesInQueue[i].successHandler,imagesInQueue[i].failureHandler,context);
						imagesInQueue.splice(i,1);
						i--;
					}
				}
				},failureHandler,progressHandler,context);
			}else{
				loadURL(imageUrl,successHandler,failureHandler,progressHandler,context);
			}
		}else if(imageCache[imageUrl] == null){
			imagesInQueue.push({successHandler:successHandler,failureHandler:failureHandler,imageUrl:imageUrl})
		}else{
			handleExistingImage(imageCache[imageUrl],successHandler,failureHandler,context)
		}
	}
	private static function handleExistingImage(ev:Event,successHandler:Function,failureHandler:Function,context:LoaderContext):void{	
		var ByteConverter:Loader = new Loader();
		var urlLoader:URLLoader = ev.target as URLLoader;
		AS3_vs_AS2.myAddEventListener(ByteConverter.contentLoaderInfo,Event.COMPLETE,function(ev:Event):void{
			 successHandler(ev);
		});
		AS3_vs_AS2.myAddEventListener(ByteConverter.contentLoaderInfo,IOErrorEvent.IO_ERROR,failureHandler);
		ByteConverter.loadBytes (urlLoader.data,context);
	}

	private static function doLoadTrace():Boolean{
		return (T.custom("doLoadTrace",true) as Boolean);
	}
	public static var EVENT_DATA_DEBUG_LEN:int = 20;
	private static function loadURL(url:Object,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null):void{
		if(failureHandler == null){
			if(doLoadTrace())	tmpTrace("trying to load : ",url);
		}
		if(successHandler == null){
			successHandler = traceHandler
		}
		//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files.  
		//Use the URLLoader class to load text or binary data.
		var dispatcher:IEventDispatcher;
		var loader:Loader;
		
		var urlloader:URLLoader;
		if (url is String) {
			if((context == null) || (!context.checkPolicyFile)){
				urlloader = new URLLoader();	
				urlloader.dataFormat = URLLoaderDataFormat.BINARY;
				dispatcher = urlloader;
			}else{
				loader = new Loader();
				dispatcher = loader.contentLoaderInfo
			}
		} else {
			urlloader = new URLLoader();	
			dispatcher = urlloader;
		}
				
		if (failureHandler==null) {
			failureHandler = function (ev:Event):void {criticalError(ev,url as String);};			
		}	
		AS3_vs_AS2.myAddEventListener(dispatcher,Event.COMPLETE, function(ev:Event):void{
			if(doLoadTrace())	tmpTrace("successfully loaded",url,"Event data :",ev, 
				ev!=null && ev.target!=null && ev.target.hasOwnProperty("data") ? (ev.target.data is String ? StaticFunctions.cutString(ev.target.data as String,EVENT_DATA_DEBUG_LEN) : ev.target.data) : "no ev.target.data");
			successHandler(ev);
		});
		if(progressHandler !=null)
			AS3_vs_AS2.myAddEventListener(dispatcher,ProgressEvent.PROGRESS,progressHandler)
		
		
		if(imageLoadingRetry > 1){
			var funcURLRequest:URLRequest = (url is String?new URLRequest(url as String):url as URLRequest)
			var newFailFunction:Function = function(ev:Event):void{
				doCallError(failureHandler,funcURLRequest,ev,1)		
			}
			AS3_vs_AS2.myAddEventListener(dispatcher,IOErrorEvent.IO_ERROR, newFailFunction)
	    	AS3_vs_AS2.myAddEventListener(dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);	
		}else{	
			AS3_vs_AS2.myAddEventListener(dispatcher,IOErrorEvent.IO_ERROR, failureHandler)
	    	AS3_vs_AS2.myAddEventListener(dispatcher, SecurityErrorEvent.SECURITY_ERROR, failureHandler);	
 		} 		
  		try {
	  		if (url is String) {
	  			if((context == null) || (!context.checkPolicyFile)){
	  				urlloader.load(new URLRequest(url as String));
	  			}else{
	  				loader.load(new URLRequest(url as String),context);
	  			}
			} else {
				urlloader.load(url as URLRequest);
			}
     	} catch(error:Error) {
     		failureHandler( new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false, false, AS3_vs_AS2.error2String(error)));
     	}		
	}
	private static function doCallError(failureHandler:Function,imageURLRequest:URLRequest,ev:Event,callNum:int):void{
		if(callNum < imageLoadingRetry){
			callNum++	
			tmpTrace("do another try to load",imageURLRequest.url)
			var newFailFunction:Function = function(ev:Event):void{
				doCallError(failureHandler,imageURLRequest,ev,callNum)		
			}		
			var dispatcher:IEventDispatcher;	
			if(ev.target is URLLoader){
				var urlLoader:URLLoader = new URLLoader;
				dispatcher = urlLoader;	
			}else if(ev.target is LoaderInfo){
				var loader:Loader = new Loader;
				dispatcher = loader.contentLoaderInfo;
				
			}
			AS3_vs_AS2.myAddEventListener(dispatcher,IOErrorEvent.IO_ERROR, newFailFunction)
	    	AS3_vs_AS2.myAddEventListener(dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);	
	    	if(ev.target is URLLoader){
	    		urlLoader.load(imageURLRequest)
	    	}else if(ev.target is LoaderInfo){
	    		loader.load(imageURLRequest)
	    	}  	
		}else{
			failureHandler(ev);
			return
		}		
	}
	public static function traceHandler(e:Event):void {
        tmpTrace("traceHandler:", e!=null && e.target!=null && e.target.hasOwnProperty("data") ? e.target.data : "No data!");
    }
	public static function criticalError(ev:Event,url:String):void{
		tmpTrace(" Error loading URL: ",url)
		var msg:String;
		if(ev is IOErrorEvent){
			msg = "critical IOErrorEvent" + JSON.stringify(ev as IOErrorEvent);
		}else if(ev is SecurityErrorEvent){
			msg = "critical SecurityErrorEvent" + JSON.stringify(ev as SecurityErrorEvent);	
		}
		ErrorHandler.alwaysTraceAndSendReport(msg, [url,ev]);
		StaticFunctions.showError(msg+" in url="+url);
	}

}
}