package come2play_as3.api.auto_copied
{
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.text.TextField;
import flash.text.TextFormat;
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
	
	public static function specialToString(o:Object):String {
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
	public static function as_int(o:Object):int {
		return o as int;
	}
	public static function convertToInt(o:Object):int {
		return int(o);
	}
	public static function asBoolean(o:Object):Boolean {
		return o as Boolean;
	}
	public static function asString(o:Object):String {
		return o as String;
	}
	public static function asArray(o:Object):Array {
		return o as Array;
	}
	public static function asSerializableClass(o:Object):SerializableClass {
		return o as SerializableClass;
	}
	
	public static function delegate(thisObj:Object, handler:Function, ... args):Function {
		return function (...otherArgs):Object { 
				return handler.apply(thisObj, otherArgs.concat(args) ); 
			};
	}
	public static function addOnPress(movie:IEventDispatcher, func:Function, isActive:Boolean):void {
		assertNotFramework();
		//function (event:MouseEvent):void { 
		movie.removeEventListener(MouseEvent.CLICK , func);
		if (isActive)
			movie.addEventListener(MouseEvent.CLICK , func);
	}
	public static function addOnMouseOver(movie:IEventDispatcher, mouseOverFunc:Function, mouseOutFunc:Function, isActive:Boolean):void {		
		assertNotFramework();
		//function (event:MouseEvent):void { 		
		movie.removeEventListener(MouseEvent.MOUSE_OVER , mouseOverFunc);		
		movie.removeEventListener(MouseEvent.MOUSE_OUT , mouseOutFunc);
		if (isActive) {
			movie.addEventListener(MouseEvent.MOUSE_OVER , mouseOverFunc);		
			movie.addEventListener(MouseEvent.MOUSE_OUT , mouseOutFunc);
		}
	}	
	
	
	// because in our framework we wrap the event listener with try&catch
	// similary, our framework have a better error report mechanism (than an error window)
	public static var myAddEventListenerFunc:Function = null; 
	public static var myShowError:Function = null;
	private static function assertNotFramework():void {
		StaticFunctions.assert(myAddEventListenerFunc==null,["You cannot call this method in framework"]);
	}
	private static function myAddEventListener(dispatcher:IEventDispatcher, type:String, listener:Function):void {
		if (SerializableClass.IS_IN_FRAMEWORK) {
			StaticFunctions.assert(myAddEventListenerFunc!=null,["Come2play forgot to set myAddEventListenerFunc"]);
			myAddEventListenerFunc(dispatcher, type, listener);
		} else {
			dispatcher.addEventListener(type,listener);
		}
	}
	
	
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array):void {
		conn.client = client;
		myAddEventListener(conn, StatusEvent.STATUS, 
			function (event:StatusEvent):void {
        		if (event.level=='error')
        			StaticFunctions.showError("LocalConnection.onStatus error="+event+" client="+client+" client's class="+getClassName(client)+". Are you sure you are running this game inside the emulator?)"); 
  			});		
	}
	public static function myTimeout(func:Function, in_milliseconds:int):void {		
		assertNotFramework();
		setTimeout(func,in_milliseconds);
	}
	public static function error2String(e:Error):String {
		return e.toString()+" stacktraces="+e.getStackTrace();
	}
	public static function getTimeString():String {
		return new Date().toLocaleTimeString();
	}
	public static function getLoaderInfoParameters(someMovieClip:DisplayObject):Object {
		return someMovieClip.loaderInfo.parameters;
	}
	public static function getMovieChild(graphics:MovieClip, childName:String):MovieClip {
		return getChild(graphics, childName) as MovieClip;
	}
	public static function getChild(graphics:MovieClip, childName:String):DisplayObject {
		var res:DisplayObject = graphics.getChildByName(childName);
		if (res==null) StaticFunctions.throwError("Missing child="+childName+" in movieclip="+graphics.name);
		return res;
	}	
	private static var prevent_garbage_collection:Array = [];
	public static var TRACE_LOADING:Boolean = false;
	public static function loadMovieIntoNewChild(graphics:MovieClip, 
			url:String, onLoaded:Function):DisplayObject {
		var loader:Loader = new Loader();
		prevent_garbage_collection.push(loader);
		var newMovie:DisplayObjectContainer = new Sprite();
		var contentLoaderInfo:LoaderInfo = loader.contentLoaderInfo;
		// Possible events for contentLoaderInfo:
		//Event.COMPLETE
        //IOErrorEvent.IO_ERROR
        //HTTPStatusEvent.HTTP_STATUS
        //Event.INIT
        //Event.OPEN
        //ProgressEvent.PROGRESS
        //Event.UNLOAD
        myAddEventListener(contentLoaderInfo, Event.COMPLETE, function (event:Event):void {
				if (TRACE_LOADING) StaticFunctions.storeTrace(["Done loading url=",url]);
				newMovie.addChild(loader.content);
				if (onLoaded!=null) onLoaded(true);
			}  );
		var handler:Function = function (event:Event):void {
		        if (TRACE_LOADING) StaticFunctions.storeTrace(["Error in loading movie from url=",url," event=",event]);
		        if (onLoaded!=null) onLoaded(false);
		    };
		myAddEventListener(contentLoaderInfo, IOErrorEvent.IO_ERROR, handler);
		myAddEventListener(contentLoaderInfo, SecurityErrorEvent.SECURITY_ERROR, handler);
		graphics.addChild(newMovie);
		if (TRACE_LOADING) StaticFunctions.storeTrace(["Loading url=",url," into a newly created child of=",graphics.name]);
		loader.load(new URLRequest(url));
		return newMovie;
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
	public static function createMovieInstance(graphics:MovieClip, linkageName:String, name:String):MovieClip {
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
			assertNotFramework();
			var intervalId:int = setInterval( 
				function ():void {
					if (graphics.stage!=null) {
						trace("stage is ready, so we now call addKeyboardListener");
						clearInterval(intervalId);					
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
	public static function showError(graphics:DisplayObjectContainer, msg:String):void {
		trace("Showing error: myShowError="+myShowError+
			" graphics="+graphics+
			" graphics.stage="+ (graphics==null ? "null" : graphics.stage) +
			" msg="+msg);
		if (myShowError!=null) {
			myShowError(msg);
			return;
		}
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
		buttonBox.x = 440
		buttonBox.y = 460;
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
		trace("Finished showing error message");
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
		var stageTimer:Timer = new Timer(100,0);
		stageTimer.start();	
		myAddEventListener(stageTimer,
			TimerEvent.TIMER, function():void {
					if(graphics.stage) {
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
		return new XML(str);
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
	
}
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
		return new XML(xmlStr);
	}	
}
class DateSerializable extends NativeSerializable {
	public var utcDate:String; //Tue Feb 1 00:00:00 2005 UTC
	public function DateSerializable(date:Date=null) {
		super("Date");
		utcDate = date==null ? null : date.toUTCString();
	}	
	override public function fromNative(obj:Object):NativeSerializable {
		return obj is Date ? new DateSerializable(obj as Date) : null;
	}
	override public function postDeserialize():Object {
		return new Date(utcDate);
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