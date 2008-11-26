// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/AS3_vs_AS2.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
﻿package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!

import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.*;
	
public final class AS3_vs_AS2
{
	public static const isAS3:Boolean = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function specialToString(o:Object):String {
		return  o is Error ? error2String(o as Error) :
			o is ByteArray ? byteArr2Str(o as ByteArray) :
			o is XML ? (o as XML).toXMLString() :
			o is Date ? '"'+(o as Date).toLocaleTimeString()+'"' :
			o.toString();
	}
	public static function byteArr2Str(byteArr:ByteArray):String {
		var bytes:Array = [];
		for (var i:int=0; i<byteArr.length; i++)

// This is a AUTOMATICALLY GENERATED! Do not change!

			bytes.push(byteArr.readByte());
		byteArr.position = 0;
		return "["+bytes.join(", ")+"]";
	}
	public static function isNumber(o:Object):Boolean {
		return o is Number;
	}
	public static function isBoolean(o:Object):Boolean {
		return o is Boolean;
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function asArray(o:Object):Array {
		return o as Array;
	}
	public static function asSerializableClass(o:Object):SerializableClass {
		return o as SerializableClass;
	}
	
	public static function delegate(thisObj:Object, handler:Function, ... args):Function {
		return function (...otherArgs):Object { 

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	
	// because in our framework we wrap the event listener with try&catch
	// similary, our framework have a better error report mechanism (than an error window)
	public static var myAddEventListenerFunc:Function = null; 
	public static var myShowError:Function = null;
	private static function assertNotFramework():void {
		StaticFunctions.assert(myAddEventListenerFunc==null,["You cannot call this method in framework"]);
	}
	private static function myAddEventListener(dispatcher:IEventDispatcher, type:String, listener:Function):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (SerializableClass.IS_IN_FRAMEWORK) {
			StaticFunctions.assert(myAddEventListenerFunc!=null,["Come2play forgot to set myAddEventListenerFunc"]);
			myAddEventListenerFunc(dispatcher, type, listener);
		} else {
			dispatcher.addEventListener(type,listener);
		}
	}
	
	
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

        //Event.INIT
        //Event.OPEN
        //ProgressEvent.PROGRESS
        //Event.UNLOAD
        myAddEventListener(contentLoaderInfo, Event.COMPLETE, function (event:Event):void {
				if (TRACE_LOADING) StaticFunctions.storeTrace(["Done loading url=",url]);
				newMovie.addChild(loader.content);
				if (onLoaded!=null) onLoaded(true);
			}  );
		myAddEventListener(contentLoaderInfo, IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		        if (TRACE_LOADING) StaticFunctions.storeTrace(["Error in loading movie from url=",url," event=",event]);
		        if (onLoaded!=null) onLoaded(false);
		    }  );
		graphics.addChild(newMovie);
		if (TRACE_LOADING) StaticFunctions.storeTrace(["Loading url=",url," into a newly created child of=",graphics.name]);
		loader.load(new URLRequest(url));
		return newMovie;
	}
	public static function scaleMovie(graphics:DisplayObject, x_percentage:int, y_percentage:int):void {
		scaleMovieX(graphics,x_percentage);

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	} 	
	public static function setAlpha(target:DisplayObject, alphaPercentage:int):void {
		target.alpha = alphaPercentage/100;
	}
	public static function setMovieXY(target:DisplayObject, x:int, y:int):void {
		target.x = x;
		target.y = y;		
	} 	
	
	public static function createEmptyMovieClip(graphics:MovieClip, name:String):MovieClip {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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
	public static function showError(graphics:DisplayObjectContainer, msg:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		trace("Showing error: "+msg);
		if (myShowError!=null) {
			myShowError(msg);
			return;
		}
		if (graphics==null) return;
		var blackBox:Sprite=new Sprite();
		blackBox.graphics.beginFill(0x000000);
		blackBox.graphics.drawRect(0,0,300,300);
		blackBox.graphics.endFill();

// This is a AUTOMATICALLY GENERATED! Do not change!

		var child:TextField = new TextField();
		child.text = msg;
		child.width = 300;
		child.height = 300;
		
		var buttonText:TextField = new TextField();
		
		//buttonText.textColor = 0x000000;
		buttonText.text = "close";
		buttonText.setTextFormat(new TextFormat("Times New Roman",14,0x000000),0,5);

// This is a AUTOMATICALLY GENERATED! Do not change!

		buttonText.selectable = false;
		
		
		var buttonBox:Sprite=new Sprite();
		buttonBox.graphics.beginFill(0xffffff);
		buttonBox.graphics.drawRect(0,0,40,20);
		buttonBox.graphics.endFill();
		buttonBox.addChild(buttonText);
		buttonBox.x = 240
		buttonBox.y = 260;

// This is a AUTOMATICALLY GENERATED! Do not change!

		var closeBtn:SimpleButton = new SimpleButton(buttonBox,buttonBox,buttonBox,buttonBox);
		blackBox.addChild(child);
		blackBox.addChild(closeBtn);

		//child.backgroundColor = 0xFF0000; // red
		child.textColor = 0xFF0000; // red
		
		
		graphics.addChild(blackBox);
		myAddEventListener(closeBtn, MouseEvent.CLICK, 

// This is a AUTOMATICALLY GENERATED! Do not change!

			function():void {
				trace("close")
				graphics.removeChild(blackBox);
				} 
			);
	}
	
	
	
	public static function IndexOf(arr:Array, val:Object):int {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

					}
				});
	}

	/**
	 * XML differences between AS2 and AS3.
	 * In AS2 I use XMLNode.
	 */
	public static function xml_create(str:String):XML {
		return new XML(str);

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

		for each (var child:XML in list)
			res.push(child);
		return res;			
	}
		

	/**
	 * Serialization and handling classes and classNames
	 */
	public static function getClassName(o:Object):String {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function getClassOfInstance(instance:Object):Class {
		var className:String = getClassName(instance);
		var res:Class = getClassByName(className);
		StaticFunctions.assert(res!=null, ["Missing class for instance=",instance, " className=",className]);
		return res;		
	}
	private static var checkedClasses:Object = {};
	public static function checkConstructorHasNoArgs(obj:SerializableClass):void {
		var className:String = obj.__CLASS_NAME__;
		if (checkedClasses[className]!=null) return;

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

			fieldNames = [];
			// we could have also used ByteArray.writeObject,
			// but I think this is more readable
			// Sadly, a simple for loop doesn't go over the fields of a class (like it does in AS2)
			// For loops do not work on classes in AS3 for classes (only for dynamic properties):
			// Iterates over the dynamic properties of an object or elements in an array and executes statement for each property or element. Object properties are not kept in any particular order, so properties may appear in a seemingly random order. Fixed properties, such as variables and methods defined in a class, are not enumerated by the for..in statement. To get a list of fixed properties, use the describeType() function, which is in the flash.utils package. 

			var fieldsList:XMLList = describeType(instance).variable;
			for each (var fieldInfo:XML in fieldsList)
				fieldNames.push( fieldInfo.attribute("name") );			

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

			checkObjectIsSerializable(field);
	}
	
}
}
