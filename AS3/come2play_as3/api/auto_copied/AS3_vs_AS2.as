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
        			StaticFunctions.showError("LocalConnection.onStatus error="+event+" client="+client+" client's class="+getClassName(client)+". Are you sure you are running this game inside the emulator?)"); 
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
		if (res==null) StaticFunctions.throwError("Missing child="+childName+" in movieclip="+graphics.name);
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
	public static function setVisible(graphics:MovieClip, isVisible:Boolean):void {
		graphics.visible = isVisible;
	} 	
	public static function setAlpha(target:MovieClip, alphaPercentage:int):void {
		target.alpha = alphaPercentage/100;
	}
	public static function setMovieXY(target:MovieClip, x:int, y:int):void {
		target.x = x;
		target.y = y;		
	} 	
	public static function getClassByName(className:String):Object {
		try {
			return getDefinitionByName(className);
		} catch (err:Error) {
			throw new Error("The class named '"+className+"' was not found!");
		}	
		return null;
	}
	public static function createInstanceOf(className:String):Object {
		var _Class:Class = getClassByName(className) as Class;
		return new _Class();
	}
	public static function createMovieInstance(graphics:MovieClip, linkageName:String, name:String):MovieClip {
		var dup:MovieClip = createInstanceOf(linkageName) as MovieClip;
		dup.name = name;
		graphics.addChild(dup);
		return dup;
	}
	public static function removeMovie(graphics:MovieClip, name:String):void {
		graphics.parent.removeChild( graphics.parent.getChildByName(name) );
	}
	public static function addKeyboardListener(graphics:MovieClip, func:Function):void {
		var isStageReady:Boolean = graphics.stage!=null;
		if (isStageReady)	
			addKeyboardListenerStageReady(graphics, func);
		else {
			trace("Called addKeyboardListener, but stage is still null, so we set an interval until stage is ready");
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
	private static function addKeyboardListenerStageReady(graphics:MovieClip, func:Function):void {
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
		var child:TextField = new TextField();
		child.text = msg;
		child.width = 300;
		child.height = 300;
		
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
		buttonBox.x = 240
		buttonBox.y = 260;
		var closeBtn:SimpleButton = new SimpleButton(buttonBox,buttonBox,buttonBox,buttonBox);
		blackBox.addChild(child);
		blackBox.addChild(closeBtn);

		//child.backgroundColor = 0xFF0000; // red
		child.textColor = 0xFF0000; // red
		
		
		graphics.addChild(blackBox);
		closeBtn.addEventListener(MouseEvent.CLICK, 
			function():void {
				trace("close")
				graphics.removeChild(blackBox);
				} 
			);
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
			if (constructor.children().length()!=0)
				StaticFunctions.throwError("The constructor of class "+className+" that extends SerializableClass has arguments! These are the parameters of the constructor="+constructor.toXMLString()); 
		}
		// I want to check that all fields are non-static and public,
		// but describeType only returns such fields in the first place.
		//<variable name="col" type="int"/>
	}	
	private static var name2classFields:Object = {}; // mapping class names to an array of field names
	public static function checkAllFieldsDeserialized(obj:Object, newInstance:Object):void {
		var className:String = getClassName(newInstance);
		var fieldNames:Array = name2classFields[className];
		if (fieldNames==null) {
			fieldNames = [];
			var fieldsList:XMLList = describeType(newInstance).variable;
			for each (var fieldInfo:XML in fieldsList)
				fieldNames.push( fieldInfo.attribute("name") );			
			name2classFields[className] = fieldNames;			
		}
		for each (var fieldName:String in fieldNames)
			if (!obj.hasOwnProperty(fieldName))
				throw new Error("When deserializing className="+className+", we didn't find fieldName="+fieldName+" in object="+JSON.stringify(obj));	
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
	public static function waitForStage(graphics:MovieClip, gameConsructor:Function):void
	{
		var stageTimer:Timer = new Timer(100,0);
		stageTimer.start();	
		stageTimer.addEventListener(TimerEvent.TIMER,function():void {
				if(graphics.stage)
				{
					stageTimer.stop();
					gameConsructor();
				}
				} 
			);
	}		

}
}