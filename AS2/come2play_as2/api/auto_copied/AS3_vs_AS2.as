import come2play_as2.api.auto_copied.*;

class come2play_as2.api.auto_copied.AS3_vs_AS2 {
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
				LocalConnectionUser.error("LocalConnection.onStatus error! (Are you sure you are running this game inside the emulator?)");
		};
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
		if (res==null) LocalConnectionUser.throwError("Missing child='"+childName+"' in movieclip="+graphics);
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
	
	//todo: use __CLASS_NAME__ in SerializableClass as well (because when we add __CLASS_NAME__ to the prototype, it is serialized in LocalConnection, so no point in having two properties with the same content) 
	public static function getClassName(o:Object):String {
		//typeof is not good enough! for SerializableClass I want to know the class name
		// when you create a class, it is stored in _global.PACKAGES...CLASS_NAME
		// so I traverse _global, and lookup the __proto__, and when I find it, as an optimization I store it as __CLASS_NAME__
		var prot:Object = o.__proto__;
		if (prot.hasOwnProperty(SerializableClass.CLASS_NAME_FIELD)) return prot[SerializableClass.CLASS_NAME_FIELD]; // shortcut optimization (so we won't lookup the class name for every object)
		var res:String = p_getClassName(_global, prot);
		if (res==null) return typeof o; 
		prot.__CLASS_NAME__ = res;
		return res;
	}
	private static function p_getClassName(glob:Object, prot:Object):String {
		if (glob.prototype==prot) return "";
		for (var key in glob) {
			var res = p_getClassName(glob[key],prot);
			if (res!=null) return key+(res!="" ? "." : "")+res;
		}
		return null;
	}
	public static function createInstanceOf(className:String):Object {
		var classConstructor:Function = eval(className);
		return new classConstructor();
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
		var container:MovieClip =_root.createEmptyMovieClip("___error_message"+Math.random(), _root.getNextHighestDepth());
		container.beginFill(0x000000, 0);
		container.moveTo(0, 0);
		container.lineTo(300, 0);
		container.lineTo(300, 300);
		container.lineTo(0, 300);
		container.lineTo(0, 0);
		container.endFill();
		var label:TextField = container.createTextField("label", 1, 0, 0, 300, 300);
		label.text = msg;
		label.textColor = 0xFF0000;
	}

	public static function IndexOf(arr:Array, val:Object):Number {
		for (var i:Number=0; i<arr.length; i++)
			if (arr[i]==val) return i;
		return -1;
	}
	public static function LastIndexOf(arr:Array, val:Object):Number {
		for (var i:Number=arr.length-1; i>=0; i--)
			if (arr[i]==val) return i;
		return -1;
	}
}