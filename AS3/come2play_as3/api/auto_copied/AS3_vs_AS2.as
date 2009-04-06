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
		if (movie==null || movie.name==null || movie==StaticFunctions.someMovieClip) return '';
		return getDisplayObjectDesc(movie.parent)+"."+movie.name +
			(movie is MovieClip ? "[frame="+(movie as MovieClip).currentLabel +"]" : "");		
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
		return dictionarySize(dic)==0;
	}
	public static function dictionarySize(dic:Dictionary):int {
		var size:int = 0;
		for (var key:Object in dic)
			size++;
		return size;
	}
	public static function myRemoveEventListener(dispatcher:IEventDispatcher, type:String, listener:Function):void {
		var dic1:Dictionary = listener2dispatcher2type2wrapper[dispatcher];
		if (dic1==null) return;
		var dic2:Dictionary = dic1[listener];
		if (dic2==null) return;
		var func:Function = dic2[type];
		if (func==null) return;
		delete dic2[type];
		if (isDictionaryEmpty(dic2)) delete dic1[listener];
		if (isDictionaryEmpty(dic1)) delete listener2dispatcher2type2wrapper[dispatcher];
		dispatcher.removeEventListener(type, func);
	}			
	public static function myRemoveAllEventListeners(dispatcher:IEventDispatcher):void {
		var dic1:Dictionary = listener2dispatcher2type2wrapper[dispatcher];
		var dic2:Dictionary;
		var listener:Function;
		if (dic1==null) return;
		for(var listenerObj:Object in dic1){
			listener = listenerObj as Function;
			dic2 = dic1[listener];
			if(dic2 == null)	continue;
			for(var type:String in dic2){
				dispatcher.removeEventListener(type, listener);
			}
		}
		delete listener2dispatcher2type2wrapper[dispatcher];
	}
	public static function myAddEventListener(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean=false, priority:int=0, weakReference:Boolean=false):Function {		
		var func:Function = ErrorHandler.wrapWithCatch("myAddEventListener."+type+" for "+getQualifiedClassName(dispatcher), listener);		
		if (listener2dispatcher2type2wrapper[dispatcher] == null)
			listener2dispatcher2type2wrapper[dispatcher] = new Dictionary(true); // with weak keys	
		var dic1:Dictionary = listener2dispatcher2type2wrapper[dispatcher];		
		if (dic1[listener] == null)
			dic1[listener] = new Dictionary(false);	// with strong keys		
		dic1[listener][type] = func;		
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
		trace("Showing message: msg kind="+kind+
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
	public static function sendToURL(vars:Object, url:String):void {
		AS3_Loader.sendToURL(vars, URLRequestMethod.POST, url);	
	}
	
} // end AS3_vs_AS2
}
import come2play_as3.api.auto_copied.SerializableClass;
import come2play_as3.api.auto_copied.AS3_vs_AS2;
import flash.utils.*;

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
