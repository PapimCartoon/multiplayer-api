// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_Loader.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied{
	import flash.display.*;

// This is a AUTOMATICALLY GENERATED! Do not change!

	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
/**
 * We use a pause mechanism in case the flash is overloaded.
 *
 * Important: Loader has a garbage-collection bug.
 * If you do:

// This is a AUTOMATICALLY GENERATED! Do not change!

 * var loader:Loader = new Loader();
 * ...
 * and do not store a reference to loader, then it might be garbage collected 
 * (even if it has event listeners!)
 * In this file we create a Loader twice, 
 * and we pass the loader object to its event handlers to prevent garbage collection.
 *  
 * todo: if the image loaded is a BitMap, 
 * then we should use Loader instead of URLLoader,
 * and cache the bitmapData and return a new BitMap:

// This is a AUTOMATICALLY GENERATED! Do not change!

 * var loader:Loader = new Loader();
   when loaded:
    // loadEvent.target as LoaderInfo;
 	var loadedImage:Bitmap = loader.getChildAt(0) as Bitmap;
	var copyImage:DisplayObject = new Bitmap(loadedImage.bitmapData);
   This will save a lot of space if the image is used many times on the stage
   (or if we have a memory leak) 
   private static var bitmapCache:Dictionary
   we need to change our loading mechanism, and instead of a Loader, return directly a: 
   * DisplayObject/XML/URLVariables

// This is a AUTOMATICALLY GENERATED! Do not change!

   Currently we have code duplication in the successHandler(loadEvent:Event) {
   	var loader:LoaderInfo = loadEvent.target as LoaderInfo;			
	var child:DisplayObject = loader.content;
	...
 */
public final class AS3_Loader
{
	private static var LOG:Logger = new Logger("Loader",20);
	private static var Progress_LOG:Logger = new Logger("Progress_LOG",40);
	private static var SUCCESS_RETRY_LOG:Logger = new Logger("SUCCESS_RETRY",10);

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function tmpTrace(...args):void {
		LOG.log(args);
	}
	
	private static var EMPTY_BYTE_ARRAY:ByteArray = new ByteArray();	
	public static function getImageLoadByteArray(ev:Event):ByteArray {
		var loadedImage:URLLoader = ev.target as URLLoader;
		StaticFunctions.assert(loadedImage!=null || ev is TimerEvent, "loadedImage is null", ev, ev.target);	
		var res:ByteArray = loadedImage!=null ? loadedImage.data : null;
		// res can be null for 2032 Stream Error or for 2048 securityError

// This is a AUTOMATICALLY GENERATED! Do not change!

		return res==null ? EMPTY_BYTE_ARRAY : res;
	}
	public static function isImageLoadFailed(ev:Event):Boolean {
		return getImageLoadByteArray(ev).length==0; 
	}
	
	
	private static var imageCache:Dictionary/*imageUrl->Event (if loading failed, then the ev.data is an empty ByteArray)*/ = new Dictionary();
	private static var url2RequestArray:Dictionary/*imageUrl->ImageLoadRequest[]*/ = new Dictionary();
	private static var pauseQueue:Array/*ImageLoadRequest*/ = null;

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static var imageLoadingRetry:int = 3;
	
	private static var AS3_Loader_LOG:Logger = new Logger("AS3_Loader",5);	
	{
		AS3_Loader_LOG.hugeLog(new AS3_Loader());
	}		
	public function toString():String {		
		var url:String
		
		var cachedRes:Array = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

		var totalSize:int = 0;
		for (url in imageCache) {	
			var ev:Event = imageCache[url];
			var size:int = isImageLoadFailed(ev) ? 0:getImageLoadByteArray(ev).length;
			cachedRes.push(url+
				(!isImageLoadFailed(ev) ? " (size="+size+")" : " (FAILED: "+ev+")"));
			totalSize+=size;
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
		res.push(AS3_vs_AS2.dictionarySize(imageCache) + " images cached:");
		StaticFunctions.pushAll(res,cachedRes);

// This is a AUTOMATICALLY GENERATED! Do not change!

		res.push("\t"+AS3_vs_AS2.dictionarySize(url2RequestArray) + " images in queue:");
		StaticFunctions.pushAll(res,requestRes);
		return  res.join("\n\t\t\t")+
			// pauseQueue might be null
			"\npauseQueue="+pauseQueue+" #totalSize="+totalSize+" #PREVENT_GC="+AS3_vs_AS2.dictionarySize(PREVENT_GC);
	}
	
	public static function object2URLVariables(msg:Object):URLVariables {
		var vars:URLVariables = new URLVariables();
		for (var k:String in msg) 

// This is a AUTOMATICALLY GENERATED! Do not change!

			vars[k] = msg[k];
		return vars;			
	}
	public static function sendToURL(vars:Object, method:String, url:String, successHandler:Function = null,failureHandler:Function = null, progressHandler:Function = null):void {
		tmpTrace("sendToURL=",url);
		var request:URLRequest = new URLRequest(url);
		request.data = object2URLVariables(vars);
		request.method = method;
		loadText(request, successHandler, failureHandler,progressHandler)
	}        

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static function loadText(urlRequest:URLRequest,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null):void {
		urlRequest.url = getURL(urlRequest.url)
		loadURL(urlRequest,successHandler,failureHandler,progressHandler)
	}
 
 	// are we using Loader or URLLoader?
 	// It is better to use a URLLoader (because once we used Loader, it failed, but still loaded two instances of a game) 	
	public static function isUsingLoader(imageUrl:String, context:LoaderContext):Boolean {
		return imageUrl.indexOf("?")>0 && (imageUrl.indexOf("?preventCache")==-1)// if the url has "?" then we must use Loader (and URLLoader) because we can't pass urlParameters using URLLoader 
			context!=null && context.checkPolicyFile ;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}	
    public static function removeQueryString(url:String):String {
    	var indexOfQuestionMark:int = url.indexOf("?");
    	return indexOfQuestionMark==-1 ? url : url.substr(0, indexOfQuestionMark);
    }
	
	public static var domainURL:String = "";	
	public static function getURL(url:String):String{
		if (url.substr(0,1) == "/"){
			var cutIndex:int = domainURL.indexOf("/",8);

// This is a AUTOMATICALLY GENERATED! Do not change!

			StaticFunctions.assert(cutIndex>=8, "Illegal url or domain!",[url,domainURL]);
			return domainURL.substring(0,cutIndex) + url;
		}
		if (url.substr(0,7) == "http://") {
			return url;
		}
		return domainURL + url;
	}
	public static function enterPause():void {
		if (pauseQueue!=null) return;

// This is a AUTOMATICALLY GENERATED! Do not change!

		tmpTrace("enterPause");
		pauseQueue = [];
	}
	public static function exitPause():void {
		if (pauseQueue==null) return;
		tmpTrace(["exitPause. #pauseQueue=",pauseQueue.length]);
		var copyPause:Array = pauseQueue;
		pauseQueue = null; // we must exit the pause before calling loadImageReq
		for each (var req:ImageLoadRequest in copyPause)
			loadImageReq(req);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function loadImage(imageUrl:String,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null,calledFrom:String="undefined"):void {
		StaticFunctions.assert(imageUrl!="" && imageUrl!=null,"can't load a blank image",[calledFrom]);
		imageUrl = getURL(imageUrl);
		if (failureHandler==null) {
			failureHandler = function(ev:Event):void {
				criticalError(ev,imageUrl,calledFrom);
			};			
		}
		if(successHandler == null) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			successHandler = traceHandler
		}	
		
		
		if (isUsingLoader(imageUrl,context)) {
			// we do not cache graphics and game
			loadURL(imageUrl,successHandler,failureHandler,progressHandler,context);
			return;
		}
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		var loadRequest:ImageLoadRequest = new ImageLoadRequest();
		loadRequest.imageUrl = imageUrl;
		loadRequest.successHandler = successHandler;
		loadRequest.failureHandler = failureHandler;
		loadRequest.progressHandler = progressHandler;
		loadRequest.context = context;
		
		loadImageReq(loadRequest);		
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
			if (pauseQueue!=null) {
				pauseQueue.push(loadRequest);	
				return;
			}		
			var requestArray:Array/*ImageLoadRequest*/ = url2RequestArray[imageUrl];
			if (requestArray==null) {
				// the first time we try to load imageUrl
				requestArray = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

				url2RequestArray[imageUrl] = requestArray;
			}
			requestArray.push(loadRequest);
			if (requestArray.length==1) {		
				loadURL(imageUrl,
					// success function
					function(ev:Event):void {
						loadedImageUrl(false, imageUrl,ev);						
					},
					// failure function

// This is a AUTOMATICALLY GENERATED! Do not change!

					function(ev:Event):void {
						loadedImageUrl(true, imageUrl,ev);						
					},progressHandler,context);		
			}
		}		
	}
	private static function loadedImageUrl(isFailure:Boolean, imageUrl:String, ev:Event):void {
		tmpTrace(["loadedImageUrl isFailure=",isFailure," imageUrl=",imageUrl, " event=",ev]);
						
				

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.assert(isFailure==isImageLoadFailed(ev), "loadedImageUrl failure mismatch",["isFailure=", isFailure, imageUrl, ev]);
		for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
			handleExistingImage(ev,req);		
		}
		
		StaticFunctions.assert(imageCache[imageUrl]==null,"imageCache must be empty",[imageUrl]);
		// even if loading failed, 
		// we put the event to prevent future attempts to load the image again
		imageCache[imageUrl] = ev;
		delete url2RequestArray[imageUrl];

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	
	private static function handleExistingImage(ev:Event,req:ImageLoadRequest):void{		
		tmpTrace(["Loaded image: ", req.imageUrl, "reqId=", req.reqId, "ev=",ev]);
		if (isImageLoadFailed(ev)) {
			// previous loading failed 
			req.failureHandler(ev);
		} else {
			var data:ByteArray = getImageLoadByteArray(ev);
			StaticFunctions.assert(data.length>0,"Internal error: image loading did not fail, so data.length>0!",[])

// This is a AUTOMATICALLY GENERATED! Do not change!

			var byteConverter:Loader = new Loader();
			PREVENT_GC[byteConverter] = true;
			var dispatcher:IEventDispatcher = byteConverter.contentLoaderInfo;
			// IMPORTANT - there was a garbage collection issue here (if I remove the anonymous function and replace it with req.successHandler)
			// therefore the event listener must refer to byteConverter to prevent it from being garbage-collected			
			var failureFunc:Function = function (ev:Event):void { removeImageLoaderListeners(byteConverter,dispatcher,req,ev,true); };
			var successFunc:Function = function (ev:Event):void { removeImageLoaderListeners(byteConverter,dispatcher,req,ev,false); };
			AS3_vs_AS2.myAddEventListener("handleExistingImage", dispatcher,Event.COMPLETE, successFunc); 
			var errorEvents:Array/*String*/ = [IOErrorEvent.IO_ERROR, HTTPStatusEvent.HTTP_STATUS, SecurityErrorEvent.SECURITY_ERROR];
			for (var errorEvent:String in errorEvents)

// This is a AUTOMATICALLY GENERATED! Do not change!

				AS3_vs_AS2.myAddEventListener("handleExistingImage", dispatcher, errorEvent, failureFunc);
				
			var context:LoaderContext = null;
			if (req.context!=null) {
				context = new LoaderContext(false, req.context.applicationDomain); 
			}  
			byteConverter.loadBytes(data,context);
		}
	}
	private static function removeImageLoaderListeners(byteConverter:Loader, dispatcher:IEventDispatcher, req:ImageLoadRequest, ev:Event, isFailure:Boolean):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		delete PREVENT_GC[byteConverter];
		AS3_vs_AS2.myRemoveAllEventListeners("handleExistingImage", dispatcher);
		tmpTrace(["COMPLETED handling image: ", req.imageUrl, "reqId=", req.reqId, " res=",byteConverter.content, " isFailure=",isFailure, "event=",ev]);
		if (isFailure)
			req.failureHandler(ev);
		else
			req.successHandler(ev);
	}

	private static var PREVENT_GC:Dictionary = new Dictionary();

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public static var EVENT_DATA_DEBUG_LEN:int = 1000;
	public static var TIMEOUT_TIMER_MILLI:int = 30000;
	private static function loadURL(url:Object/*String or URLRequest*/,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null, retryCount:int=0,calledFrom:String="undefined"):void{
		StaticFunctions.assert( url is String || url is URLRequest, "url must be String or URLRequest", url);
		StaticFunctions.assert( retryCount<imageLoadingRetry, "Internal error in loadURL",[]);
		
		StaticFunctions.assert(url!=null,"loadURL was given a null url",[]);
		tmpTrace("trying to load : ",url, " retryCount=",retryCount);
		if (successHandler == null){

// This is a AUTOMATICALLY GENERATED! Do not change!

			successHandler = traceHandler
		}
		if (failureHandler==null) {			
			failureHandler = function (ev:Event):void {criticalError(ev,url is String ? url as String : (url as URLRequest).url,calledFrom);};			
		}	
		//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files.  
		//Use the URLLoader class to load text or binary data.
		var dispatcher:IEventDispatcher;
		var loader:Loader = null;		
		var urlloader:URLLoader;

// This is a AUTOMATICALLY GENERATED! Do not change!

		var isLoader:Boolean;
		if (url is String) {
			isLoader = isUsingLoader(url as String,context);
			if(!isLoader){
				// using URLLoader
				urlloader = new URLLoader();	
				urlloader.dataFormat = URLLoaderDataFormat.BINARY;
				dispatcher = urlloader;
			}else{
				loader = new Loader();

// This is a AUTOMATICALLY GENERATED! Do not change!

				PREVENT_GC[loader] = true;
				dispatcher = loader.contentLoaderInfo
			}
		} else {
			urlloader = new URLLoader();	
			dispatcher = urlloader;
		}
				
		// garbage-collection bug: we must refer to loader to prevent it from being garbage-collected!
		var failTimer:AS3_Timer = new AS3_Timer("LoadFailTimer",TIMEOUT_TIMER_MILLI);	

// This is a AUTOMATICALLY GENERATED! Do not change!

		var newSuccFunction:Function = function (ev:Event):void { removeLoadUrlListeners(false, loader,url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount,failTimer); };
		var newFailFunction:Function = function (ev:Event):void { removeLoadUrlListeners(true , loader,url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount,failTimer); };
		AS3_vs_AS2.myAddEventListener("failTimer",failTimer,TimerEvent.TIMER, newFailFunction); 
		
		var traceFunc:Function = function (ev:Event):void { tmpTrace("Only tracing (for debugging purposes) event for ",url, "event=",ev," loader.content=",loader==null ? "no loader" : loader.content); };
		var allTraceEvents:Array = [Event.ACTIVATE, Event.DEACTIVATE,Event.INIT,Event.OPEN,Event.UNLOAD,HTTPStatusEvent.HTTP_STATUS];			
		for each (var event:String in allTraceEvents)
			AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,event, traceFunc); 			
			
		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,Event.COMPLETE, newSuccFunction); 

// This is a AUTOMATICALLY GENERATED! Do not change!

		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,IOErrorEvent.IO_ERROR, newFailFunction);
    	AS3_vs_AS2.myAddEventListener("loadURL",dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);
    	  
    	var newProgressHandler:Function = function(ev:ProgressEvent):void{
    		Progress_LOG.log("progress in:",url,"ev=",ev)
    		if(progressHandler !=null)	progressHandler(ev);
    		failTimer.reset();
    		failTimer.start();
    	};	    	
		AS3_vs_AS2.myAddEventListener("loadURL",dispatcher,ProgressEvent.PROGRESS,newProgressHandler)

// This is a AUTOMATICALLY GENERATED! Do not change!

  		try {
	  		if (url is String) {
	  			var urlString:String = url as String;
	  			if(!isLoader){
	  				urlloader.load(new URLRequest(urlString));
	  			}else{
	  				// not using cache
	  				tmpTrace("Using Loader! urlString=",urlString, " with context=",context);
	  				loader.load(new URLRequest(urlString),context);
	  			}

// This is a AUTOMATICALLY GENERATED! Do not change!

			} else {
				urlloader.load(url as URLRequest);
			}
     	} catch(error:Error) {
     		var ev:Event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false, false, AS3_vs_AS2.error2String(error));
     		removeLoadUrlListeners(true, loader, url,dispatcher,ev,successHandler, failureHandler,progressHandler, context, retryCount,failTimer);
     	}		
	}
	public static var RETRY_DELAY_MILLI:int = 3000;
	public static var MIN_LEN:int = 3;

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static function removeLoadUrlListeners(isFailure:Boolean, loader:Loader, url:Object/*String or URLRequest*/,dispatcher:IEventDispatcher, ev:Event, successHandler:Function,failureHandler:Function, progressHandler:Function,context:LoaderContext, retryCount:int,failTimer:AS3_Timer):void {
		// I don't use the loader, but I still pass it to prevent garbage collection
		failTimer.stop();
		AS3_vs_AS2.myRemoveAllEventListeners("failTimer",failTimer)	
		
		if (loader!=null) delete PREVENT_GC[loader];
		
		AS3_vs_AS2.myRemoveAllEventListeners("loadURL", dispatcher);
		var data:Object	= null;
		if (ev!=null && ev.target!=null && ev.target.hasOwnProperty("data")) data = ev.target.data;

// This is a AUTOMATICALLY GENERATED! Do not change!

		var len:int = data==null ? int.MAX_VALUE : // null is a legal case! e.g., (todo: find an example)
			data is String ? (data as String).length : 
			data is ByteArray ? (data as ByteArray).length : 
			-1;
		StaticFunctions.assert(len>=0, "Loaded an illegal type for data: ",data);
			
		if (len<=MIN_LEN) {
			tmpTrace("We loaded a String/ByteArray which are too small! so we retry to load the image again");
			isFailure = true;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

								
		tmpTrace("loaded url=",url," isFailure=",isFailure," event=",ev, " len=",len, " ev.target.data=", 
			// if you load a SWF, then .data is a very long $ByteArray$ "arr":[67,87...] 
			data==null ? 			"no ev.target.data" :
			data is String ? 		StaticFunctions.cutString(data as String,EVENT_DATA_DEBUG_LEN)  : 
						  			"ByteArray");
		var urlString:String
		
		if (url is URLRequest){
			var tempUrlRequest:URLRequest = url as URLRequest

// This is a AUTOMATICALLY GENERATED! Do not change!

			urlString = tempUrlRequest.url;
		}else{
			urlString = url as String
		}
		if (!isFailure) {
			if (retryCount>0){
				 SUCCESS_RETRY_LOG.log("Retry mechanism worked for url=",url);
				 AS3_GATracker.COME2PLAY_TRACKER.trackEvent("Loading","Image Loading","Succeded retry "+retryCount+" on "+removeQueryString(urlString),1)
			}
			tmpTrace("calling successHandler=",successHandler)

// This is a AUTOMATICALLY GENERATED! Do not change!

			successHandler(ev);
		} else {
			AS3_GATracker.COME2PLAY_TRACKER.trackEvent("Loading","Image Loading","Failed retry "+retryCount+" on "+removeQueryString(urlString),1)
			if(loader!=null)	loader.unload();
			if (dispatcher is URLLoader)  {
				try{
					var urlLoader:URLLoader = (dispatcher as URLLoader)
					urlLoader.close();
				}catch(err:Error){
					tmpTrace(err,"Stream was already closed for ",urlLoader);

// This is a AUTOMATICALLY GENERATED! Do not change!

				}
			}		
			if (retryCount+1<imageLoadingRetry) {
				tmpTrace("We retry to load the url=",url,"retry delay is",RETRY_DELAY_MILLI);
				urlString+=((urlString.indexOf("?") == -1)?"?":"&")+"preventCache="+int(Math.random()*int.MAX_VALUE)
				if (url is URLRequest){
					(url as URLRequest).url = urlString;
				}else{
					url = urlString;
				}

// This is a AUTOMATICALLY GENERATED! Do not change!

				ErrorHandler.myTimeout("RetryDelay",function():void {
					loadURL(url,successHandler,failureHandler,progressHandler,context,retryCount+1);
				},RETRY_DELAY_MILLI);
			} else {
				failureHandler(ev);
			}
		}
	}
	
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function traceHandler(e:Event):void {
        // we already do tracing in tmpTrace
    }
	public static function criticalError(ev:Event,url:String,calledFrom:String ="undefined"):void{
		tmpTrace(" Error loading URL: ",url,"From :",calledFrom)
		var msg:String;
		if(ev is IOErrorEvent){
			msg = "critical IOErrorEvent" + JSON.stringify(ev as IOErrorEvent);
		}else if(ev is SecurityErrorEvent){
			msg = "critical SecurityErrorEvent" + JSON.stringify(ev as SecurityErrorEvent);	

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		ErrorHandler.alwaysTraceAndSendReport(msg, [url,ev]);
		StaticFunctions.showError(msg+" in url="+url);
	}

}
}
import flash.system.LoaderContext;
class ImageLoadRequest {
	public static var CURR_REQ_ID:int = 1; 

// This is a AUTOMATICALLY GENERATED! Do not change!

	public var reqId:int = CURR_REQ_ID++;
	
	public var imageUrl:String;
	public var context:LoaderContext;
	public var successHandler:Function;
	public var progressHandler:Function;
	public var failureHandler:Function;
	
	public function toString():String {
		return imageUrl;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
