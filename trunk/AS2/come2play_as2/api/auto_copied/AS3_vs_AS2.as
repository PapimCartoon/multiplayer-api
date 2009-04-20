import come2play_as2.api.auto_copied.*;

class come2play_as2.api.auto_copied.AS3_vs_AS2 {
	public static var isAS3:Boolean = false;

	// in AS3 we have special serializers for some native classes (such as Dictionary, XML, Date, etc)
	public static function registerNativeSerializers():Void {}
	public static function specialToString(o:Object):String {
		return o.toString();
	}
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
	public static function isSerializableClass(o:Object):Boolean {
		return o instanceof SerializableClass;
	}
	public static function convertToInt(o):Number {
		return o==null ? 0 : Math.round(o);
	}
	public static function asBoolean(o):Boolean {
		return o;
	}
	public static function asString(o):String {
		return o;
	}
	public static function as_int(o):Number {
		return o;
	}
	public static function asArray(o):Array {
		return o;
	}	
	public static function asSerializableClass(o):SerializableClass {
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
	public static function addOnPress(movie:MovieClip, func:Function, isActive:Boolean):Void {
		//trace("Adding onPress to movie="+movie+" func="+func);
		movie.onPress = isActive ? func : null; //function () {trace("Pressed on movie="+movie+" func="+func); func(); };
	}	
	public static function addOnMouseOver(movie:MovieClip, mouseOverFunc:Function, mouseOutFunc:Function, isActive:Boolean):Void {		
		movie.onRollOver = isActive ? mouseOverFunc : null; 
		movie.onRollOut = isActive ? mouseOutFunc : null; 
	}
	public static function addStatusListener(conn:LocalConnection, client:Object, functions:Array,handlerFun:Function):Void {
		for (var i:Number=0; i<functions.length; i++) {
			var key:String = functions[i];
			conn[key] = delegate(client, client[key]);
		}
		conn.onStatus = function(infoObject:Object) { 
			if (infoObject.level=='error'){
				if(handlerFun != null)
					handlerFun(false)
				else
					StaticFunctions.showError("LocalConnection.onStatus error! (Are you sure you are running this game inside the emulator?)");
			}else{
				if(handlerFun != null)
					handlerFun(true);
			}
		};
	}
	
  	// use ErrorHandler.myTimeout and myInterval because they have proper error handling
	public static function unwrappedSetInterval(zoneName:String, func:Function, in_milliseconds:Number):Object {
		return setInterval(ErrorHandler.wrapWithCatch(zoneName,func), in_milliseconds);
	}
	public static function unwrappedSetTimeout(zoneName:String, func:Function, in_milliseconds:Number):Object {
		var res_interval_id:Number;
		res_interval_id = setInterval( ErrorHandler.wrapWithCatch(zoneName,function () {
				clearInterval(res_interval_id);
				func();
			}), in_milliseconds);
		return res_interval_id;
	}
	public static function unwrappedClearInterval(zoneName:String, intervalId:Object):Void {
		clearInterval(Number(intervalId));
	}
	public static function unwrappedClearTimeout(zoneName:String, intervalId:Object):Void {
		unwrappedClearInterval(zoneName, intervalId);
	}
	public static function myGetStackTrace(e:Error):String {
		return null;
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
	public static function getLoaderInfoUrl(graphics:MovieClip):String {
		return _root._url;
	}	
	public static function getMovieChild(graphics:MovieClip, childName:String):MovieClip {
		return getChild(graphics, childName);
	}
	public static function getChild(graphics:MovieClip, childName:String):MovieClip {
		var res:MovieClip = graphics[childName];
		if (res==null) StaticFunctions.throwError("Missing child='"+childName+"' in movieclip="+graphics);
		return res;
	}	
	
	public static var TRACE_LOADING:Boolean = false;
	public static function loadMovieIntoNewChild(graphics:MovieClip, url:String, onLoaded:Function):MovieClip {
		
		// create a new child, and load the url into that new child
		var depth:Number = graphics.getNextHighestDepth();
		var res:MovieClip = graphics.createEmptyMovieClip("LOADMOVIE"+depth,depth);
		var inner:MovieClip = res.createEmptyMovieClip("INNER",0); // I need another inner clip, because if we immediately call setVisible(res, false), then when the movie is later loaded then the visible turns back to true.
		if (TRACE_LOADING) StaticFunctions.storeTrace(["Loading url=",url," into newMovie=",inner]);
		
		if (false) {
			inner.loadMovie(url);
		} else {
			var loadListener:Object = new Object();
			//onLoadComplete
			loadListener.onLoadInit = function ():Void { 
				if (TRACE_LOADING) StaticFunctions.storeTrace(["Done loading url=",url]);
				if (onLoaded!=null) onLoaded(true); 
			} 
			loadListener.onLoadError = function ():Void { 
				if (TRACE_LOADING) StaticFunctions.storeTrace(["Error in loading movie from url=",url]);
				if (onLoaded!=null) onLoaded(false); 
			}

			var mcl:MovieClipLoader = new MovieClipLoader();
			mcl.addListener(loadListener);
			mcl.loadClip(url, inner);
		}

		return res;
	}
	public static function scaleMovie(graphics:MovieClip, x_percentage:Number, y_percentage:Number):Void {
		scaleMovieX(graphics,x_percentage);
		scaleMovieY(graphics,y_percentage);	
	}		
	public static function scaleMovieX(graphics:MovieClip, x_percentage:Number):Void {
		graphics._xscale = x_percentage;		
	}		
	public static function scaleMovieY(graphics:MovieClip, y_percentage:Number):Void {
		graphics._yscale = y_percentage;
	}		
	public static function setVisible(graphics:MovieClip, is_visible:Boolean):Void {
		graphics._visible = is_visible;
	} 	
	public static function setAlpha(target:MovieClip, alphaPercentage:Number):Void {
		//trace("setAlpha==="+alphaPercentage+" target="+target);
		target._alpha = alphaPercentage;
	}
	public static function setMovieXY(target:MovieClip, x:Number, y:Number):Void {
		target._x = x;
		target._y = y;		
	} 			
	


	public static function createEmptyMovieClip(graphics:MovieClip, name:String):MovieClip {
		var depth:Number = graphics.getNextHighestDepth();
		var newInstance:MovieClip = graphics.createEmptyMovieClip(name,  depth);
		return newInstance;
	}
	public static function createMovieInstance(graphics:MovieClip, linkageName:String, name:String):MovieClip {
		var depth:Number = graphics.getNextHighestDepth();
		var newInstance:MovieClip = graphics.attachMovie(linkageName, name,  depth);
		//trace("createMovieInstance: graphics="+graphics+" linkageName="+linkageName+" name="+name+" depth="+depth+" newInstance="+newInstance);
		return newInstance;		
	}	
	public static function removeMovie(graphics:MovieClip):Void {
		graphics.removeMovieClip();
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
	
	public static function sendToURL(vars:Object, url:String):Void {
		// use load vars in AS2 to send the error report (use method=POST)
		var lv:LoadVars = new LoadVars();
		var result:LoadVars = new LoadVars();
		StaticFunctions.tmpTrace(["sendToURL url=",url]); //," vars=",vars
		result.onData = function (src:String) {
			StaticFunctions.tmpTrace(["Url returned the following result: ",src]);
		};
		for (var k:String in vars) {
			lv[k] = vars[k];		
		}
		lv.sendAndLoad(url, result, "POST");
	}
	public static function sendMultipartImage(bug_id:Number):Void {
		// to complicated to convert SendMultipartImage to AS2
	}
	//public static var isInterval:Boolean = false
	public static function showError(msg:String):Void {
		//if (!isInterval) {
		//	isInterval = true;
		//	setInterval(showError,4000,graphics,msg);
		//}
		showMessage(msg, "error");
	}
	public static function showMessage(msg:String, kind:String):Void {
		trace("I started showMessage: msg="+msg+" getNextHighestDepth="+_root.getNextHighestDepth());
		
		_root._visible = true;
		_root._alpha = 100;
		var msgMcName:String = "___error_message"+Math.random();
		var container:MovieClip =_root.createEmptyMovieClip(msgMcName,_root.getNextHighestDepth());
		container.beginFill(0x000000);
		container.moveTo(0, 0);
		container.lineTo(500, 0);
		container.lineTo(500, 500);
		container.lineTo(0, 500);
		container.lineTo(0, 0);
		container.endFill();
		var label:TextField = container.createTextField("label", 1, 0, 0, 500, 500);
		label.selectable = true;
		label.text = msg;
		label.textColor = 0xFF0000;
		trace("I finished showMessage")
		
		if (kind!="error") {
			unwrappedSetTimeout("showMessage", function ():Void {
				trace("removeMovieClip container="+msgMcName);
				container.removeMovieClip();
				}, 2000);
		}
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
	
	public static function stringIndexOf(str:String, val:String, startIndex:Number):Number {
		return startIndex!=null ? str.indexOf(val, startIndex) : str.indexOf(val);
	}	
	public static function stringLastIndexOf(str:String, val:String, startIndex:Number):Number {
		return startIndex!=null ? str.lastIndexOf(val, startIndex) : str.lastIndexOf(val);
	}	
	
	public static function waitForStage(graphics:MovieClip, gameConsructor:Function):Void {
		// no stage in AS2...
		gameConsructor();
	}


	/**
	 * XML differences between AS2 and AS3.
	 * In AS2 I use XMLNode.
	 */	 
	public static function xml_create(str:String):XMLNode {
		return (new XML(str)).firstChild;
	}
	public static function xml_getName(xml:XMLNode):String {
		return xml.nodeName;
	}
	public static function xml_getSimpleContent(xml:XMLNode):String {
		var res:String = xml.nodeValue;
		if (res!=null) return res;
		res = xml.firstChild.nodeValue;
		return res==null ? '' : res;
	}
	public static function xml_getChildren(xml:XMLNode):Array/*XMLNode*/ {
		var res:Array = [];
		for (var i:Number =0 ; i<xml.childNodes.length; i++) {
			var child:XMLNode = xml.childNodes[i];
			if (child.nodeName==null) continue;
			res.push(child);
		}
		return res;			
	}
		

	/**
	 * Serialization and handling classes and classNames
	 */	
	// we use CLASS_NAME_FIELD (because when we add CLASS_NAME_FIELD to the prototype, it is serialized in LocalConnection, so no point in having two properties with the same content) 
	public static function getClassName(o:Object):String {
		var typeOfName:String = typeof(o);
		if (typeOfName=="string") return "String";
		if (typeOfName=="movieclip") return "MovieClip";
		if (typeOfName=="boolean") return "Boolean";
		if (typeOfName=="number") return "Number";
		if (typeOfName=="function") return "Function";
			 
		//typeof is not good enough! for SerializableClass I want to know the class name
		// when you create a class, it is stored in _global.PACKAGES...CLASS_NAME
		// so I traverse _global, and lookup the __proto__, and when I find it, as an optimization I store it as CLASS_NAME_FIELD
		var prot:Object = o.__proto__;
		var as2_class_name:String = SerializableClass.CLASS_NAME_FIELD; // also, the AS3 can't create an additional property name (we don't use dynamic classes)
		if (prot.hasOwnProperty(as2_class_name)) return prot[as2_class_name]; // shortcut optimization (so we won't lookup the class name for every object)
		var res:String = p_getClassName(_global, prot);
		if (res==null || res=='') return typeof o; 

		// replace the last '.' with '::' (to use the same notation as in AS3)
		//trace('getClassName for o='+o+' res='+res);
		if (stringIndexOf(res,'.')!=-1) // maybe the class doesn't have a package, like 'GraphicCommand'
			res = StaticFunctions.replaceLastOccurance(res, '.', '::');

		prot[as2_class_name] = res;
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
	
	// For Serialization, Reflection, and in TestClientGameAPI
	// We use AS3 notation, where class name is:  PACKAGE1.PACKAGE2.PACKAGE3::CLASSNAME
	public static function getClassByName(className:String):Object {
		className = StaticFunctions.replaceLastOccurance(className, '::', '.');

		return eval(className);
	}
	public static function getClassOfInstance(instance:Object):Object {
		//return instance.__proto__; // I couldn't create a new instance from the prototype
		return getClassByName( getClassName(instance) );
	}
	public static function getFieldNames(instance:Object):Array {
		// in AS3 we use  describeType(instance).variable 
		var fieldNames:Array = [];
		for (var key:String in instance)
			fieldNames.push(key);
		return fieldNames;			
	}

	public static function checkConstructorHasNoArgs(obj:Object):Void {
		// can only be done in AS3
	}
	public static function checkAllFieldsDeserialized(obj:Object, newInstance:Object):Void {
		// can only be done in AS3
	}
	public static function checkObjectIsSerializable(obj:Object):Void {
		// can only be done in AS3
	}
}