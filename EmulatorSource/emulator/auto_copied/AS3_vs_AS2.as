// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_vs_AS2.as'
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
import flash.text.*;
import flash.utils.*;
	
public final class AS3_vs_AS2
{
	public static const isAS3:Boolean = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public static var NATIVE_SERIALIZERS:Array/*NativeSerializable*/;
	public static function registerNativeSerializers():void {
		var classes:Array/*Class*/ = [
			AS3_ErrorSerializable,
			AS3_XMLSerializable,
			AS3_ByteArraySerializable,
			AS3_DictionarySerializable,
			AS3_DateSerializable
		];	

// This is a AUTOMATICALLY GENERATED! Do not change!

		NATIVE_SERIALIZERS = [];
		for each (var serializerClass:Class in classes) {
			var serializer:AS3_NativeSerializable = new serializerClass();
			SerializableClass.registerClassAlias(serializer.__CLASS_NAME__, serializerClass);
			serializer.register();
			NATIVE_SERIALIZERS.push(serializer);
		}
	}
	
	public static function getDisplayObjectDesc(movie:DisplayObject):String {

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (movie==null || movie.name==null || movie==StaticFunctions.someMovieClip) return '';
		return getDisplayObjectDesc(movie.parent)+"."+movie.name +
			(movie is MovieClip ? "[frame="+(movie as MovieClip).currentLabel +"]" : "");		
	}
	public static function specialToString(o:Object):String {
		if (o is DisplayObject) return getDisplayObjectDesc(o as DisplayObject); // instead of the default toString which returns "[object peshka2_15]", I want to return the fullname and current keyframe (if it is a movieclip)
		if (o is URLRequest) return (o as URLRequest).url;
		var nativeSerializer:AS3_NativeSerializable = null;
		for each (var serializer:AS3_NativeSerializable in NATIVE_SERIALIZERS) {
			nativeSerializer = serializer.fromNative(o);

// This is a AUTOMATICALLY GENERATED! Do not change!

			if (nativeSerializer!=null) break;
		}
		if (nativeSerializer!=null) return nativeSerializer.toString();
		return o.toString();		
	}
	public static function byteArr2Str(byteArr:ByteArray):String {
		return JSON.stringify(AS3_ByteArraySerializable.byteArr2Arr(byteArr));		
	}
	public static function copyObjectUsingByteArray(o:Object):Object {
		// see also flash.net.registerClassAlias

// This is a AUTOMATICALLY GENERATED! Do not change!

		var b:ByteArray = new ByteArray();
		b.writeObject(o);
		b.position = 0;
		return b.readObject();
	}
	
	public static function isNumber(o:Object):Boolean {
		return o is Number;
	}
	public static function isBoolean(o:Object):Boolean {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return o is Boolean;
	}
	public static function isString(o:Object):Boolean {
		return o is String;
	}
	public static function isArray(o:Object):Boolean {
		return o is Array;
	}
	public static function isSerializableClass(o:Object):Boolean {
		return o is SerializableClass;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function convertToInt(o:Object):int {
		return int(o);
	}
	public static function as_int(o:Object):int {
		StaticFunctions.assert(o is int,"Argument to as_int must be an integer! o=",[o]);
		return o as int;
	}
	public static function asBoolean(o:Object):Boolean {
		StaticFunctions.assert(o is Boolean,"Argument to asBoolean must be an Boolean! o=",[o]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		return o as Boolean;
	}
	public static function asString(o:Object):String {
		StaticFunctions.assert(o is String,"Argument to asString must be an String! o=",[o]);
		return o as String;
	}
	public static function asArray(o:Object):Array {
		StaticFunctions.assert(o is Array,"Argument to asArray must be an Array! o=",[o]);
		return o as Array;
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function asSerializableClass(o:Object):SerializableClass {
		StaticFunctions.assert(o is SerializableClass,"Argument to asSerializableClass must be an SerializableClass! o=",[o]);
		return o as SerializableClass;
	}
	
	public static function delegate(thisObj:Object, handler:Function, ... args):Function { 
		if (args.length==0)
			return handler;  // I rely on the fact that I get the same function everytime in TicTacToe in addOnPress (otherwise I have event-listeners leak)
		return function (...otherArgs):Object { 
				return handler.apply(thisObj, otherArgs.concat(args) ); 

// This is a AUTOMATICALLY GENERATED! Do not change!

			};
	}
	public static var TRACE_ONPRESS:Boolean = true;;
	public static function addOnPress(movie:IEventDispatcher, func:Function, isActive:Boolean):void {
		//function (event:MouseEvent):void {
		if (myHasEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_DOWN , func))
			myRemoveEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_DOWN , func);
			
		if (isActive) {
			if (TRACE_ONPRESS) StaticFunctions.storeTrace(["Added on MOUSE_DOWN to movie=",movie]);

// This is a AUTOMATICALLY GENERATED! Do not change!

			myAddEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_DOWN , func);
		}
	}
	public static function addOnMouseOver(movie:IEventDispatcher, mouseOverFunc:Function, mouseOutFunc:Function, isActive:Boolean):void {		
		//function (event:MouseEvent):void { 		
		if (myHasEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_OVER , mouseOverFunc))
			myRemoveEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_OVER , mouseOverFunc);
			
		if (myHasEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_OUT , mouseOutFunc))		
			myRemoveEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_OUT , mouseOutFunc);

// This is a AUTOMATICALLY GENERATED! Do not change!

			
		if (isActive) {
			myAddEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_OVER , mouseOverFunc);		
			myAddEventListener("as3_vs_as2", movie, MouseEvent.MOUSE_OUT , mouseOutFunc);
		}
	}	
	public static function isDictionaryEmpty(dic:Dictionary):Boolean {
		return dictionarySize(dic)==0;
	}
	public static function dictionarySize(dic:Dictionary):int {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var size:int = 0;
		for (var key:Object in dic)
			size++;
		return size;
	}
		
	private static var dispatchersInfo:Dictionary/*IEventDispatcher -> DispatcherInfo*/;	 		
	private static function getEventListenersTrace():Object {
		// an object with toString for our traces
		return new AS3_vs_AS2();

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public function toString():String {
		var res:Array/*String*/ = [];
		for (var dispatcher:Object in dispatchersInfo) {
			var onStage:String = "";
			if (dispatcher is DisplayObject) {
				var display:DisplayObject = dispatcher as DisplayObject;
				onStage = (display.stage==null ? "NOT on " : "ON ")+"stage: ";
			}
			var info:DispatcherInfo = dispatchersInfo[dispatcher];

// This is a AUTOMATICALLY GENERATED! Do not change!

			var listeners:Array = [];
			for (var type:String in info.type2listner2func) {
				listeners.push(type);
			} 			
			listeners.sort();
			res.push(onStage+info.name+" with listeners: "+listeners.join(", "));
		}
		res = StaticFunctions.sortAndCountOccurrences(res); 
		return "all event listeners info:\n\t\t\t" + res.join("\n\t\t\t");
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public static function myHasAnyEventListener(dispatcherName:String, dispatcher:IEventDispatcher):Boolean {
		return dispatchersInfo[dispatcher]!=null;
	}
	public static function myHasEventListener(dispatcherName:String, dispatcher:IEventDispatcher, type:String, listener:Function):Boolean {
		var info:DispatcherInfo = dispatchersInfo[dispatcher];
		if (info==null) return false; 
		var dic2:Dictionary = info.type2listner2func[type];
		if (dic2==null) return false;
		return dic2[listener]!=null;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function myRemoveEventListener(dispatcherName:String, dispatcher:IEventDispatcher, type:String, listener:Function):void {
		var info:DispatcherInfo = getDispatcherInfo(dispatcherName,dispatcher);
		var dic1:Dictionary = info.type2listner2func;
		var dic2:Dictionary = dic1[type];
		var errInfo:Array = ["dispatcherName=",dispatcherName," dispatcher=",dispatcher," type=",type];
		StaticFunctions.assert(dic2!=null,"myRemoveEventListener1",errInfo);
		var func:Function = dic2[listener];
		StaticFunctions.assert(func!=null,"myRemoveEventListener2",errInfo);
		delete dic2[listener];

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (isDictionaryEmpty(dic2)) delete dic1[type];
		if (isDictionaryEmpty(dic1)) removeDispatcher(dispatcher);
		dispatcher.removeEventListener(type, func);
	}
	private static function removeDispatcher(dispatcher:IEventDispatcher):void {
		delete dispatchersInfo[dispatcher];
		if (dispatcher is AS3_Timer)
			(dispatcher as AS3_Timer).deleteTimer();
	}
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function myRemoveAllEventListeners(dispatcherName:String, dispatcher:IEventDispatcher):void {
		var info:DispatcherInfo = getDispatcherInfo(dispatcherName,dispatcher);
		var dic1:Dictionary = info.type2listner2func;
		
		var listener:Function;
		StaticFunctions.assert(dic1!=null, "Internal err",[]);
		for (var type:String in dic1){
			var dic2:Dictionary = dic1[type];
			for each (var newListener:Function in dic2) {
				dispatcher.removeEventListener(type, newListener);

// This is a AUTOMATICALLY GENERATED! Do not change!

			}
		}
		removeDispatcher(dispatcher);
	}
	public static function myWeakAddEventListener(dispatcherName:String, dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean=false, priority:int=0):void {
		p_myAddEventListener(dispatcherName,dispatcher,type,listener,useCapture,priority,true);
	}
	public static function myAddEventListener(dispatcherName:String, dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean=false, priority:int=0):void {
		p_myAddEventListener(dispatcherName,dispatcher,type,listener,useCapture,priority,false);
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static function getDispatcherInfo(dispatcherName:String, dispatcher:IEventDispatcher):DispatcherInfo {
		var info:DispatcherInfo = dispatchersInfo[dispatcher];
		StaticFunctions.assert(info!=null, "getDispatcherInfo: No event listeners to remove! dispatcherName=",[dispatcherName," dispatcher=",dispatcher]);
		StaticFunctions.assert(dispatcherName==null || info.name==dispatcherName, "getDispatcherInfo: You used the same dispatcher with different dispatcherName! dispatcher=",[dispatcher," new dispatcherName=",dispatcherName, " old dispatcherName=",info.name]);
		return info;
	}
	private static var ALL_Event_LOG:Logger = new Logger("ALL_EVENT_LISTENERS",10);
	private static function p_myAddEventListener(dispatcherName:String, dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean, priority:int, weakReference:Boolean):void {
		if (dispatchersInfo==null) {
			dispatchersInfo = new Dictionary(true); // weak keys! when the listener is garbaged-collected, the wrapper is deleted

// This is a AUTOMATICALLY GENERATED! Do not change!

			ALL_Event_LOG.log( getEventListenersTrace() );
		}
		 		
		var func:Function = ErrorHandler.wrapWithCatch(dispatcherName+" for event "+type, listener);		
		if (dispatchersInfo[dispatcher] == null)
			dispatchersInfo[dispatcher] = new DispatcherInfo(dispatcherName,weakReference); 
		var info:DispatcherInfo = getDispatcherInfo(dispatcherName,dispatcher);
		
		StaticFunctions.assert(info.isWeakRef==weakReference, "myAddEventListener: You used both true and false for weakReference! dispatcherName=",[dispatcherName]);
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		var dic1:Dictionary = info.type2listner2func;		
		if (dic1[type] == null)
			dic1[type] = new Dictionary(false);
		var dic2:Dictionary = dic1[type];
		StaticFunctions.assert(dic2[listener]==null,"myAddEventListener: you added the same listener twice! dispatcherName=",[dispatcherName," type=",type]);	
		dic2[listener] = func;		
		dispatcher.addEventListener(type, func, useCapture, priority, weakReference);
	}	
	
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	//the reason we have a functions Array is because un AS2 we can't use the client object
	public static var DO_TRACE:Boolean = false;
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array, handlerFunc:Function = null):void {
		conn.client = client;
		myAddEventListener("LocalConnection",conn, StatusEvent.STATUS,function (ev:Event):void{localConnectionFailed(ev,client, handlerFunc)});	
		myAddEventListener("LocalConnection",conn, SecurityErrorEvent.SECURITY_ERROR,function (ev:Event):void{localConnectionFailed(ev,client, handlerFunc)});			
	}
	private static function localConnectionFailed(event:Event,client:Object, handlerFunc:Function = null):void {
		if(DO_TRACE){
			StaticFunctions.storeTrace([" localConnectionFailed ",event]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		if(event is StatusEvent){
	        if ((event as StatusEvent).level=='error'){
	        	if(handlerFunc!=null)
	        		handlerFunc(false);
	        	else
	        		StaticFunctions.showError("LocalConnection.onStatus error="+event+" client="+client+" client's class="+getClassName(client)+". Are you sure you are running this game inside the emulator?)"); 
	      		
	        }else{
	        	if(handlerFunc!=null)

// This is a AUTOMATICALLY GENERATED! Do not change!

	        		handlerFunc(true);
	        }
		}else if(event is SecurityErrorEvent){
	 			StaticFunctions.showError("LocalConnection.onStatus error="+event+" client="+client+" client's class="+getClassName(client)+". Are you sure you are running this game inside the emulator?)");		
 		}
  	}
  	// use ErrorHandler.myTimeout and myInterval because they have proper error handling  	
	public static function unwrappedSetTimeout(zoneName:String, func:Function, in_milliseconds:int):Object {
		return createTimer(zoneName, func, in_milliseconds,1);
		//return setTimeout(func,in_milliseconds);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function unwrappedSetInterval(zoneName:String, func:Function, in_milliseconds:int):Object {
		return createTimer(zoneName, func, in_milliseconds,0);	
		//return setInterval(func,in_milliseconds);
	}
	private static function createTimer(zoneName:String, func:Function, in_milliseconds:int, repeat:int):Object {
		var t:AS3_Timer = new AS3_Timer(zoneName,in_milliseconds,repeat);
		myAddEventListener(zoneName,t,TimerEvent.TIMER, function (ev:TimerEvent):void {			 
			if (repeat==1) {
				t.stop();

// This is a AUTOMATICALLY GENERATED! Do not change!

				myRemoveAllEventListeners(zoneName,t);
			}
			func(); 
		});
		t.start();
		return t;		
	}
	public static function unwrappedClearInterval(zoneName:String, intervalId:Object):void {
		var t:AS3_Timer = intervalId as AS3_Timer;
		StaticFunctions.assert(t!=null,"You must pass an AS3_Timer object: ",[intervalId]);

// This is a AUTOMATICALLY GENERATED! Do not change!

		t.stop();
		myRemoveAllEventListeners(zoneName,t);
		//clearInterval(intervalId);
	}
	public static function unwrappedClearTimeout(zoneName:String, timeoutId:Object):void {
		unwrappedClearInterval(zoneName, timeoutId);
		//clearTimeout(timeoutId);
	}
	public static function myGetStackTrace(err:Error):String { 
		// in AS2 or in a release player (not a debugger) it returns null

// This is a AUTOMATICALLY GENERATED! Do not change!

		return err.getStackTrace();
	}
	public static function error2String(err:Error):String {
		return err==null ? "null" : 
			err.name+" message="+err.message+" errorID="+err.errorID
			+" stacktraces="+err.getStackTrace();
	}
	public static function getTimeString():String {
		return new Date().toLocaleTimeString();
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function getLoaderInfoParameters(someMovieClip:DisplayObject):Object {
		return someMovieClip.loaderInfo.parameters;
	}
	public static function getLoaderInfoUrl(someMovieClip:DisplayObject):String {
		return someMovieClip.loaderInfo.url;
	}
	public static function getMovieChild(graphics:MovieClip, childName:String):MovieClip {
		return getChild(graphics, childName) as MovieClip;
	}
	public static function getChild(graphics:MovieClip, childName:String):DisplayObject {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var res:DisplayObject = graphics.getChildByName(childName);
		if (res==null) StaticFunctions.throwError("Missing child="+childName+" in movieclip="+graphics.name);
		return res;
	}	
	public static function loadMovieIntoNewChild(graphics:MovieClip, url:String, onLoaded:Function):DisplayObjectContainer {
		var newMovie:DisplayObjectContainer = new Sprite();
		graphics.addChild(newMovie);		
		AS3_Loader.loadImage(url, function (event:Event):void {
				var loaderInfo:LoaderInfo = event.target as LoaderInfo;	
				var newChild:DisplayObject = loaderInfo.content;

// This is a AUTOMATICALLY GENERATED! Do not change!

				newMovie.addChildAt(newChild,0);
				if (onLoaded!=null) onLoaded(true, newChild);
			}, function (event:Event):void {
		        if (onLoaded!=null) onLoaded(false, null);
		    });		   
		return newMovie;
	}
	public static function scaleMovie(graphics:DisplayObject, x_percentage:int, y_percentage:int):void {
		scaleMovieX(graphics,x_percentage);
		scaleMovieY(graphics,y_percentage);		

// This is a AUTOMATICALLY GENERATED! Do not change!

	} 	
	public static function scaleMovieX(graphics:DisplayObject, x_percentage:int):void {
		graphics.scaleX = Number(x_percentage)/100;		
	} 	
	public static function scaleMovieY(graphics:DisplayObject, y_percentage:int):void {
		graphics.scaleY = Number(y_percentage)/100;		
	} 	
	public static function setVisible(graphics:DisplayObject, isVisible:Boolean):void {
		graphics.visible = isVisible;
	} 	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function setAlpha(target:DisplayObject, alphaPercentage:int):void {
		target.alpha = alphaPercentage/100;
	}
	public static function setMovieXY(target:DisplayObject, x:int, y:int):void {
		target.x = x;
		target.y = y;		
	} 	
	
	public static function createEmptyMovieClip(graphics:MovieClip, name:String):MovieClip {
		var child:MovieClip = new MovieClip();

// This is a AUTOMATICALLY GENERATED! Do not change!

		child.name = name;
		graphics.addChild(child);
		return child;
	}
	public static function createMovieInstance(graphics:DisplayObjectContainer, linkageName:String, name:String):MovieClip {
		var _Class:Class = getClassByName(linkageName);
		var dup:MovieClip = (new _Class()) as MovieClip;
		dup.name = name;
		graphics.addChild(dup);
		return dup;

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function removeMovie(graphics:DisplayObject):void {
		graphics.parent.removeChild( graphics );
	}
	private static var addKeyboardListener_LOG:Logger = new Logger("addKeyboardListener",5);
	public static function addKeyboardListener(graphics:DisplayObjectContainer, func:Function):void {
		var isStageReady:Boolean = graphics.stage!=null;
		if (isStageReady)	
			addKeyboardListenerStageReady(graphics, func);
		else {

// This is a AUTOMATICALLY GENERATED! Do not change!

			addKeyboardListener_LOG.log("Called addKeyboardListener, but stage is still null, so we set an interval until stage is ready");
			var intervalId:Object = ErrorHandler.myInterval("addKeyboardListener", 
				function ():void {
					if (graphics.stage!=null) {
						addKeyboardListener_LOG.log("stage is ready, so we now call addKeyboardListener");
						ErrorHandler.myClearInterval("addKeyboardListener",intervalId);					
						addKeyboardListenerStageReady(graphics, func);
					}
				}, 200);
		}		

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	private static function addKeyboardListenerStageReady(graphics:DisplayObjectContainer, func:Function):void {
		addKeyboardListener_LOG.log("Added KeyboardListener to Stage");
		addKeyboardListener2(true, graphics, func);
		addKeyboardListener2(false, graphics, func);
	}
	private static function addKeyboardListener2(is_key_down:Boolean, graphics:DisplayObjectContainer, func:Function):void {
		myAddEventListener("keyboard-stage",graphics.stage, 
			is_key_down ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, 
			function (event:KeyboardEvent):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

				var charCode:int = event.charCode;
				var keyCode:int = event.keyCode;
				var keyLocation:int = event.keyLocation;
				var altKey:Boolean = event.altKey;
				var ctrlKey:Boolean = event.ctrlKey;
				var shiftKey:Boolean = event.shiftKey;
				func(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey);
			});	
	}
	public static function showError(msg:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		showMessage(msg, "error");
	}
	// possible kinds are: error, traces, newTurn, gameOver
	private static var errorMessage:AS3_ErrorMessage = new AS3_ErrorMessage();
	public static function showMessage(msg:String, kind:String):void {
		var graphics:DisplayObjectContainer = StaticFunctions.someMovieClip;
		trace("Showing message: msg kind="+kind+
			" graphics="+graphics+
			" graphics.stage="+ (graphics==null ? "null" : graphics.stage) );
			

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (graphics==null) return;
		graphics = graphics.stage;
		if (graphics==null) return;
		graphics.addChild(errorMessage);
		errorMessage.addText(msg);
		
		trace("Finished showing message");
	}
	
	

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public static function IndexOf(arr:Array, val:Object):int {
		return arr.indexOf(val);
	}	
	public static function LastIndexOf(arr:Array, val:Object):int {
		return arr.lastIndexOf(val);
	}	
	public static function stringIndexOf(str:String, val:String, startIndex:int=0):int {
		return str.indexOf(val,startIndex);
	}	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function stringLastIndexOf(str:String, val:String, startIndex:int=0x7FFFFFFF):int {
		return str.lastIndexOf(val,startIndex);
	}	
	public static var CHECK_STAGE_EVERY_MILLI:int = 100;
	public static function waitForStage(graphics:MovieClip, gameConsructor:Function):void
	{
		var stageTimer:MyInterval = new MyInterval("waitForStage");
		trace('waitForStage...');
		stageTimer.start(function():void {
					if(graphics.stage) {

// This is a AUTOMATICALLY GENERATED! Do not change!

						trace('stage loaded!');
						stageTimer.clear();
						gameConsructor();
					}
				},CHECK_STAGE_EVERY_MILLI);
	}

	/**
	 * XML differences between AS2 and AS3.
	 * In AS2 I use XMLNode.

// This is a AUTOMATICALLY GENERATED! Do not change!

	 */
	public static function xml_create(str:String):XML {		
		try {
			return new XML(str);
		} catch (e:Error) {
			throw new Error("Error in createXML in str="+str);
		}
		return null;
	}
	public static function xml_getName(xml:XML):String {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return xml.name().toString();
	}
	public static function xml_getSimpleContent(xml:XML):String {
		return xml.toString();
	}
	public static function xml_getChildren(xml:XML):Array/*XML*/ {
		var list:XMLList = xml.children();
		var res:Array/*XML*/ = [];
		for each (var child:XML in list)
			res.push(child);

// This is a AUTOMATICALLY GENERATED! Do not change!

		return res;			
	}
		

	/**
	 * Serialization and handling classes and classNames
	 */
	public static function getClassName(o:Object):String {
		return getQualifiedClassName(o);
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	// e.g., "come2play_as3.auto_copied::StaticFunctions"
	public static function getClassByName(className:String):Class {
		try {
			return getDefinitionByName(className) as Class;
		} catch (err:Error) {
			throw new Error("The class named '"+className+"' was not found!");
		}	
		return null;
	}
	public static function getClassOfInstance(instance:Object):Class {

// This is a AUTOMATICALLY GENERATED! Do not change!

		// These two lines don't work for inner classes like:
		//		AS3_vs_AS2.as$35::XMLSerializable
		var className:String = getClassName(instance);
		var res:Class = getClassByName(className);
		
		StaticFunctions.assert(res!=null, "Missing class for instance=",[instance, " className=",className]);
		return res;		
	}
	private static var checkedClasses:Object = {}; 
	public static function checkConstructorHasNoArgs(obj:SerializableClass):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		// describeType is really expensive (for 225 calls, it took 51 milliseconds)
		// but we only do this once at startup!		
		var className:String = obj.__CLASS_NAME__;
		if (checkedClasses[className]!=null) return;
		checkedClasses[className] = true;
		//trace("Checking ctor of "+className);
		var descriptionXML:XML = describeType(obj);
		//trace("descriptionXML="+descriptionXML.toXMLString());
		var constructorList:XMLList = descriptionXML.constructor;
		if (constructorList.length()>0) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var constructor:XML = constructorList[0];
			for each (var parameter:XML in constructor.children())
				if (parameter.attribute("optional").toString()!="true")
					StaticFunctions.throwError("The constructor of class "+className+" that extends SerializableClass has arguments that are not optional! These are the parameters of the constructor="+constructor.toXMLString()); 
		}
		// I want to check that all fields are non-static and public,
		// but describeType only returns such fields in the first place.
		//<variable name="col" type="int"/>
	}	
	private static var name2classFields:Object = {}; // mapping class names to an array of field names

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function getFieldNames(instance:Object):Array {
		var className:String = getClassName(instance);
		var fieldNames:Array = name2classFields[className];
		if (fieldNames==null) {
			fieldNames = [];
			// we could have also used ByteArray.writeObject,
			// but I think this is more readable
			// Sadly, a simple for loop doesn't go over the fields of a class (like it does in AS2)
			// For loops do not work on classes in AS3 for classes (only for dynamic properties):
			// Iterates over the dynamic properties of an object or elements in an array and executes statement for each property or element. Object properties are not kept in any particular order, so properties may appear in a seemingly random order. Fixed properties, such as variables and methods defined in a class, are not enumerated by the for..in statement. To get a list of fixed properties, use the describeType() function, which is in the flash.utils package. 

// This is a AUTOMATICALLY GENERATED! Do not change!


			var fieldsList:XMLList = describeType(instance).variable;
			for each (var fieldInfo:XML in fieldsList)
				fieldNames.push( fieldInfo.attribute("name") );			
			name2classFields[className] = fieldNames;			
		}
		return fieldNames;
	}
	public static function checkAllFieldsDeserialized(obj:Object, newInstance:Object):void {
		var fieldNames:Array = getFieldNames(newInstance);

// This is a AUTOMATICALLY GENERATED! Do not change!

		for each (var fieldName:String in fieldNames) {
			if (StaticFunctions.startsWith(fieldName,"__")) continue;	
			if (!obj.hasOwnProperty(fieldName))
				throw new Error("When deserializing, we didn't find fieldName="+fieldName+" in object="+JSON.stringify(obj));
		}	
	}
	public static function checkObjectIsSerializable(obj:Object):void {
		if (obj==null) return;
		if (obj is Boolean || obj is String || obj is Number) return;
		var className:String = getClassName(obj);

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (className!="Array" && className!="Object")
			if (!(obj is SerializableClass))
				throw new Error("className="+className+" should extend SerializableClass because it was sent over a LocalConnection");
		for each (var field:Object in obj)
			checkObjectIsSerializable(field);
	}	
	public static function sendToURL(vars:Object, url:String):void {
		AS3_Loader.sendToURL(vars, URLRequestMethod.POST, url);	
	}
	

// This is a AUTOMATICALLY GENERATED! Do not change!

} // end AS3_vs_AS2
}
import emulator.auto_copied.SerializableClass;
import emulator.auto_copied.AS3_vs_AS2;
import flash.utils.*;

class DispatcherInfo {
	public var type2listner2func:Dictionary = new Dictionary();
	public var name:String; 
	public var isWeakRef:Boolean;

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public function DispatcherInfo(name:String, isWeakRef:Boolean) {
		this.name = name;
		this.isWeakRef = isWeakRef;
	}
}

