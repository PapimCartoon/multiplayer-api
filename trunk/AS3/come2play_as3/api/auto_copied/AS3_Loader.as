package come2play_as3.api.auto_copied
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
/**
 * todo: if the image loaded is a BitMap, 
 * then we should use Loader instead of URLLoader,
 * and cache the bitmapData and return a new BitMap:
 * var loader:Loader = new Loader();
   when loaded:
 	var loadedImage:Bitmap = loader.getChildAt(0) as Bitmap;
	var copyImage:DisplayObject = new Bitmap(loadedImage.bitmapData);
   This will save a lot of space if the image is used many times on the stage
   (or if you have a memory leak) 
 */
public final class AS3_Loader
{
	public static function tmpTrace(...args):void {
		StaticFunctions.tmpTrace(["AS3_Loader: ",args]);
	}
	
	private static var imageCache:Dictionary/*imageUrl->ByteArray*/ = new Dictionary();
	private static var url2RequestArray:Dictionary/*imageUrl->ImageLoadRequest[]*/ = new Dictionary();
	public static var imageLoadingRetry:int = 1;
	{
		StaticFunctions.alwaysTrace(["AS3_Loader=",new AS3_Loader()]);
	}
	public function toString():String {
		var res:Array = [];
		res.push("Images cached: ");
		var url:String
		for (url in imageCache) {	
			var byteArr:ByteArray = imageCache[url];
			res.push(url+" (size="+(byteArr.length)+")");
		}
		res.push("Images in queue:");
		for (url in url2RequestArray) {
			var arr:Array = url2RequestArray[url];
			res.push(url+" #queue="+arr.length); 
		}
		return res.join("\n\t\t\t");
	}
	
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
	public static function isNoCache(context:LoaderContext):Boolean {
		return context!=null && context.checkPolicyFile;
	}
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
		
		
		if (isNoCache(context)) {
			// we do not cache graphics and game
			loadURL(imageUrl,successHandler,failureHandler,progressHandler,context);
			return;
		}
		
		var loadRequest:ImageLoadRequest = new ImageLoadRequest();
		loadRequest.imageUrl = imageUrl;
		loadRequest.successHandler = successHandler;
		loadRequest.failureHandler = failureHandler;
		loadRequest.context = context;
		
		if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["Started handling image: ", imageUrl, "reqId=", loadRequest.reqId]); 
		
		// caching mechanism
		if (imageCache[imageUrl] != null) {
			StaticFunctions.assert(url2RequestArray[imageUrl]==null,["url2RequestArray must be empty: ",imageUrl]);
			// image already finished loading			
			handleExistingImage(imageCache[imageUrl],loadRequest);
		} else {
			// image not loaded yet
			
			var requestArray:Array/*ImageLoadRequest*/ = url2RequestArray[imageUrl];
			if (requestArray==null) {
				// the first time we try to load imageUrl
				requestArray = [];
				url2RequestArray[imageUrl] = requestArray;
			}
			requestArray.push(loadRequest);
			if (requestArray.length==1) {		
				loadURL(imageUrl,
					// success function
					function(ev:Event):void {
						if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["Request queue length ",requestArray.length," imageUrl=",imageUrl]);
						var loadedImage:URLLoader = ev.target as URLLoader;					
						StaticFunctions.assert(loadedImage!=null, ["loadedImage is null", imageUrl, ev]);
						var byteArray:ByteArray = loadedImage.data as ByteArray;
						StaticFunctions.assert(byteArray!=null && byteArray.length>0, ["ByteArray of loadedImage is null or empty", imageUrl, ev]);
						
						for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
							handleExistingImage(byteArray,req);						
						}
						StaticFunctions.assert(imageCache[imageUrl]==null,["imageCache must be empty: ",imageUrl]);
						imageCache[imageUrl] = byteArray;
						delete url2RequestArray[imageUrl];
					},
					// failure function
					function(ev:Event):void {
						if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["Request failed: queue length ",requestArray.length," imageUrl=",imageUrl]);
						for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
							req.failureHandler(ev);						
						}
						delete url2RequestArray[imageUrl];
					},progressHandler,context);		
			}
		}
	}
	public static var TRACE_IMAGE_CACHE:Boolean = true;
	private static function handleExistingImage(data:ByteArray,req:ImageLoadRequest):void{		
		if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["Loaded image: ", req.imageUrl, "reqId=", req.reqId, " size=",data.length]);
		var byteConverter:Loader = new Loader();
		AS3_vs_AS2.myAddEventListener(byteConverter.contentLoaderInfo,Event.COMPLETE, function (ev:Event):void {
			if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["COMPLETED handling image: ", req.imageUrl, "reqId=", req.reqId, " res=",byteConverter.content]);
			req.successHandler(ev);
		});
		AS3_vs_AS2.myAddEventListener(byteConverter.contentLoaderInfo, IOErrorEvent.IO_ERROR, req.failureHandler);
    	AS3_vs_AS2.myAddEventListener(byteConverter.contentLoaderInfo, SecurityErrorEvent.SECURITY_ERROR, req.failureHandler);
		byteConverter.loadBytes(data,req.context);
	}

	private static function doLoadTrace():Boolean{
		return (T.custom("doLoadTrace",true) as Boolean);
	}
	public static var EVENT_DATA_DEBUG_LEN:int = 20;
	private static function loadURL(url:Object,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null):void{
		StaticFunctions.assert(url!=null,["loadURL was given a null url"]);
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
		var useCache:Boolean = isNoCache(context);
		if (url is String) {
			if(!useCache){
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
			if (doLoadTrace())	
				tmpTrace("successfully loaded",url,"Event data :",ev, 
					ev!=null && ev.target!=null && ev.target.hasOwnProperty("data") &&
					// if you load a SWF, then .data is a very long $ByteArray$ "arr":[67,87...] 
					ev.target.data is String ? StaticFunctions.cutString(ev.target.data as String,EVENT_DATA_DEBUG_LEN)  : "no String ev.target.data");
			successHandler(ev);
		});
		if(progressHandler !=null)
			AS3_vs_AS2.myAddEventListener(dispatcher,ProgressEvent.PROGRESS,progressHandler)
		
		
		if(imageLoadingRetry > 1){
			var funcURLRequest:URLRequest = (url is String?new URLRequest(url as String):url as URLRequest)
			var newFailFunction:Function = function(ev:Event):void{
				retryLoadImage(failureHandler,funcURLRequest,ev,1)		
			}
			AS3_vs_AS2.myAddEventListener(dispatcher,IOErrorEvent.IO_ERROR, newFailFunction)
	    	AS3_vs_AS2.myAddEventListener(dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);	
		}else{	
			AS3_vs_AS2.myAddEventListener(dispatcher,IOErrorEvent.IO_ERROR, failureHandler)
	    	AS3_vs_AS2.myAddEventListener(dispatcher, SecurityErrorEvent.SECURITY_ERROR, failureHandler);	
 		} 		
  		try {
	  		if (url is String) {
	  			if(!useCache){
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
	private static function retryLoadImage(failureHandler:Function,imageURLRequest:URLRequest,ev:Event,callNum:int):void{
		if(callNum < imageLoadingRetry){
			callNum++	
			tmpTrace("do another try to load",imageURLRequest.url)
			var newFailFunction:Function = function(ev:Event):void{
				retryLoadImage(failureHandler,imageURLRequest,ev,callNum)		
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
import flash.system.LoaderContext;
class ImageLoadRequest {
	public static var CURR_REQ_ID:int = 1; 
	public var reqId:int = CURR_REQ_ID++;
	
	public var imageUrl:String;
	public var context:LoaderContext;
	public var successHandler:Function
	public var failureHandler:Function;
}
