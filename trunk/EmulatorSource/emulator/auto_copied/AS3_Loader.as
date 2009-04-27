// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_Loader.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
/**
 * We use a pause mechanism in case the flash is overloaded.
 * 
 * todo: if the image loaded is a BitMap, 

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

{
	private static var LOG:Logger = new Logger("Loader",10);
	public static function tmpTrace(...args):void {
		LOG.log(args);
	}
	
	private static var EMPTY_BYTE_ARRAY:ByteArray = new ByteArray();	
	public static function getImageLoadByteArray(ev:Event):ByteArray {
		var loadedImage:URLLoader = ev.target as URLLoader;
		StaticFunctions.assert(loadedImage!=null, "loadedImage is null", [ev]);	

// This is a AUTOMATICALLY GENERATED! Do not change!

		var res:ByteArray = loadedImage.data;
		// res can be null for 2032 Stream Error or for 2048 securityError
		return res==null ? EMPTY_BYTE_ARRAY : res;
	}
	public static function isImageLoadFailed(ev:Event):Boolean {
		return getImageLoadByteArray(ev).length==0; 
	}
	
	private static var imageCache:Dictionary/*imageUrl->Event (if loading failed, then the ev.data is an empty ByteArray)*/ = new Dictionary();
	private static var url2RequestArray:Dictionary/*imageUrl->ImageLoadRequest[]*/ = new Dictionary();

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static var pauseQueue:Array/*ImageLoadRequest*/ = null;
	public static var imageLoadingRetry:int = 2;
	
	private static var AS3_Loader_LOG:Logger = new Logger("AS3_Loader",5);	
	{
		AS3_Loader_LOG.log(new AS3_Loader());
	}		
	public function toString():String {		
		var url:String
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		var cachedRes:Array = [];
		for (url in imageCache) {	
			var ev:Event = imageCache[url];
			cachedRes.push(url+
				(!isImageLoadFailed(ev) ? " (size="+(getImageLoadByteArray(ev).length)+")" : " (FAILED: "+ev+")"));
		}
		cachedRes.sort();
		
		var requestRes:Array = [];
		for (url in url2RequestArray) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var arr:Array = url2RequestArray[url];
			requestRes.push(url+" #queue="+arr.length); 
		}
		requestRes.sort();
		
		var res:Array = [];
		res.push("Images cached:");
		StaticFunctions.pushAll(res,cachedRes);
		res.push("\tImages in queue:");
		StaticFunctions.pushAll(res,requestRes);

// This is a AUTOMATICALLY GENERATED! Do not change!

		return  res.join("\n\t\t\t")+
			// pauseQueue might be null
			"\npauseQueue="+pauseQueue;
	}
	
	public static function object2URLVariables(msg:Object):URLVariables {
		var vars:URLVariables = new URLVariables();
		for (var k:String in msg) 
			vars[k] = msg[k];
		return vars;			

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function isNoCache(context:LoaderContext):Boolean {
		return context!=null && context.checkPolicyFile;
	}
	public static var domainURL:String = "";	
	public static function getURL(url:String):String{
		if (url.substr(0,1) == "/"){
			var cutIndex:int = domainURL.indexOf("/",8);
			StaticFunctions.assert(cutIndex>=8, "Illegal url or domain!",[url,domainURL]);
			return domainURL.substring(0,cutIndex) + url;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		if (url.substr(0,7) == "http://") {
			return url;
		}
		return domainURL + url;
	}
	public static function enterPause():void {
		if (pauseQueue!=null) return;
		tmpTrace("enterPause");
		pauseQueue = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function exitPause():void {
		if (pauseQueue==null) return;
		tmpTrace(["exitPause. #pauseQueue=",pauseQueue.length]);
		for each (var req:ImageLoadRequest in pauseQueue)
			loadImageReq(req);
		pauseQueue = null;		
	}
	public static function loadImage(imageUrl:String,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null):void {
		imageUrl = getURL(imageUrl);

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.assert(imageUrl!="","can't load a blank image",[]);
		if (failureHandler==null) {
			failureHandler = function(ev:Event):void {
				criticalError(ev,imageUrl);
			};			
		}
		if(successHandler == null) {
			successHandler = traceHandler
		}	
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		if (isNoCache(context)) {
			// we do not cache graphics and game
			loadURL(imageUrl,successHandler,failureHandler,progressHandler,context);
			return;
		}
		
		var loadRequest:ImageLoadRequest = new ImageLoadRequest();
		loadRequest.imageUrl = imageUrl;
		loadRequest.successHandler = successHandler;

// This is a AUTOMATICALLY GENERATED! Do not change!

		loadRequest.failureHandler = failureHandler;
		loadRequest.progressHandler = progressHandler;
		loadRequest.context = context;
		
		if (pauseQueue==null)
			loadImageReq(loadRequest);
		else
			pauseQueue.push(loadRequest);		
	}
	private static function loadImageReq(loadRequest:ImageLoadRequest):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var imageUrl:String = loadRequest.imageUrl;
		var progressHandler:Function = loadRequest.progressHandler;
		var context:LoaderContext = loadRequest.context; 
		tmpTrace(["Started handling image: ", imageUrl, "reqId=", loadRequest.reqId]); 
		
		// caching mechanism
		if (imageCache[imageUrl] != null) {
			StaticFunctions.assert(url2RequestArray[imageUrl]==null,"url2RequestArray must be empty: ",[imageUrl]);
			// image already finished loading			
			handleExistingImage(imageCache[imageUrl],loadRequest);

// This is a AUTOMATICALLY GENERATED! Do not change!

		} else {
			// image not loaded yet
			
			var requestArray:Array/*ImageLoadRequest*/ = url2RequestArray[imageUrl];
			if (requestArray==null) {
				// the first time we try to load imageUrl
				requestArray = [];
				url2RequestArray[imageUrl] = requestArray;
			}
			requestArray.push(loadRequest);

// This is a AUTOMATICALLY GENERATED! Do not change!

			if (requestArray.length==1) {		
				loadURL(imageUrl,
					// success function
					function(ev:Event):void {
						loadedImageUrl(false, imageUrl,ev);						
					},
					// failure function
					function(ev:Event):void {
						loadedImageUrl(true, imageUrl,ev);						
					},progressHandler,context);		

// This is a AUTOMATICALLY GENERATED! Do not change!

			}
		}		
	}
	private static function loadedImageUrl(isFailure:Boolean, imageUrl:String, ev:Event):void {
		tmpTrace(["loadedImageUrl isFailure=",isFailure," imageUrl=",imageUrl, " event=",ev]);
						
				
		StaticFunctions.assert(isFailure==isImageLoadFailed(ev), "loadedImageUrl failure mismatch",["isFailure=", isFailure, imageUrl, ev]);
		for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
			handleExistingImage(ev,req);		

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		
		StaticFunctions.assert(imageCache[imageUrl]==null,"imageCache must be empty",[imageUrl]);
		// even if loading failed, 
		// we put the event to prevent future attempts to load the image again
		imageCache[imageUrl] = ev;
		delete url2RequestArray[imageUrl];
	}
	
	private static function handleExistingImage(ev:Event,req:ImageLoadRequest):void{		

// This is a AUTOMATICALLY GENERATED! Do not change!

		tmpTrace(["Loaded image: ", req.imageUrl, "reqId=", req.reqId, "ev=",ev]);
		if (isImageLoadFailed(ev)) {
			// previous loading failed 
			req.failureHandler(ev);
		} else {
			var data:ByteArray = getImageLoadByteArray(ev);
			StaticFunctions.assert(data.length>0,"Internal error: image loading did not fail, so data.length>0!",[])
			var byteConverter:Loader = new Loader();
			var dispatcher:IEventDispatcher = byteConverter.contentLoaderInfo;
			// IMPORTANT - there was a garbage collection issue here (if I remove the anonymous function and replace it with req.successHandler)

// This is a AUTOMATICALLY GENERATED! Do not change!

			// therefore the event listener must refer to byteConverter to prevent it from being garbage-collected
			AS3_vs_AS2.myAddEventListener("handleExistingImage", dispatcher,Event.COMPLETE, function (ev:Event):void { removeImageLoaderListeners(byteConverter,req,ev,false); });
			AS3_vs_AS2.myAddEventListener("handleExistingImage", dispatcher, IOErrorEvent.IO_ERROR, function (ev:Event):void { removeImageLoaderListeners(byteConverter,req,ev,true); });
			byteConverter.loadBytes(data,req.context);
		}
	}
	private static function removeImageLoaderListeners(byteConverter:Loader, req:ImageLoadRequest, ev:Event, isFailure:Boolean):void {
		var dispatcher:IEventDispatcher = byteConverter.contentLoaderInfo;
		AS3_vs_AS2.myRemoveAllEventListeners("handleExistingImage", dispatcher);
		tmpTrace(["COMPLETED handling image: ", req.imageUrl, "reqId=", req.reqId, " res=",byteConverter.content, " isFailure=",isFailure, "event=",ev]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (isFailure)
			req.failureHandler(ev);
		else
			req.successHandler(ev);
	}

	public static var EVENT_DATA_DEBUG_LEN:int = 20;
	private static function loadURL(url:Object,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null, retryCount:int=0):void{
		StaticFunctions.assert( retryCount<imageLoadingRetry, "Internal error in loadURL",[]);
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.assert(url!=null,"loadURL was given a null url",[]);
		tmpTrace("trying to load : ",url, " retryCount=",retryCount);
		if (successHandler == null){
			successHandler = traceHandler
		}
		if (failureHandler==null) {
			failureHandler = function (ev:Event):void {criticalError(ev,url as String);};			
		}	
		//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files.  
		//Use the URLLoader class to load text or binary data.

// This is a AUTOMATICALLY GENERATED! Do not change!

		var dispatcher:IEventDispatcher;
		var loader:Loader;
		
		var urlloader:URLLoader;
		var useCache:Boolean = isNoCache(context);
		if (url is String) {
			if(!useCache){
				urlloader = new URLLoader();	
				urlloader.dataFormat = URLLoaderDataFormat.BINARY;
				dispatcher = urlloader;

// This is a AUTOMATICALLY GENERATED! Do not change!

			}else{
				loader = new Loader();
				dispatcher = loader.contentLoaderInfo
			}
		} else {
			urlloader = new URLLoader();	
			dispatcher = urlloader;
		}
				
		var newSuccFunction:Function = function (ev:Event):void { removeLoadUrlListeners(false , url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount); };

// This is a AUTOMATICALLY GENERATED! Do not change!

		var newFailFunction:Function = function (ev:Event):void { removeLoadUrlListeners(true, url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount); };
			
		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,Event.COMPLETE, newSuccFunction); 
		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,IOErrorEvent.IO_ERROR, newFailFunction);
    	AS3_vs_AS2.myAddEventListener("loadURL",dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);
    	    	    	
		if(progressHandler !=null)
			AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,ProgressEvent.PROGRESS,progressHandler)
			
  		try {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

     		var ev:Event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false, false, AS3_vs_AS2.error2String(error));
     		removeLoadUrlListeners(true, url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount);
     	}		
	}
	private static function removeLoadUrlListeners(isFailure:Boolean, url:Object,dispatcher:IEventDispatcher, ev:Event, successHandler:Function,failureHandler:Function, progressHandler:Function,context:LoaderContext, retryCount:int):void {
		AS3_vs_AS2.myRemoveAllEventListeners("loadURL", dispatcher);
		var data:Object	= null;
		if (ev!=null && ev.target!=null && ev.target.hasOwnProperty("data")) data = ev.target.data;
		if (data is ByteArray && (data==null || (data as ByteArray).length==0)) {
			tmpTrace("We loaded an empty ByteArray! so we retry to load the image again");

// This is a AUTOMATICALLY GENERATED! Do not change!

			isFailure = true;
		}
								
		tmpTrace("loaded url=",url," isFailure=",isFailure," event=",ev, " event.data=", 
			// if you load a SWF, then .data is a very long $ByteArray$ "arr":[67,87...] 
			data==null ? 			"no ev.target.data" :
			data is String ? 		StaticFunctions.cutString(data as String,EVENT_DATA_DEBUG_LEN)  : 
			data is ByteArray ?  	["ByteArray.len=",(data as ByteArray).length] :
									"data is not String or ByteArray");
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (!isFailure) {
			successHandler(ev);
		} else {
			if (retryCount+1<imageLoadingRetry) {
				tmpTrace("We retry to load the url=",url);
				loadURL(url,successHandler,failureHandler,progressHandler,context,retryCount+1);
			} else {
				failureHandler(ev);
			}
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	
	
	public static function traceHandler(e:Event):void {
        // we already do tracing in tmpTrace
    }
	public static function criticalError(ev:Event,url:String):void{
		tmpTrace(" Error loading URL: ",url)
		var msg:String;
		if(ev is IOErrorEvent){

// This is a AUTOMATICALLY GENERATED! Do not change!

			msg = "critical IOErrorEvent" + JSON.stringify(ev as IOErrorEvent);
		}else if(ev is SecurityErrorEvent){
			msg = "critical SecurityErrorEvent" + JSON.stringify(ev as SecurityErrorEvent);	
		}
		ErrorHandler.alwaysTraceAndSendReport(msg, [url,ev]);
		StaticFunctions.showError(msg+" in url="+url);
	}

}
}

// This is a AUTOMATICALLY GENERATED! Do not change!

import flash.system.LoaderContext;
class ImageLoadRequest {
	public static var CURR_REQ_ID:int = 1; 
	public var reqId:int = CURR_REQ_ID++;
	
	public var imageUrl:String;
	public var context:LoaderContext;
	public var successHandler:Function;
	public var progressHandler:Function;
	public var failureHandler:Function;

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public function toString():String {
		return imageUrl;
	}
}
