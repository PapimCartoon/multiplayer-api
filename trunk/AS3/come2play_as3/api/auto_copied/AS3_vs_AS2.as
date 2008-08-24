package come2play_as3.api.auto_copied
{
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.*;
import flash.net.LocalConnection;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;
	
public final class AS3_vs_AS2
{
	public static const isAS3:Boolean = true;
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
	public static function toString(o:Object):String {		
		if (o is XML) return (o as XML).toXMLString();
		return o.toString();
	}
	
	public static function delegate(thisObj:Object, handler:Function, ... args):Function {
		return function (...otherArgs):Object { 
				return handler.apply(thisObj, otherArgs.concat(args) ); 
			};
	}
	public static function addOnPress(movie:IEventDispatcher, func:Function):void {		
		movie.addEventListener(MouseEvent.CLICK , function (event:MouseEvent):void { func(); });
	}
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array):void {
		conn.client = client;
		conn.addEventListener(StatusEvent.STATUS, 
			function (event:StatusEvent):void {
        		if (event.level=='error')
        			LocalConnectionUser.error("LocalConnection.onStatus error="+event+" (Are you sure you are running this game inside the emulator?)"); 
  			});		
	}
	public static function myTimeout(func:Function, in_milliseconds:int):void {
		setTimeout(func,in_milliseconds);
	}
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
	public static function setMovieXY(source:MovieClip, target:MovieClip, x_delta:int, y_delta:int):void {
		var x:int = source.x;
		var y:int = source.y;
		target.x = x+x_delta;
		target.y = y+y_delta;		
	} 	
	public static function createInstanceOf(className:String):Object {
		var _Class:Class = getDefinitionByName(className) as Class;
		if (_Class==null) LocalConnectionUser.error("ClassName '"+className+"' was not found!");
		return new _Class();		
	}
	public static function duplicateMovie(graphics:MovieClip, name:String):MovieClip {
		var className:String = getQualifiedClassName(graphics);
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
	}
	
	public static function IndexOf(arr:Array, val:Object):int {
		return arr.indexOf(val);
	}	
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
}