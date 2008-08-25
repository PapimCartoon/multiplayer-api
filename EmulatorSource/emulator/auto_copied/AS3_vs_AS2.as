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
import flash.text.TextField;
import flash.utils.*;
	
public final class AS3_vs_AS2
{
	public static const isAS3:Boolean = true;
	public static function isNumber(o:Object):Boolean {

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function asString(o:Object):String {
		return o as String;
	}
	public static function asArray(o:Object):Array {
		return o as Array;
	}
	public static function toString(o:Object):String {		
		if (o is XML) return (o as XML).toXMLString();
		return o.toString();
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	
	public static function delegate(thisObj:Object, handler:Function, ... args):Function {
		return function (...otherArgs):Object { 
				return handler.apply(thisObj, otherArgs.concat(args) ); 
			};
	}
	public static function addOnPress(movie:IEventDispatcher, func:Function):void {		
		movie.addEventListener(MouseEvent.CLICK , function (event:MouseEvent):void { func(); });
	}
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

		conn.client = client;
		conn.addEventListener(StatusEvent.STATUS, 
			function (event:StatusEvent):void {
        		if (event.level=='error')
        			LocalConnectionUser.showError("LocalConnection.onStatus error="+event+" (Are you sure you are running this game inside the emulator?)"); 
  			});		
	}
	public static function myTimeout(func:Function, in_milliseconds:int):void {
		setTimeout(func,in_milliseconds);
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function error2String(e:Error):String {
		return e.toString()+" stacktraces="+e.getStackTrace();
	}
	public static function getClassName(o:Object):String {
		return getQualifiedClassName(o);
	}
	public static function getTimeString():String {
		return new Date().toLocaleTimeString();
	}
	public static function getLoaderInfoParameters(someMovieClip:MovieClip):Object {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return someMovieClip.loaderInfo.parameters;
	}
	public static function getMovieChild(graphics:MovieClip, childName:String):MovieClip {
		return getChild(graphics, childName) as MovieClip;
	}
	public static function getChild(graphics:MovieClip, childName:String):DisplayObject {
		var res:DisplayObject = graphics.getChildByName(childName);
		if (res==null) LocalConnectionUser.throwError("Missing child="+childName+" in movieclip="+graphics.name);
		return res;
	}	

// This is a AUTOMATICALLY GENERATED! Do not change!

	private static var prevent_garbage_collection:Array = [];
	public static function loadMovie(graphics:MovieClip, url:String):void {
		var loader:Loader = new Loader();
		prevent_garbage_collection.push(loader);
		var contentLoaderInfo:LoaderInfo = loader.contentLoaderInfo;
		contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event):void {
		        graphics.addChild(loader.content);
			}  );
		contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void {
		        trace("Error in loading movie from url="+url+" event="+event);

// This is a AUTOMATICALLY GENERATED! Do not change!

		    }  );
		loader.load(new URLRequest(url));
	}
	public static function scaleMovie(graphics:MovieClip, x_percentage:int, y_percentage:int):void {
		graphics.scaleX = Number(x_percentage)/100;
		graphics.scaleY = Number(y_percentage)/100;		
	} 	
	public static function setVisible(graphics:MovieClip, is_visible:Boolean):void {
		graphics.visible = is_visible;
	} 	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function setMovieXY(source:MovieClip, target:MovieClip, x_delta:int, y_delta:int):void {
		var x:int = source.x;
		var y:int = source.y;
		target.x = x+x_delta;
		target.y = y+y_delta;		
	} 	
	public static function getClassByName(className:String):Object {
		try {
			return getDefinitionByName(className);
		} catch (err:Error) {

// This is a AUTOMATICALLY GENERATED! Do not change!

			throw new Error("The class named '"+className+"' was not found!");
		}	
		return null;
	}
	public static function createInstanceOf(className:String):Object {
		var _Class:Class = getClassByName(className) as Class;
		return new _Class();
	}
	public static function duplicateMovie(graphics:MovieClip, name:String):MovieClip {
		var className:String = getQualifiedClassName(graphics);

// This is a AUTOMATICALLY GENERATED! Do not change!

		var dup:MovieClip = createInstanceOf(className) as MovieClip;
		dup.name = name;
		graphics.parent.addChild(dup);
		return dup;
	}
	public static function removeMovie(graphics:MovieClip, name:String):void {
		graphics.parent.removeChild( graphics.parent.getChildByName(name) );
	}
	public static function addKeyboardListener(graphics:MovieClip, func:Function):void {
		addKeyboardListener2(true, graphics, func);

// This is a AUTOMATICALLY GENERATED! Do not change!

		addKeyboardListener2(false, graphics, func);		
	}
	private static function addKeyboardListener2(is_key_down:Boolean, graphics:MovieClip, func:Function):void {
		graphics.stage.addEventListener(is_key_down ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, 
			function (event:KeyboardEvent):void {
				var charCode:int = event.charCode;
				var keyCode:int = event.keyCode;
				var keyLocation:int = event.keyLocation;
				var altKey:Boolean = event.altKey;
				var ctrlKey:Boolean = event.ctrlKey;

// This is a AUTOMATICALLY GENERATED! Do not change!

				var shiftKey:Boolean = event.shiftKey;
				func(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey);
			});	
	}
	public static function showError(graphics:MovieClip, msg:String):void {
		trace("Showing error: "+msg);
		if (graphics==null) return;
		var blackBox:Sprite=new Sprite();
		blackBox.graphics.beginFill(0x000000);
		blackBox.graphics.drawRect(0,0,300,300);

// This is a AUTOMATICALLY GENERATED! Do not change!

		blackBox.graphics.endFill();
		if (graphics==null) return;
		var child:TextField = new TextField();
		child.text = msg;
		child.width = 300;
		child.height = 300;
		//child.backgroundColor = 0xFF0000; // red
		child.textColor = 0xFF0000; // red
		graphics.addChild(blackBox);
		graphics.addChild(child);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	
	
	private static var checkedClasses:Object = {};
	public static function checkConstructorHasNoArgs(obj:SerializableClass):void {
		var className:String = obj.__CLASS_NAME__;
		if (checkedClasses[className]!=null) return;
		checkedClasses[className] = true;
		//trace("Checking ctor of "+className);
		var constructorList:XMLList = describeType(obj).constructor;

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (constructorList.length()>0) {
			var constructor:XML = constructorList[0];
			if (constructor.children().length()!=0)
				LocalConnectionUser.throwError("The constructor of class "+className+" that extends SerializableClass has arguments! These are the parameters of the constructor="+constructor.toXMLString()); 
		}
	}	
	
	public static function IndexOf(arr:Array, val:Object):int {
		return arr.indexOf(val);
	}	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function LastIndexOf(arr:Array, val:Object):int {
		return arr.lastIndexOf(val);
	}	
	public static function stringIndexOf(str:String, val:String):int {
		return str.indexOf(val);
	}	
	public static function stringLastIndexOf(str:String, val:String):int {
		return str.lastIndexOf(val);
	}	
}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
