package come2play_as3.api.auto_copied
{
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;
	
public final class AS3_vs_AS2
{
	public static const isAS3:Boolean = true;
	
	public static var NATIVE_SERIALIZERS:Array/*NativeSerializable*/;
	public static function registerNativeSerializers():void {
		var classes:Array/*Class*/ = [
			ErrorSerializable,
			XMLSerializable,
			ByteArraySerializable,
			DictionarySerializable,
			DateSerializable
		];	
		NATIVE_SERIALIZERS = [];
		for each (var serializerClass:Class in classes) {
			var serializer:NativeSerializable = new serializerClass();
			SerializableClass.registerClassAlias(serializer.__CLASS_NAME__, serializerClass);
			serializer.register();
			NATIVE_SERIALIZERS.push(serializer);
		}
	}
	
	public static function getDisplayObjectDesc(movie:DisplayObject):String {
		return getDisplayObjectPath(movie)+(movie is MovieClip ? " in frame="+(movie as MovieClip).currentLabel : "");
	}
	public static function getDisplayObjectPath(movie:DisplayObject):String {
		if (movie==null || movie.name==null || movie==StaticFunctions.someMovieClip) return '';
		return getDisplayObjectPath(movie.parent)+"."+movie.name;		
	}
	public static function specialToString(o:Object):String {
		if (o is DisplayObject) return getDisplayObjectDesc(o as DisplayObject); // instead of the default toString which returns "[object peshka2_15]", I want to return the fullname and current keyframe (if it is a movieclip)
		if (o is URLRequest) return (o as URLRequest).url;
		var nativeSerializer:NativeSerializable = null;
		for each (var serializer:NativeSerializable in NATIVE_SERIALIZERS) {
			nativeSerializer = serializer.fromNative(o);
			if (nativeSerializer!=null) break;
		}
		if (nativeSerializer!=null) return nativeSerializer.toString();
		return o.toString();		
	}
	public static function byteArr2Str(byteArr:ByteArray):String {
		return JSON.stringify(ByteArraySerializable.byteArr2Arr(byteArr));		
	}
	public static function copyObjectUsingByteArray(o:Object):Object {
		// see also flash.net.registerClassAlias
		var b:ByteArray = new ByteArray();
		b.writeObject(o);
		b.position = 0;
		return b.readObject();
	}
	
	public static function isNumber(o:Object):Boolean {
		return o is Number;
	}
	public static function isBoolean(o:Object):Boolean {
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
	}
	public static function convertToInt(o:Object):int {
		return int(o);
	}
	public static function as_int(o:Object):int {
		StaticFunctions.assert(o is int,["Argument to as_int must be an integer! o=",o]);
		return o as int;
	}
	public static function asBoolean(o:Object):Boolean {
		StaticFunctions.assert(o is Boolean,["Argument to asBoolean must be an Boolean! o=",o]);
		return o as Boolean;
	}
	public static function asString(o:Object):String {
		StaticFunctions.assert(o is String,["Argument to asString must be an String! o=",o]);
		return o as String;
	}
	public static function asArray(o:Object):Array {
		StaticFunctions.assert(o is Array,["Argument to asArray must be an Array! o=",o]);
		return o as Array;
	}
	public static function asSerializableClass(o:Object):SerializableClass {
		StaticFunctions.assert(o is SerializableClass,["Argument to asSerializableClass must be an SerializableClass! o=",o]);
		return o as SerializableClass;
	}
	
	public static function delegate(thisObj:Object, handler:Function, ... args):Function {
		return function (...otherArgs):Object { 
				return handler.apply(thisObj, otherArgs.concat(args) ); 
			};
	}
	public static var TRACE_ONPRESS:Boolean = true;;
	public static function addOnPress(movie:IEventDispatcher, func:Function, isActive:Boolean):void {
		//function (event:MouseEvent):void {
		myRemoveEventListener(movie, MouseEvent.MOUSE_DOWN , func);
		if (isActive) {
			if (TRACE_ONPRESS) StaticFunctions.storeTrace(["Added on MOUSE_DOWN to movie=",movie]);
			myAddEventListener(movie, MouseEvent.MOUSE_DOWN , func);
		}
	}
	public static function addOnMouseOver(movie:IEventDispatcher, mouseOverFunc:Function, mouseOutFunc:Function, isActive:Boolean):void {		
		//function (event:MouseEvent):void { 		
		myRemoveEventListener(movie, MouseEvent.MOUSE_OVER , mouseOverFunc);		
		myRemoveEventListener(movie, MouseEvent.MOUSE_OUT , mouseOutFunc);
		if (isActive) {
			myAddEventListener(movie, MouseEvent.MOUSE_OVER , mouseOverFunc);		
			myAddEventListener(movie, MouseEvent.MOUSE_OUT , mouseOutFunc);
		}
	}	
		
	private static var listener2dispatcher2type2wrapper:Dictionary = new Dictionary(true); // weak keys! when the listener is garbaged-collected, the wrapper is deleted	 		
	public static function isDictionaryEmpty(dic:Dictionary):Boolean {
		for (var key:Object in dic)
			return false;
		return true;
	}
	public static function myRemoveEventListener(dispatcher:IEventDispatcher, type:String, listener:Function):void {
		var dic1:Dictionary = listener2dispatcher2type2wrapper[listener];
		if (dic1==null) return;
		var dic2:Dictionary = dic1[dispatcher];
		if (dic2==null) return;
		var func:Function = dic2[type];
		if (func==null) return;
		delete dic2[type];
		if (isDictionaryEmpty(dic2)) delete dic1[dispatcher];
		if (isDictionaryEmpty(dic1)) delete listener2dispatcher2type2wrapper[listener];
		dispatcher.removeEventListener(type, func);
	}			
	public static function myAddEventListener(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean=false, priority:int=0, weakReference:Boolean=false):Function {		
		var func:Function = ErrorHandler.wrapWithCatch("myAddEventListener."+type, listener);		
		if (listener2dispatcher2type2wrapper[listener] == null)
			listener2dispatcher2type2wrapper[listener] = new Dictionary (true);			
		if (listener2dispatcher2type2wrapper[listener][dispatcher] == null)
			listener2dispatcher2type2wrapper[listener][dispatcher] = new Dictionary (false);			
		listener2dispatcher2type2wrapper[listener][dispatcher][type] = func;		
		dispatcher.addEventListener(type, func, useCapture, priority, weakReference);
		return func; // use General.myRemoveEventListener to remove
	}
	
	
	
	//the reason we have a functions Array is because un AS2 we can't use the client object
	public static var DO_TRACE:Boolean = false;
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array, handlerFunc:Function = null):void {
		conn.client = client;
		myAddEventListener(conn, StatusEvent.STATUS,function (ev:Event):void{localConnectionFailed(ev,client, handlerFunc)});	
		myAddEventListener(conn, SecurityErrorEvent.SECURITY_ERROR,function (ev:Event):void{localConnectionFailed(ev,client, handlerFunc)});			
	}
	private static function localConnectionFailed(event:Event,client:Object, handlerFunc:Function = null):void {
		if(DO_TRACE){
			StaticFunctions.storeTrace([" localConnectionFailed ",event]);
		}
		if(event is StatusEvent){
	        if ((event as StatusEvent).level=='error'){
	        	if(handlerFunc!=null)
	        		handlerFunc(false);
	        	else
	        		StaticFunctions.showError("LocalConnection.onStatus error="+event+" client="+client+" client's class="+getClassName(client)+". Are you sure you are running this game inside the emulator?)"); 
	      		
	        }else{
	        	if(handlerFunc!=null)
	        		handlerFunc(true);
	        }
		}else if(event is SecurityErrorEvent){
	 			StaticFunctions.showError("LocalConnection.onStatus error="+event+" client="+client+" client's class="+getClassName(client)+". Are you sure you are running this game inside the emulator?)");		
 		}
  	}
  	// use ErrorHandler.myTimeout and myInterval because they have proper error handling
	public static function unwrappedSetTimeout(func:Function, in_milliseconds:int):int {	
		return setTimeout(func,in_milliseconds);
	}
	public static function unwrappedSetInterval(func:Function, in_milliseconds:int):int {	
		return setInterval(func,in_milliseconds);
	}
	public static function unwrappedClearInterval(intervalId:int):void {
		clearInterval(intervalId);
	}
	public static function unwrappedClearTimeout(timeoutId:int):void {
		clearTimeout(timeoutId);
	}
	public static function myGetStackTrace(err:Error):String {
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
		var res:DisplayObject = graphics.getChildByName(childName);
		if (res==null) StaticFunctions.throwError("Missing child="+childName+" in movieclip="+graphics.name);
		return res;
	}	
	public static var TRACE_LOADING:Boolean = false;
	public static function loadMovieIntoNewChild(graphics:MovieClip, url:String, onLoaded:Function):DisplayObjectContainer {
		var newMovie:DisplayObjectContainer = new Sprite();
		graphics.addChild(newMovie);
		loadMovieIntoNewChild2(newMovie,url,onLoaded);
		return newMovie;
	}
				
	public static var USE_LOADER_CONTEXT:Boolean = true;
	public static var LOADER_CHECKS_POLICY_FILE:Boolean = false;
	public static function loadMovieIntoNewChild2(newMovie:DisplayObjectContainer, url:String, onLoaded:Function):void {
		// todo: use AS3_Loader (with the retry and cache mechanism)
		if (TRACE_LOADING) StaticFunctions.storeTrace(["Loading url=",url," into a newly created child=",newMovie]);
		var context:LoaderContext = !USE_LOADER_CONTEXT ? null : new LoaderContext(LOADER_CHECKS_POLICY_FILE,ApplicationDomain.currentDomain);
		AS3_Loader.loadImage(url, function (event:Event):void {
				if (TRACE_LOADING) StaticFunctions.storeTrace(["Done loading url=",url]);
				var loaderInfo:LoaderInfo = event.target as LoaderInfo;	
				newMovie.addChild(loaderInfo.content);
				if (onLoaded!=null) onLoaded(true);
			}, function (event:Event):void {
		        if (TRACE_LOADING) StaticFunctions.storeTrace(["Error in loading movie from url=",url," event=",event]);
		        if (onLoaded!=null) onLoaded(false);
		    },null, context);
	}
	public static function scaleMovie(graphics:DisplayObject, x_percentage:int, y_percentage:int):void {
		scaleMovieX(graphics,x_percentage);
		scaleMovieY(graphics,y_percentage);		
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
	public static function setAlpha(target:DisplayObject, alphaPercentage:int):void {
		target.alpha = alphaPercentage/100;
	}
	public static function setMovieXY(target:DisplayObject, x:int, y:int):void {
		target.x = x;
		target.y = y;		
	} 	
	
	public static function createEmptyMovieClip(graphics:MovieClip, name:String):MovieClip {
		var child:MovieClip = new MovieClip();
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
	}
	public static function removeMovie(graphics:DisplayObject):void {
		graphics.parent.removeChild( graphics );
	}
	public static function addKeyboardListener(graphics:DisplayObjectContainer, func:Function):void {
		var isStageReady:Boolean = graphics.stage!=null;
		if (isStageReady)	
			addKeyboardListenerStageReady(graphics, func);
		else {
			trace("Called addKeyboardListener, but stage is still null, so we set an interval until stage is ready");
			var intervalId:int = ErrorHandler.myInterval("addKeyboardListener", 
				function ():void {
					if (graphics.stage!=null) {
						trace("stage is ready, so we now call addKeyboardListener");
						ErrorHandler.myClearInterval("addKeyboardListener",intervalId);					
						addKeyboardListenerStageReady(graphics, func);
					}
				}, 200);
		}		
	}
	private static function addKeyboardListenerStageReady(graphics:DisplayObjectContainer, func:Function):void {
		addKeyboardListener2(true, graphics, func);
		addKeyboardListener2(false, graphics, func);
	}
	private static function addKeyboardListener2(is_key_down:Boolean, graphics:DisplayObjectContainer, func:Function):void {
		myAddEventListener(graphics.stage, 
			is_key_down ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, 
			function (event:KeyboardEvent):void {
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
		showMessage(msg, "error");
	}
	// possible kinds are: error, traces, newTurn, gameOver
	public static function showMessage(msg:String, kind:String):void {
		var graphics:DisplayObjectContainer = StaticFunctions.someMovieClip;
		trace("Showing message: msg="+msg+
			" graphics="+graphics+
			" graphics.stage="+ (graphics==null ? "null" : graphics.stage) );
			
		if (graphics==null) return;
		graphics = graphics.stage;
		if (graphics==null) return;
		
		var blackBox:Sprite=new Sprite();
		blackBox.graphics.beginFill(0x000000);
		blackBox.graphics.drawRect(0,0,500,500);
		blackBox.graphics.endFill();
		var child:TextField = new TextField();
		child.text = msg;
		child.width = 500;
		child.height = 500;
		
		var buttonText:TextField = new TextField();
		
		//buttonText.textColor = 0x000000;
		buttonText.text = "close";
		buttonText.setTextFormat(new TextFormat("Times New Roman",14,0x000000),0,5);
		buttonText.selectable = false;
		
		
		var buttonBox:Sprite=new Sprite();
		buttonBox.graphics.beginFill(0xffffff);
		buttonBox.graphics.drawRect(0,0,40,20);
		buttonBox.graphics.endFill();
		buttonBox.addChild(buttonText);
		buttonBox.x = graphics.width/2;
		buttonBox.y = graphics.height/2;
		var closeBtn:SimpleButton = new SimpleButton(buttonBox,buttonBox,buttonBox,buttonBox);
		blackBox.addChild(child);
		blackBox.addChild(closeBtn);

		//child.backgroundColor = 0xFF0000; // red
		child.textColor = 0xFF0000; // red
		
		
		graphics.addChild(blackBox);
		myAddEventListener(closeBtn, MouseEvent.CLICK, 
			function():void {
				trace("close")
				graphics.removeChild(blackBox);
				} 
			);
		trace("Finished showing message");
	}
	
	
	
	public static function IndexOf(arr:Array, val:Object):int {
		return arr.indexOf(val);
	}	
	public static function LastIndexOf(arr:Array, val:Object):int {
		return arr.lastIndexOf(val);
	}	
	public static function stringIndexOf(str:String, val:String, startIndex:int=0):int {
		return str.indexOf(val,startIndex);
	}	
	public static function stringLastIndexOf(str:String, val:String, startIndex:int=0x7FFFFFFF):int {
		return str.lastIndexOf(val,startIndex);
	}	
	public static function waitForStage(graphics:MovieClip, gameConsructor:Function):void
	{
		var stageTimer:Timer = new AS3_Timer("waitForStage",100,0);
		stageTimer.start();	
		trace('waitForStage...');
		myAddEventListener(stageTimer,
			TimerEvent.TIMER, function():void {
					if(graphics.stage) {
						trace('stage loaded!');
						stageTimer.stop();
						gameConsructor();
					}
				});
	}

	/**
	 * XML differences between AS2 and AS3.
	 * In AS2 I use XMLNode.
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
		return res;			
	}
		

	/**
	 * Serialization and handling classes and classNames
	 */
	public static function getClassName(o:Object):String {
		return getQualifiedClassName(o);
	}
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
		// These two lines don't work for inner classes like:
		//		AS3_vs_AS2.as$35::XMLSerializable
		var className:String = getClassName(instance);
		var res:Class = getClassByName(className);
		
		StaticFunctions.assert(res!=null, ["Missing class for instance=",instance, " className=",className]);
		return res;		
	}
	private static var checkedClasses:Object = {};
	public static function checkConstructorHasNoArgs(obj:SerializableClass):void {
		var className:String = obj.__CLASS_NAME__;
		if (checkedClasses[className]!=null) return;
		checkedClasses[className] = true;
		//trace("Checking ctor of "+className);
		var descriptionXML:XML = describeType(obj);
		//trace("descriptionXML="+descriptionXML.toXMLString());
		var constructorList:XMLList = descriptionXML.constructor;
		if (constructorList.length()>0) {
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

			var fieldsList:XMLList = describeType(instance).variable;
			for each (var fieldInfo:XML in fieldsList)
				fieldNames.push( fieldInfo.attribute("name") );			
			name2classFields[className] = fieldNames;			
		}
		return fieldNames;
	}
	public static function checkAllFieldsDeserialized(obj:Object, newInstance:Object):void {
		var fieldNames:Array = getFieldNames(newInstance);
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
		if (className!="Array" && className!="Object")
			if (!(obj is SerializableClass))
				throw new Error("className="+className+" should extend SerializableClass because it was sent over a LocalConnection");
		for each (var field:Object in obj)
			checkObjectIsSerializable(field);
	}
	
	public static var JPG_QUALITY:int = 50;
	public static function sendMultipartImage(bug_id:int):void {
		if (StaticFunctions.someMovieClip!=null && StaticFunctions.someMovieClip.stage!=null)
			SendMultipartImage.sendMultipartImage(StaticFunctions.someMovieClip.stage,bug_id);
	} 	
	public static function sendToURL(vars:Object, url:String):void {
		AS3_Loader.sendToURL(vars, URLRequestMethod.POST, url);	
	}
	
} // end AS3_vs_AS2
}
import come2play_as3.api.auto_copied.SerializableClass;
import come2play_as3.api.auto_copied.AS3_vs_AS2;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
class NativeSerializable extends SerializableClass {
	public function NativeSerializable(shortName:String=null) {
		super(shortName);
	}
	public function fromNative(obj:Object):NativeSerializable {
		throw new Error("Must override fromNative");
	}	
	override public function postDeserialize():Object {
		throw new Error("Must override postDeserialize");
	}
}	

class ErrorSerializable extends NativeSerializable {
	public var message:String;
	public var errorId:int;
	public function ErrorSerializable(err:Error=null) {
		super("Error");
		message = err==null ? null : err.message;
		errorId = err==null ? 0 : err.errorID;
	}	
	override public function fromNative(obj:Object):NativeSerializable {
		return obj is Error ? new ErrorSerializable(obj as Error) : null;
	}
	override public function postDeserialize():Object {
		return new Error(message, errorId);
	}	
}
class XMLSerializable extends NativeSerializable {
	public var xmlStr:String;
	public function XMLSerializable(xml:XML=null) {
		super("XML");
		xmlStr = xml==null ? null : xml.toXMLString();
	}	
	override public function fromNative(obj:Object):NativeSerializable {
		return obj is XML ? new XMLSerializable(obj as XML) : null;
	}
	override public function postDeserialize():Object {
		return AS3_vs_AS2.xml_create(xmlStr);
	}	
}
class DateSerializable extends NativeSerializable {
	//public var utcDate:String; //Tue Feb 1 00:00:00 2005 UTC
	public var millis:Number; //the number of milliseconds since midnight January 1, 1970, universal time
	public function DateSerializable(date:Date=null) {
		super("Date");
		//utcDate = date==null ? null : date.toUTCString();
		millis = date==null ? null : date.valueOf();
	}	
	override public function fromNative(obj:Object):NativeSerializable {
		return obj is Date ? new DateSerializable(obj as Date) : null;
	}
	override public function postDeserialize():Object {
		return new Date(millis); //millis<=0 ? utcDate : millis
	}	
}
class DictionarySerializable extends NativeSerializable {
	public var keyValArr:Array = [];
	public function DictionarySerializable(dic:Dictionary=null) {
		super("Dictionary");
		if (dic!=null) {
			for (var k:Object in dic) 
	 			keyValArr.push([k, dic[k]]);
	 	}
	}	
	override public function fromNative(obj:Object):NativeSerializable {
		return obj is Dictionary ? new DictionarySerializable(obj as Dictionary) : null;
	}
	override public function postDeserialize():Object {
		var res:Dictionary = new Dictionary();
		for each (var keyVal:Array in keyValArr)
			res[ keyVal[0] ] = keyVal[1];
		return res;
	}	
}
class ByteArraySerializable extends NativeSerializable {
	public var arr:Array/*int*/;
	public function ByteArraySerializable(byteArr:ByteArray=null) {
		super("ByteArray");
		arr = byteArr==null ? null : byteArr2Arr(byteArr);
	}	
	override public function fromNative(obj:Object):NativeSerializable {
		return obj is ByteArray ? new ByteArraySerializable(obj as ByteArray) : null;
	}
	public static function byteArr2Arr(byteArr:ByteArray):Array {
		var bytes:Array = [];
		var oldPosition:int = byteArr.position;
		byteArr.position = 0;
		for (var i:int=0; i<byteArr.length; i++)
			bytes.push(byteArr.readByte());
		byteArr.position = oldPosition;
		return bytes;
	}
	override public function postDeserialize():Object {
		var res:ByteArray = new ByteArray();
		for each (var i:int in arr)
			res.writeByte(i);
		res.position = 0; 
		return res;
	}	
}


import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;
import come2play_as3.api.auto_copied.StaticFunctions;

class SendMultipartImage
{
	public static function sendMultipartImage(stage:Stage, bug_id:int):void {
		var jpegEncoder:JPEGEncoder = new JPEGEncoder(AS3_vs_AS2.JPG_QUALITY);
		StaticFunctions.tmpTrace(["SendMultipartImage of dimensions=",stage.width,stage.height]);
		var image:BitmapData = new BitmapData(stage.width, stage.height);
		image.draw(stage);
		var byteArr:ByteArray = jpegEncoder.encode(image);
		trace('SendMultipartImage: byteArr.len='+byteArr.length);
		sendJPG(byteArr, bug_id);
	}

	public static function sendJPG(imageBytes:ByteArray, bug_id:int):void {	
		imageBytes.position = 0;
		
		var boundary: String = '---------------------------7d76d1b56035e';
		var header1: String  = '--'+boundary + '\r\n'
								+'Content-Disposition: form-data; name="bug_image"; filename="bug'+bug_id+'.jpg"\r\n'
								+'Content-Type: application/octet-stream\r\n\r\n'
		    //In a normal POST header, you'd find the image data here
		var header2: String =	'--'+boundary + '\r\n'
								+'Content-Disposition: form-data; name="bug_id"\r\n\r\n'
								+bug_id+'\r\n'
								+'--'+boundary + '--';
		//Encoding the two string parts of the header
		var headerBytes1: ByteArray = new ByteArray();
		headerBytes1.writeMultiByte(header1, "ascii");
		
		var headerBytes2: ByteArray = new ByteArray();
		headerBytes2.writeMultiByte(header2, "ascii");
		
		    //Creating one final ByteArray
		var sendBytes: ByteArray = new ByteArray();
		sendBytes.writeBytes(headerBytes1, 0, headerBytes1.length);
		sendBytes.writeBytes(imageBytes, 0, imageBytes.length);
		sendBytes.writeBytes(headerBytes2, 0, headerBytes2.length);
		
		var request: URLRequest = new URLRequest(ErrorHandler.getErrorReportUrl());
		request.data = sendBytes;
		request.method = URLRequestMethod.POST;
		request.contentType = "multipart/form-data; boundary=" + boundary;
		
		trace('SendMultipartImage: sendBytes.len='+sendBytes.length);
		
		AS3_Loader.loadText(request);			
	}   
}

import flash.display.*;
import flash.geom.*;
import flash.utils.ByteArray;
import come2play_as3.api.auto_copied.ErrorHandler;
import come2play_as3.api.auto_copied.AS3_Loader;


class JPEGEncoder
{

	// Static table initialization

	private var ZigZag:Array = [
		 0, 1, 5, 6,14,15,27,28,
		 2, 4, 7,13,16,26,29,42,
		 3, 8,12,17,25,30,41,43,
		 9,11,18,24,31,40,44,53,
		10,19,23,32,39,45,52,54,
		20,22,33,38,46,51,55,60,
		21,34,37,47,50,56,59,61,
		35,36,48,49,57,58,62,63
	];

	private var YTable:Array = new Array(64);
	private var UVTable:Array = new Array(64);
	private var fdtbl_Y:Array = new Array(64);
	private var fdtbl_UV:Array = new Array(64);

	private function initQuantTables(sf:int):void
	{
		var i:int;
		var t:Number;
		var YQT:Array = [
			16, 11, 10, 16, 24, 40, 51, 61,
			12, 12, 14, 19, 26, 58, 60, 55,
			14, 13, 16, 24, 40, 57, 69, 56,
			14, 17, 22, 29, 51, 87, 80, 62,
			18, 22, 37, 56, 68,109,103, 77,
			24, 35, 55, 64, 81,104,113, 92,
			49, 64, 78, 87,103,121,120,101,
			72, 92, 95, 98,112,100,103, 99
		];
		for (i = 0; i < 64; i++) {
			t = Math.floor((YQT[i]*sf+50)/100);
			if (t < 1) {
				t = 1;
			} else if (t > 255) {
				t = 255;
			}
			YTable[ZigZag[i]] = t;
		}
		var UVQT:Array = [
			17, 18, 24, 47, 99, 99, 99, 99,
			18, 21, 26, 66, 99, 99, 99, 99,
			24, 26, 56, 99, 99, 99, 99, 99,
			47, 66, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99,
			99, 99, 99, 99, 99, 99, 99, 99
		];
		for (i = 0; i < 64; i++) {
			t = Math.floor((UVQT[i]*sf+50)/100);
			if (t < 1) {
				t = 1;
			} else if (t > 255) {
				t = 255;
			}
			UVTable[ZigZag[i]] = t;
		}
		var aasf:Array = [
			1.0, 1.387039845, 1.306562965, 1.175875602,
			1.0, 0.785694958, 0.541196100, 0.275899379
		];
		i = 0;
		for (var row:int = 0; row < 8; row++)
		{
			for (var col:int = 0; col < 8; col++)
			{
				fdtbl_Y[i]  = (1.0 / (YTable [ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
				fdtbl_UV[i] = (1.0 / (UVTable[ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
				i++;
			}
		}
	}

	private var YDC_HT:Array;
	private var UVDC_HT:Array;
	private var YAC_HT:Array;
	private var UVAC_HT:Array;

	private function computeHuffmanTbl(nrcodes:Array, std_table:Array):Array
	{
		var codevalue:int = 0;
		var pos_in_table:int = 0;
		var HT:Array = new Array();
		for (var k:int=1; k<=16; k++) {
			for (var j:int=1; j<=nrcodes[k]; j++) {
				HT[std_table[pos_in_table]] = new BitString();
				HT[std_table[pos_in_table]].val = codevalue;
				HT[std_table[pos_in_table]].len = k;
				pos_in_table++;
				codevalue++;
			}
			codevalue*=2;
		}
		return HT;
	}

	private var std_dc_luminance_nrcodes:Array = [0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0];
	private var std_dc_luminance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
	private var std_ac_luminance_nrcodes:Array = [0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,0x7d];
	private var std_ac_luminance_values:Array = [
		0x01,0x02,0x03,0x00,0x04,0x11,0x05,0x12,
		0x21,0x31,0x41,0x06,0x13,0x51,0x61,0x07,
		0x22,0x71,0x14,0x32,0x81,0x91,0xa1,0x08,
		0x23,0x42,0xb1,0xc1,0x15,0x52,0xd1,0xf0,
		0x24,0x33,0x62,0x72,0x82,0x09,0x0a,0x16,
		0x17,0x18,0x19,0x1a,0x25,0x26,0x27,0x28,
		0x29,0x2a,0x34,0x35,0x36,0x37,0x38,0x39,
		0x3a,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
		0x4a,0x53,0x54,0x55,0x56,0x57,0x58,0x59,
		0x5a,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
		0x6a,0x73,0x74,0x75,0x76,0x77,0x78,0x79,
		0x7a,0x83,0x84,0x85,0x86,0x87,0x88,0x89,
		0x8a,0x92,0x93,0x94,0x95,0x96,0x97,0x98,
		0x99,0x9a,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,
		0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,0xb5,0xb6,
		0xb7,0xb8,0xb9,0xba,0xc2,0xc3,0xc4,0xc5,
		0xc6,0xc7,0xc8,0xc9,0xca,0xd2,0xd3,0xd4,
		0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xe1,0xe2,
		0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,
		0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
		0xf9,0xfa
	];

	private var std_dc_chrominance_nrcodes:Array = [0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
	private var std_dc_chrominance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
	private var std_ac_chrominance_nrcodes:Array = [0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,0x77];
	private var std_ac_chrominance_values:Array = [
		0x00,0x01,0x02,0x03,0x11,0x04,0x05,0x21,
		0x31,0x06,0x12,0x41,0x51,0x07,0x61,0x71,
		0x13,0x22,0x32,0x81,0x08,0x14,0x42,0x91,
		0xa1,0xb1,0xc1,0x09,0x23,0x33,0x52,0xf0,
		0x15,0x62,0x72,0xd1,0x0a,0x16,0x24,0x34,
		0xe1,0x25,0xf1,0x17,0x18,0x19,0x1a,0x26,
		0x27,0x28,0x29,0x2a,0x35,0x36,0x37,0x38,
		0x39,0x3a,0x43,0x44,0x45,0x46,0x47,0x48,
		0x49,0x4a,0x53,0x54,0x55,0x56,0x57,0x58,
		0x59,0x5a,0x63,0x64,0x65,0x66,0x67,0x68,
		0x69,0x6a,0x73,0x74,0x75,0x76,0x77,0x78,
		0x79,0x7a,0x82,0x83,0x84,0x85,0x86,0x87,
		0x88,0x89,0x8a,0x92,0x93,0x94,0x95,0x96,
		0x97,0x98,0x99,0x9a,0xa2,0xa3,0xa4,0xa5,
		0xa6,0xa7,0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,
		0xb5,0xb6,0xb7,0xb8,0xb9,0xba,0xc2,0xc3,
		0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xd2,
		0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,
		0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,
		0xea,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
		0xf9,0xfa
	];

	private function initHuffmanTbl():void
	{
		YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes,std_dc_luminance_values);
		UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes,std_dc_chrominance_values);
		YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes,std_ac_luminance_values);
		UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes,std_ac_chrominance_values);
	}

	private var bitcode:Array = new Array(65535);
	private var category:Array = new Array(65535);

	private function initCategoryNumber():void
	{
		var nr:int;
		var nrlower:int = 1;
		var nrupper:int = 2;
		for (var cat:int=1; cat<=15; cat++) {
			//Positive numbers
			for (nr=nrlower; nr<nrupper; nr++) {
				category[32767+nr] = cat;
				bitcode[32767+nr] = new BitString();
				bitcode[32767+nr].len = cat;
				bitcode[32767+nr].val = nr;
			}
			//Negative numbers
			for (nr=-(nrupper-1); nr<=-nrlower; nr++) {
				category[32767+nr] = cat;
				bitcode[32767+nr] = new BitString();
				bitcode[32767+nr].len = cat;
				bitcode[32767+nr].val = nrupper-1+nr;
			}
			nrlower <<= 1;
			nrupper <<= 1;
		}
	}

	// IO functions

	private var byteout:ByteArray;
	private var bytenew:int = 0;
	private var bytepos:int = 7;

	private function writeBits(bs:BitString):void
	{
		var value:int = bs.val;
		var posval:int = bs.len-1;
		while ( posval >= 0 ) {
			if (value & uint(1 << posval) ) {
				bytenew |= uint(1 << bytepos);
			}
			posval--;
			bytepos--;
			if (bytepos < 0) {
				if (bytenew == 0xFF) {
					writeByte(0xFF);
					writeByte(0);
				}
				else {
					writeByte(bytenew);
				}
				bytepos=7;
				bytenew=0;
			}
		}
	}

	private function writeByte(value:int):void
	{
		byteout.writeByte(value);
	}

	private function writeWord(value:int):void
	{
		writeByte((value>>8)&0xFF);
		writeByte((value   )&0xFF);
	}

	// DCT & quantization core

	private function fDCTQuant(data:Array, fdtbl:Array):Array
	{
		var tmp0:Number;
		var tmp7:Number;
		var tmp1:Number;
		var tmp6:Number;
		var tmp2:Number;
		var tmp5:Number;
		var tmp3:Number;
		var tmp4:Number;

		var tmp10:Number;
		var tmp13:Number;
		var tmp11:Number;
		var tmp12:Number;
		var z1:Number;
		var z5:Number;
		var z2:Number;			
		var z4:Number;
		var z3:Number;

		var z11:Number;
		var z13:Number;
		
		/* Pass 1: process rows. */
		var dataOff:int=0;
		var i:int;
		for (i=0; i<8; i++) {
			tmp0 = data[dataOff+0] + data[dataOff+7];
			tmp7 = data[dataOff+0] - data[dataOff+7];
			tmp1 = data[dataOff+1] + data[dataOff+6];
			tmp6 = data[dataOff+1] - data[dataOff+6];
			tmp2 = data[dataOff+2] + data[dataOff+5];
			tmp5 = data[dataOff+2] - data[dataOff+5];
			tmp3 = data[dataOff+3] + data[dataOff+4];
			tmp4 = data[dataOff+3] - data[dataOff+4];

			/* Even part */
			tmp10 = tmp0 + tmp3;	/* phase 2 */
			tmp13 = tmp0 - tmp3;
			tmp11 = tmp1 + tmp2;
			tmp12 = tmp1 - tmp2;

			data[dataOff+0] = tmp10 + tmp11; /* phase 3 */
			data[dataOff+4] = tmp10 - tmp11;

			z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
			data[dataOff+2] = tmp13 + z1; /* phase 5 */
			data[dataOff+6] = tmp13 - z1;

			/* Odd part */
			tmp10 = tmp4 + tmp5; /* phase 2 */
			tmp11 = tmp5 + tmp6;
			tmp12 = tmp6 + tmp7;

			/* The rotator is modified from fig 4-8 to avoid extra negations. */
			z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
			z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
			z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
			z3 = tmp11 * 0.707106781; /* c4 */

			z11 = tmp7 + z3;	/* phase 5 */
			z13 = tmp7 - z3;

			data[dataOff+5] = z13 + z2;	/* phase 6 */
			data[dataOff+3] = z13 - z2;
			data[dataOff+1] = z11 + z4;
			data[dataOff+7] = z11 - z4;

			dataOff += 8; /* advance pointer to next row */
		}

		/* Pass 2: process columns. */
		dataOff = 0;
		for (i=0; i<8; i++) {
			tmp0 = data[dataOff+ 0] + data[dataOff+56];
			tmp7 = data[dataOff+ 0] - data[dataOff+56];
			tmp1 = data[dataOff+ 8] + data[dataOff+48];
			tmp6 = data[dataOff+ 8] - data[dataOff+48];
			tmp2 = data[dataOff+16] + data[dataOff+40];
			tmp5 = data[dataOff+16] - data[dataOff+40];
			tmp3 = data[dataOff+24] + data[dataOff+32];
			tmp4 = data[dataOff+24] - data[dataOff+32];

			/* Even part */
			tmp10 = tmp0 + tmp3;	/* phase 2 */
			tmp13 = tmp0 - tmp3;
			tmp11 = tmp1 + tmp2;
			tmp12 = tmp1 - tmp2;

			data[dataOff+ 0] = tmp10 + tmp11; /* phase 3 */
			data[dataOff+32] = tmp10 - tmp11;

			z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
			data[dataOff+16] = tmp13 + z1; /* phase 5 */
			data[dataOff+48] = tmp13 - z1;

			/* Odd part */
			tmp10 = tmp4 + tmp5; /* phase 2 */
			tmp11 = tmp5 + tmp6;
			tmp12 = tmp6 + tmp7;

			/* The rotator is modified from fig 4-8 to avoid extra negations. */
			z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
			z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
			z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
			z3= tmp11 * 0.707106781; /* c4 */

			z11 = tmp7 + z3;	/* phase 5 */
			z13 = tmp7 - z3;

			data[dataOff+40] = z13 + z2; /* phase 6 */
			data[dataOff+24] = z13 - z2;
			data[dataOff+ 8] = z11 + z4;
			data[dataOff+56] = z11 - z4;

			dataOff++; /* advance pointer to next column */
		}

		// Quantize/descale the coefficients
		for (i=0; i<64; i++) {
			// Apply the quantization and scaling factor & Round to nearest integer
			data[i] = Math.round((data[i]*fdtbl[i]));
		}
		return data;
	}

	// Chunk writing

	private function writeAPP0():void
	{
		writeWord(0xFFE0); // marker
		writeWord(16); // length
		writeByte(0x4A); // J
		writeByte(0x46); // F
		writeByte(0x49); // I
		writeByte(0x46); // F
		writeByte(0); // = "JFIF",'\0'
		writeByte(1); // versionhi
		writeByte(1); // versionlo
		writeByte(0); // xyunits
		writeWord(1); // xdensity
		writeWord(1); // ydensity
		writeByte(0); // thumbnwidth
		writeByte(0); // thumbnheight
	}

	private function writeSOF0(width:int, height:int):void
	{
		writeWord(0xFFC0); // marker
		writeWord(17);   // length, truecolor YUV JPG
		writeByte(8);    // precision
		writeWord(height);
		writeWord(width);
		writeByte(3);    // nrofcomponents
		writeByte(1);    // IdY
		writeByte(0x11); // HVY
		writeByte(0);    // QTY
		writeByte(2);    // IdU
		writeByte(0x11); // HVU
		writeByte(1);    // QTU
		writeByte(3);    // IdV
		writeByte(0x11); // HVV
		writeByte(1);    // QTV
	}

	private function writeDQT():void
	{
		var i:int;
		writeWord(0xFFDB); // marker
		writeWord(132);	   // length
		writeByte(0);
		for (i=0; i<64; i++) {
			writeByte(YTable[i]);
		}
		writeByte(1);
		for (i=0; i<64; i++) {
			writeByte(UVTable[i]);
		}
	}

	private function writeDHT():void
	{
		var i:int;
		writeWord(0xFFC4); // marker
		writeWord(0x01A2); // length

		writeByte(0); // HTYDCinfo
		for (i=0; i<16; i++) {
			writeByte(std_dc_luminance_nrcodes[i+1]);
		}
		for (i=0; i<=11; i++) {
			writeByte(std_dc_luminance_values[i]);
		}

		writeByte(0x10); // HTYACinfo
		for (i=0; i<16; i++) {
			writeByte(std_ac_luminance_nrcodes[i+1]);
		}
		for (i=0; i<=161; i++) {
			writeByte(std_ac_luminance_values[i]);
		}

		writeByte(1); // HTUDCinfo
		for (i=0; i<16; i++) {
			writeByte(std_dc_chrominance_nrcodes[i+1]);
		}
		for (i=0; i<=11; i++) {
			writeByte(std_dc_chrominance_values[i]);
		}

		writeByte(0x11); // HTUACinfo
		for (i=0; i<16; i++) {
			writeByte(std_ac_chrominance_nrcodes[i+1]);
		}
		for (i=0; i<=161; i++) {
			writeByte(std_ac_chrominance_values[i]);
		}
	}

	private function writeSOS():void
	{
		writeWord(0xFFDA); // marker
		writeWord(12); // length
		writeByte(3); // nrofcomponents
		writeByte(1); // IdY
		writeByte(0); // HTY
		writeByte(2); // IdU
		writeByte(0x11); // HTU
		writeByte(3); // IdV
		writeByte(0x11); // HTV
		writeByte(0); // Ss
		writeByte(0x3f); // Se
		writeByte(0); // Bf
	}

	// Core processing
	private var DU:Array = new Array(64);

	private function processDU(CDU:Array, fdtbl:Array, DC:Number, HTDC:Array, HTAC:Array):Number
	{
		var i:int;
		var EOB:BitString = HTAC[0x00];
		var M16zeroes:BitString = HTAC[0xF0];

		var DU_DCT:Array = fDCTQuant(CDU, fdtbl);
		//ZigZag reorder
		for (i=0;i<64;i++) {
			DU[ZigZag[i]]=DU_DCT[i];
		}
		var Diff:int = DU[0] - DC; DC = DU[0];
		//Encode DC
		if (Diff==0) {
			writeBits(HTDC[0]); // Diff might be 0
		} else {
			writeBits(HTDC[category[32767+Diff]]);
			writeBits(bitcode[32767+Diff]);
		}
		//Encode ACs
		var end0pos:int = 63;
		for (; (end0pos>0)&&(DU[end0pos]==0); end0pos--) {
		};
		//end0pos = first element in reverse order !=0
		if ( end0pos == 0) {
			writeBits(EOB);
			return DC;
		}
		i = 1;
		while ( i <= end0pos ) {
			var startpos:int = i;
			for (; (DU[i]==0) && (i<=end0pos); i++) {
			}
			var nrzeroes:int = i-startpos;
			if ( nrzeroes >= 16 ) {
				for (var nrmarker:int=1; nrmarker <= nrzeroes/16; nrmarker++) {
					writeBits(M16zeroes);
				}
				nrzeroes = int(nrzeroes&0xF);
			}
			writeBits(HTAC[nrzeroes*16+category[32767+DU[i]]]);
			writeBits(bitcode[32767+DU[i]]);
			i++;
		}
		if ( end0pos != 63 ) {
			writeBits(EOB);
		}
		return DC;
	}

	private var YDU:Array = new Array(64);
	private var UDU:Array = new Array(64);
	private var VDU:Array = new Array(64);

	private function RGB2YUV(img:BitmapData, xpos:int, ypos:int):void
	{
		var pos:int=0;
		for (var y:int=0; y<8; y++) {
			for (var x:int=0; x<8; x++) {
				var P:uint = img.getPixel32(xpos+x,ypos+y);
				var R:Number = Number((P>>16)&0xFF);
				var G:Number = Number((P>> 8)&0xFF);
				var B:Number = Number((P    )&0xFF);
				YDU[pos]=((( 0.29900)*R+( 0.58700)*G+( 0.11400)*B))-128;
				UDU[pos]=(((-0.16874)*R+(-0.33126)*G+( 0.50000)*B));
				VDU[pos]=((( 0.50000)*R+(-0.41869)*G+(-0.08131)*B));
				pos++;
			}
		}
	}

	public function JPEGEncoder(quality:Number = 50)
	{
		if (quality <= 0) {
			quality = 1;
		}
		if (quality > 100) {
			quality = 100;
		}
		var sf:int = 0;
		if (quality < 50) {
			sf = int(5000 / quality);
		} else {
			sf = int(200 - quality*2);
		}
		// Create tables
		initHuffmanTbl();
		initCategoryNumber();
		initQuantTables(sf);
	}

	public function encode(image:BitmapData):ByteArray
	{
		// Initialize bit writer
		byteout = new ByteArray();
		bytenew=0;
		bytepos=7;

		// Add JPEG headers
		writeWord(0xFFD8); // SOI
		writeAPP0();
		writeDQT();
		writeSOF0(image.width,image.height);
		writeDHT();
		writeSOS();

		// Encode 8x8 macroblocks
		var DCY:Number=0;
		var DCU:Number=0;
		var DCV:Number=0;
		bytenew=0;
		bytepos=7;
		for (var ypos:int=0; ypos<image.height; ypos+=8) {
			for (var xpos:int=0; xpos<image.width; xpos+=8) {
				RGB2YUV(image, xpos, ypos);
				DCY = processDU(YDU, fdtbl_Y, DCY, YDC_HT, YAC_HT);
				DCU = processDU(UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
				DCV = processDU(VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
			}
		}

		// Do the bit alignment of the EOI marker
		if ( bytepos >= 0 ) {
			var fillbits:BitString = new BitString();
			fillbits.len = bytepos+1;
			fillbits.val = (1<<(bytepos+1))-1;
			writeBits(fillbits);
		}

		writeWord(0xFFD9); //EOI
		return byteout;
	}
}
class BitString {
	public var len:int = 0;
	public var val:int = 0;
};