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
 * todo: if the image loaded is a BitMap, 
 * then we should use Loader instead of URLLoader,
 * and cache the bitmapData and return a new BitMap:

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.tmpTrace(["AS3_Loader: ",args]);
	}
	
	private static var imageCache:Dictionary/*imageUrl->ByteArray*/ = new Dictionary();
	private static var url2RequestArray:Dictionary/*imageUrl->ImageLoadRequest[]*/ = new Dictionary();
	public static var imageLoadingRetry:int = 1;
	
	{
		StaticFunctions.alwaysTrace(["AS3_Loader=",new AS3_Loader()]);
	}	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public function toString():String {		
		var url:String
		
		var cachedRes:Array = [];
		for (url in imageCache) {	
			var byteArr:ByteArray = imageCache[url];
			cachedRes.push(url+" (size="+(byteArr.length)+")");
		}
		cachedRes.sort();
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		var requestRes:Array = [];
		for (url in url2RequestArray) {
			var arr:Array = url2RequestArray[url];
			requestRes.push(url+" #queue="+arr.length); 
		}
		requestRes.sort();
		
		var res:Array = [];
		res.push("Images cached:");
		res.push.apply(null,cachedRes);

// This is a AUTOMATICALLY GENERATED! Do not change!

		res.push("\tImages in queue:");
		res.push.apply(null,requestRes);
		return  res.join("\n\t\t\t");
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
	public static function loadImage(imageUrl:String,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null):void {
		StaticFunctions.assert(imageUrl!="",["can't load a blank image"]);
		if (failureHandler==null) {
			failureHandler = function (ev:Event):void {
				criticalError(ev,imageUrl);
			};			

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		if(successHandler == null){
			successHandler = traceHandler
		}	
		
		
		if (isNoCache(context)) {
			// we do not cache graphics and game
			loadURL(imageUrl,successHandler,failureHandler,progressHandler,context);
			return;

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		
		var loadRequest:ImageLoadRequest = new ImageLoadRequest();
		loadRequest.imageUrl = imageUrl;
		loadRequest.successHandler = successHandler;
		loadRequest.failureHandler = failureHandler;
		loadRequest.context = context;
		
		if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["Started handling image: ", imageUrl, "reqId=", loadRequest.reqId]); 
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		// caching mechanism
		if (imageCache[imageUrl] != null) {
			StaticFunctions.assert(url2RequestArray[imageUrl]==null,["url2RequestArray must be empty: ",imageUrl]);
			// image already finished loading			
			handleExistingImage(imageCache[imageUrl],loadRequest);
		} else {
			// image not loaded yet
			
			var requestArray:Array/*ImageLoadRequest*/ = url2RequestArray[imageUrl];
			if (requestArray==null) {

// This is a AUTOMATICALLY GENERATED! Do not change!

				// the first time we try to load imageUrl
				requestArray = [];
				url2RequestArray[imageUrl] = requestArray;
			}
			requestArray.push(loadRequest);
			if (requestArray.length==1) {		
				loadURL(imageUrl,
					// success function
					function(ev:Event):void {
						loadedImageUrl(false, imageUrl,ev);						

// This is a AUTOMATICALLY GENERATED! Do not change!

					},
					// failure function
					function(ev:Event):void {
						loadedImageUrl(false, imageUrl,ev);						
					},progressHandler,context);		
			}
		}
	}
	private static function loadedImageUrl(isFailure:Boolean, imageUrl:String, ev:Event):void {
		if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["loadedImageUrl isFailure=",isFailure," imageUrl=",imageUrl, " event=",ev]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		var loadedImage:URLLoader = ev.target as URLLoader;					
		StaticFunctions.assert(loadedImage!=null, ["loadedImage is null", imageUrl, ev]);
		var byteArray:ByteArray = loadedImage.data as ByteArray;
		if (!isFailure) StaticFunctions.assert(byteArray!=null && byteArray.length>0, ["ByteArray of loadedImage is null or empty", imageUrl, ev]);
		
		for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
			if (isFailure)
				req.failureHandler(ev);
			else				
				handleExistingImage(byteArray,req);		

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		
		StaticFunctions.assert(imageCache[imageUrl]==null,["imageCache must be empty: ",imageUrl]);
		imageCache[imageUrl] = byteArray;
		delete url2RequestArray[imageUrl];
	}
	
	public static var TRACE_IMAGE_CACHE:Boolean = true;
	private static function handleExistingImage(data:ByteArray,req:ImageLoadRequest):void{		
		if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["Loaded image: ", req.imageUrl, "reqId=", req.reqId, " size=",data.length]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		var byteConverter:Loader = new Loader();
		var dispatcher:IEventDispatcher = byteConverter.contentLoaderInfo;
		// IMPORTANT - there was a garbage collection issue here (if I remove the anonymous function and replace it with req.successHandler)
		// therefore the event listener must refer to byteConverter to prevent it from being garbage-collected
		AS3_vs_AS2.myAddEventListener("handleExistingImage", dispatcher,Event.COMPLETE, function (ev:Event):void { removeImageLoaderListeners(byteConverter,req,ev,false); });
		AS3_vs_AS2.myAddEventListener("handleExistingImage", dispatcher, IOErrorEvent.IO_ERROR, function (ev:Event):void { removeImageLoaderListeners(byteConverter,req,ev,true); });
		byteConverter.loadBytes(data,req.context);
	}
	private static function removeImageLoaderListeners(byteConverter:Loader, req:ImageLoadRequest, ev:Event, isFailure:Boolean):void {
		var dispatcher:IEventDispatcher = byteConverter.contentLoaderInfo;

// This is a AUTOMATICALLY GENERATED! Do not change!

		AS3_vs_AS2.myRemoveAllEventListeners("handleExistingImage", dispatcher);
		if (TRACE_IMAGE_CACHE) StaticFunctions.tmpTrace(["COMPLETED handling image: ", req.imageUrl, "reqId=", req.reqId, " res=",byteConverter.content, " isFailure=",isFailure, "event=",ev]);
		if (isFailure)
			req.failureHandler(ev);
		else
			req.successHandler(ev);
	}

	private static function doLoadTrace():Boolean{
		return (T.custom("doLoadTrace",true) as Boolean);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static var EVENT_DATA_DEBUG_LEN:int = 20;
	private static function loadURL(url:Object,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null, retryCount:int=0):void{
		StaticFunctions.assert( retryCount<imageLoadingRetry, ["Internal error in loadURL"]);
		
		StaticFunctions.assert(url!=null,["loadURL was given a null url"]);
		if(failureHandler == null){
			if(doLoadTrace())	tmpTrace("trying to load : ",url, " retryCount=",retryCount);
		}
		if (successHandler == null){

// This is a AUTOMATICALLY GENERATED! Do not change!

			successHandler = traceHandler
		}
		if (failureHandler==null) {
			failureHandler = function (ev:Event):void {criticalError(ev,url as String);};			
		}	
		//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files.  
		//Use the URLLoader class to load text or binary data.
		var dispatcher:IEventDispatcher;
		var loader:Loader;
		

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

			}
		} else {
			urlloader = new URLLoader();	
			dispatcher = urlloader;
		}
				
		var newSuccFunction:Function = function (ev:Event):void { removeLoadUrlListeners(false , url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount); };
		var newFailFunction:Function = function (ev:Event):void { removeLoadUrlListeners(true, url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount); };
			
		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,Event.COMPLETE, newSuccFunction); 

// This is a AUTOMATICALLY GENERATED! Do not change!

		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,IOErrorEvent.IO_ERROR, newFailFunction);
    	AS3_vs_AS2.myAddEventListener("loadURL",dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);
    	    	    	
		if(progressHandler !=null)
			AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,ProgressEvent.PROGRESS,progressHandler)
			
  		try {
	  		if (url is String) {
	  			if(!useCache){
	  				urlloader.load(new URLRequest(url as String));

// This is a AUTOMATICALLY GENERATED! Do not change!

	  			}else{
	  				loader.load(new URLRequest(url as String),context);
	  			}
			} else {
				urlloader.load(url as URLRequest);
			}
     	} catch(error:Error) {
     		var ev:Event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false, false, AS3_vs_AS2.error2String(error));
     		removeLoadUrlListeners(true, url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount);
     	}		

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	private static function removeLoadUrlListeners(isFailure:Boolean, url:Object,dispatcher:IEventDispatcher, ev:Event, successHandler:Function,failureHandler:Function, progressHandler:Function,context:LoaderContext, retryCount:int):void {
		AS3_vs_AS2.myRemoveAllEventListeners("loadURL", dispatcher);
		var data:Object	= null;
		if (ev!=null && ev.target!=null && ev.target.hasOwnProperty("data")) data = ev.target.data;
		if (data is ByteArray && (data==null || (data as ByteArray).length==0)) {
			tmpTrace("We loaded an empty ByteArray! so we retry to load the image again");
			isFailure = true;
		}
					

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (doLoadTrace()) {			
			tmpTrace("loaded url=",url," isFailure=",isFailure," event=",ev, " event.data=", 
				// if you load a SWF, then .data is a very long $ByteArray$ "arr":[67,87...] 
				data==null ? 			"no ev.target.data" :
				data is String ? 		StaticFunctions.cutString(data as String,EVENT_DATA_DEBUG_LEN)  : 
				data is ByteArray ?  	["ByteArray.len=",(data as ByteArray).length] :
										"data is not String or ByteArray");
		}
		
		if (!isFailure) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			successHandler(ev);
		} else {
			if (retryCount+1<imageLoadingRetry) {
				tmpTrace("We retry to load the url=",url);
				loadURL(url,successHandler,failureHandler,progressHandler,context,retryCount+1);
			} else {
				failureHandler(ev);
			}
		}
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	
	public static function traceHandler(e:Event):void {
        tmpTrace("traceHandler:", e!=null && e.target!=null && e.target.hasOwnProperty("data") ? e.target.data : "No data!");
    }
	public static function criticalError(ev:Event,url:String):void{
		tmpTrace(" Error loading URL: ",url)
		var msg:String;
		if(ev is IOErrorEvent){
			msg = "critical IOErrorEvent" + JSON.stringify(ev as IOErrorEvent);

// This is a AUTOMATICALLY GENERATED! Do not change!

		}else if(ev is SecurityErrorEvent){
			msg = "critical SecurityErrorEvent" + JSON.stringify(ev as SecurityErrorEvent);	
		}
		ErrorHandler.alwaysTraceAndSendReport(msg, [url,ev]);
		StaticFunctions.showError(msg+" in url="+url);
	}

}
}
import flash.system.LoaderContext;

// This is a AUTOMATICALLY GENERATED! Do not change!

class ImageLoadRequest {
	public static var CURR_REQ_ID:int = 1; 
	public var reqId:int = CURR_REQ_ID++;
	
	public var imageUrl:String;
	public var context:LoaderContext;
	public var successHandler:Function
	public var failureHandler:Function;
}
