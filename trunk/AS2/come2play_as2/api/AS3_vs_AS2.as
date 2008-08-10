import come2play_as2.api.*;

class come2play_as2.api.AS3_vs_AS2 {
	public static var isAS3:Boolean = false;
	public static function isNumber(o:Object):Boolean {
		return (typeof o)=="number";
	}
	public static function isBoolean(o:Object):Boolean {
		return (typeof o)=="boolean";
	}
	public static function isString(o:Object):Boolean {
		return (typeof o)=="string";
	}
	public static function isArray(o:Object):Boolean {
		return (typeof o)=="object" && o.length!=null;
	}
	public static function convertToInt(o):Number {
		return o==null ? 0 : Math.round(o);
	}
	public static function asBoolean(o):Boolean {
		return Boolean(o);
	}
	public static function asString(o):String {
		return String(o);
	}
	public static function as_int(o):Number {
		return Math.round(o);
	}
	public static function asArray(o):Array {
		return o;
	}
	public static function asUserEntry(o):UserEntry {
		return o;
	}
	public static function delegate(target:Object, handler:Function):Function {
		var extraArgs:Array = arguments.slice(2);
		return function() {
			var fullArgs:Array = arguments.concat(extraArgs); 
			//trace("Calling function target="+target+" fullArgs="+fullArgs);
			return handler.apply(target, fullArgs);
		};
	}
	public static function addOnPress(movie:MovieClip, func:Function):Void {
		//trace("Adding onPress to movie="+movie+" func="+func);
		movie.onPress = function () {trace("Pressed on movie="+movie+" func="+func); func(); };
	}
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array):Void {
		for (var i:Number=0; i<functions.length; i++) {
			var key:String = functions[i];
			conn[key] = delegate(client, client[key]);
		}
		conn.onStatus = function(infoObject:Object) { 
			if (infoObject.level=='error')
				BaseGameAPI.error("LocalConnection.onStatus error! (Are you sure you are running this game inside the emulator?)");
		};
	}
	
	public static function hasOwnProperty(thisObj:Object, property:String):Boolean {
		return thisObj[property]!=null;
	}
	public static function myTimeout(func:Function, in_milliseconds:Number):Void {
		var res_interval_id:Number;
		res_interval_id = setInterval( function () {
				clearInterval(res_interval_id);
				func();
			}, in_milliseconds);
	}
	public static function error2String(e:Error):String {
		return e.toString();//+" stacktraces="+e.getStackTrace();
	}
	public static function getClassName(o:Object):String {
		return typeof o;
	}
	public static function getTimeString():String {
		return ''+getTimer();
	}
	
	public static function getLoaderInfoParameters(graphics:MovieClip):Object {
		return _root;
	}	
	public static function getMovieChild(graphics:MovieClip, childName:String):MovieClip {
		return getChild(graphics, childName);
	}
	public static function getChild(graphics:MovieClip, childName:String):MovieClip {
		var res:MovieClip = graphics[childName];
		if (res==null) BaseGameAPI.throwError("Missing child='"+childName+"' in movieclip="+graphics);
		return res;
	}	
	public static function loadMovie(graphics:MovieClip, url:String):Void {
		graphics.loadMovie(url);
	}
	public static function scaleMovie(graphics:MovieClip, x_percentage:Number, y_percentage:Number):Void {
		graphics._xscale = x_percentage;
		graphics._yscale = y_percentage;		
	}		
	public static function setVisible(graphics:MovieClip, is_visible:Boolean):Void {
		graphics._visible = is_visible;
	} 	
	public static function setMovieXY(source:MovieClip, target:MovieClip, x_delta:Number, y_delta:Number):Void {
		var x:Number = source._x;
		var y:Number = source._y;
		target._x = x+x_delta;
		target._y = y+y_delta;		
	} 			
	public static function duplicateMovie(graphics:MovieClip, name:String):MovieClip {
		var dup:MovieClip = graphics.duplicateMovieClip(name, graphics._parent.getNextHighestDepth() );
		//trace("duplicateMovieClip: graphics="+graphics+" name="+name+" dup="+dup+" _root.Square_0_0="+_root["Square_0_0"] );
		return dup;		
	}	
	public static function removeMovie(graphics:MovieClip, name:String):Void {
		graphics.removeMovieClip( graphics._parent[name] );
	}
	public static function addKeyboardListener(graphics:MovieClip, func:Function):Void {
		var myListener:Object = {};
		addKeyboardListener2(true, myListener, func);
		addKeyboardListener2(false, myListener, func);
		Key.addListener( myListener );	
	}
	public static function addKeyboardListener2(is_key_down:Boolean, myListener:Object, func:Function):Void {		
		myListener[is_key_down ? "onKeyDown" : "onKeyUp"]  = function () { 	
			var charCode:Number = Key.getAscii();
			var keyCode:Number = Key.getCode();
			// keyCodes for NUM_PAD: 96-105 106 107 109 110 111
			// there is no way in AS2 to differentiate between LEFT or RIGHT (e.g., for control or shift it is exactly the same code) 
			var keyLocation:Number = keyCode>=96 && keyCode<=111 ? 3 : 0; //STANDARD : uint = 0, LEFT : uint = 1, RIGHT : uint = 2, NUM_PAD : uint = 3
			var altKey:Boolean = Key.isDown(18); //Alt
			var ctrlKey:Boolean = Key.isDown(Key.CONTROL);
			var shiftKey:Boolean = Key.isDown(Key.SHIFT);
			func(is_key_down, charCode, keyCode, keyLocation, altKey, ctrlKey, shiftKey);
		}
	}
	public static function showError(graphics:MovieClip, msg:String):Void {
		var container:MovieClip =
			_root.createEmptyMovieClip("___error_message"+Math.random(), _root.getNextHighestDepth());
			
		var label:TextField = container.createTextField("label", 1, 0, 0, 300, 300);
		label.text = msg;
		label.textColor = 0xFF0000;
	}

	public static function IndexOf(arr:Array, val:Object):Number {
		for (var i:Number=0; i<arr.length; i++)
			if (arr[i]==val) return i;
		return -1;
	}
}