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
	
public final class AS3_Loader
{
	public static function tmpTrace(...args):void {
		StaticFunctions.tmpTrace(["AS3_Loader: ",args]);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	
	private static var imageCache:Dictionary/*imageUrl->ByteArray*/ = new Dictionary();
	private static var url2RequestArray:Dictionary/*imageUrl->ImageLoadRequest[]*/ = new Dictionary();
	public static var imageLoadingRetry:int = 1;
	{
		StaticFunctions.alwaysTrace(["AS3_Loader=",new AS3_Loader()]);
	}
	public function toString():String {
		var res:Array = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

		res.push("Images cached: ");
		for (var url:String in imageCache) {	
			var byteArr:ByteArray = imageCache[url];
			res.push(url+" (size="+(byteArr.length)+")");
		}
		res.push("Images in queue:");
		for (var url:String in url2RequestArray) {
			var arr:Array = url2RequestArray[url];
			res.push(url+" #queue="+arr.length); 
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		return res.join("\n\t\t\t");
	}
	
	public static function object2URLVariables(msg:Object):URLVariables {
		var vars:URLVariables = new URLVariables();
		for (var k:String in msg) 
			vars[k] = msg[k];
		return vars;			
	}
	public static function sendToURL(vars:Object, method:String, url:String, successHandler:Function = null,failureHandler:Function = null):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		tmpTrace("sendToURL=",url);
		var request:URLRequest = new URLRequest(url);
		request.data = object2URLVariables(vars);
		request.method = method;
		loadText(request, successHandler, failureHandler)
	}        
	public static function loadText(urlRequest:URLRequest,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null):void {
		loadURL(urlRequest,successHandler,failureHandler,progressHandler)
	}
	public static function loadImage(imageUrl:String,successHandler:Function = null,failureHandler:Function = null,progressHandler:Function = null,context:LoaderContext = null):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.assert(imageUrl!="",["can't load a blank image"]);
		if (failureHandler==null) {
			failureHandler = function (ev:Event):void {
				criticalError(ev,imageUrl);
			};			
		}
		if(successHandler == null){
			successHandler = traceHandler
		}	
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		if (context!=null && context.checkPolicyFile) {
			// we do not cache graphics and game
			loadURL(imageUrl,successHandler,failureHandler,progressHandler,context);
			return;
		}
		
		// caching mechanism
		if (imageCache[imageUrl] != null) {
			StaticFunctions.assert(url2RequestArray[imageUrl]==null,["url2RequestArray must be empty: ",imageUrl]);

// This is a AUTOMATICALLY GENERATED! Do not change!

			// image already finished loading			
			handleExistingImage(imageCache[imageUrl],successHandler,failureHandler,context);
		} else {
			// image not loaded yet
			var loadRequest:ImageLoadRequest = new ImageLoadRequest();
			loadRequest.successHandler = successHandler;
			loadRequest.failureHandler = failureHandler;
			loadRequest.context = context;
			
			var requestArray:Array/*ImageLoadRequest*/ = url2RequestArray[imageUrl];

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

						var loadedImage:URLLoader = ev.target as URLLoader;					
						StaticFunctions.assert(loadedImage!=null, ["loadedImage is null", imageUrl, ev]);
						var byteArray:ByteArray = loadedImage.data as ByteArray;
						StaticFunctions.assert(byteArray!=null && byteArray.length>0, ["ByteArray of loadedImage is null or empty", imageUrl, ev]);
						
						for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
							handleExistingImage(byteArray,req.successHandler,req.failureHandler,req.context);						
						}
						StaticFunctions.assert(imageCache[imageUrl]==null,["imageCache must be empty: ",imageUrl]);
						imageCache[imageUrl] = byteArray;

// This is a AUTOMATICALLY GENERATED! Do not change!

						delete url2RequestArray[imageUrl];
					},
					// failure function
					function(ev:Event):void {
						for each (var req:ImageLoadRequest in url2RequestArray[imageUrl]) {
							req.failureHandler(ev);						
						}
						delete url2RequestArray[imageUrl];
					},progressHandler,context);		
			}

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
	}
	private static function handleExistingImage(data:ByteArray,successHandler:Function,failureHandler:Function,context:LoaderContext):void{	
		var byteConverter:Loader = new Loader();
		var newSuccessHandler:Function;
		if(true){
			newSuccessHandler = function(ev:Event):void{
				StaticFunctions.tmpTrace(["success loading data in length: ",data.length])
				successHandler(ev)	
			}

// This is a AUTOMATICALLY GENERATED! Do not change!

		}else{
			newSuccessHandler = successHandler
		}
		AS3_vs_AS2.myAddEventListener(byteConverter.contentLoaderInfo,Event.COMPLETE, newSuccessHandler);
		AS3_vs_AS2.myAddEventListener(byteConverter.contentLoaderInfo,IOErrorEvent.IO_ERROR, failureHandler);
		byteConverter.loadBytes(data,context);
	}

	private static function doLoadTrace():Boolean{
		return (T.custom("doLoadTrace",true) as Boolean);

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files.  
		//Use the URLLoader class to load text or binary data.
		var dispatcher:IEventDispatcher;
		var loader:Loader;
		
		var urlloader:URLLoader;
		if (url is String) {
			if((context == null) || (!context.checkPolicyFile)){
				urlloader = new URLLoader();	
				urlloader.dataFormat = URLLoaderDataFormat.BINARY;

// This is a AUTOMATICALLY GENERATED! Do not change!

				dispatcher = urlloader;
			}else{
				loader = new Loader();
				dispatcher = loader.contentLoaderInfo
			}
		} else {
			urlloader = new URLLoader();	
			dispatcher = urlloader;
		}
				

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		});
		if(progressHandler !=null)
			AS3_vs_AS2.myAddEventListener(dispatcher,ProgressEvent.PROGRESS,progressHandler)
		
		
		if(imageLoadingRetry > 1){
			var funcURLRequest:URLRequest = (url is String?new URLRequest(url as String):url as URLRequest)
			var newFailFunction:Function = function(ev:Event):void{
				retryLoadImage(failureHandler,funcURLRequest,ev,1)		
			}

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

				dispatcher = urlLoader;	
			}else if(ev.target is LoaderInfo){
				var loader:Loader = new Loader;
				dispatcher = loader.contentLoaderInfo;
				
			}
			AS3_vs_AS2.myAddEventListener(dispatcher,IOErrorEvent.IO_ERROR, newFailFunction)
	    	AS3_vs_AS2.myAddEventListener(dispatcher, SecurityErrorEvent.SECURITY_ERROR, newFailFunction);	
	    	if(ev.target is URLLoader){
	    		urlLoader.load(imageURLRequest)

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		StaticFunctions.showError(msg+" in url="+url);
	}

}
}
import flash.system.LoaderContext;
class ImageLoadRequest {
	public var context:LoaderContext;
	public var successHandler:Function
	public var failureHandler:Function;

// This is a AUTOMATICALLY GENERATED! Do not change!

}
