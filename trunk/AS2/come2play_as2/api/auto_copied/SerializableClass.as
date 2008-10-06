	import come2play_as2.api.auto_generated.API_Message;
	

import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.SerializableClass
{
	public static var IS_THROWING_EXCEPTIONS:Boolean = true; // in the online version we set it to false. (Consider the case that a hacker stores illegal values as secret data)
	
	public static var CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	
	// Because the shared classes have different package names, 
	// I need to replace it before and after serialization
	public static var REPLACE_IN_NAME:String = "come2play_as2.api";
	public static var REPLACE_TO:String = "COME2PLAY_PACKAGE";
	
	// Only in the API we should deserialize user-defined classes
	// (in the emulator and framework, we should deserialize only COME2PLAY_PACKAGE)  
	public static var isInAPI:Boolean =  REPLACE_IN_NAME=="come2play_as2."+"api";// I replace 'come2play_as2 . api .', so don't remove the  ."+"
	
	public var __CLASS_NAME__:String;
	public function SerializableClass() {
		__CLASS_NAME__ = AS3_vs_AS2.getClassName(this);
		if (__CLASS_NAME__==null || AS3_vs_AS2.stringIndexOf(__CLASS_NAME__,"$")!=-1) 
			StaticFunctions.throwError("Illegal class name '"+__CLASS_NAME__+"' for a class that extends SerializableClass. You should only use PUBLIC classes with SerializableClass");
		AS3_vs_AS2.checkConstructorHasNoArgs(this);
		
		
		if (StaticFunctions.startsWith(__CLASS_NAME__,REPLACE_IN_NAME)) {
			__CLASS_NAME__ = REPLACE_TO + __CLASS_NAME__.substr(REPLACE_IN_NAME.length);			
		}
	}
	
	public static function message2String(msg:API_Message):String {
		var fieldNames:Array = msg.getFieldNames();
		var res:Array = [];
		for (var i35:Number=0; i35<fieldNames.length; i35++) { var key:String = fieldNames[i35]; 
			res.push( key + ":" + JSON.stringify(msg[key]) ); 
		}
		return "{ $"+msg.getClassName()+"$ " + res.join(" , ") + "}"; // see JSON.parse
	}
	public static function isToStringObject(str:String):Boolean {
		return str=="[object Object]";
	}
	public static function isObject(o/*:Object*/):Boolean {
		return isToStringObject(o.toString());	
	}
	public static function deserialize(object/*:Object*/)/*:Object*/ {
		try {
			if (object==null) 
				return object;
			var isArray:Boolean = AS3_vs_AS2.isArray(object);
			var isObj:Boolean = isObject(object);
			var res/*:Object*/ = object;
			if (isArray || isObj) {				
				var className:String = 
					object.hasOwnProperty(CLASS_NAME_FIELD) ? object[CLASS_NAME_FIELD] : null;
				res = isArray ? [] : {}; // we create a new copy
		
				var newObject/*:Object*/ = null;
				if (className!=null) {
					var isAPI_Package:Boolean =
						StaticFunctions.startsWith(className, REPLACE_TO);
					if (isAPI_Package) {
						className = REPLACE_IN_NAME + className.substr(REPLACE_TO.length);
					}			 
					if (isInAPI || isAPI_Package) {
						newObject = AS3_vs_AS2.createInstanceOf(className);	
						if (newObject!=null) res = newObject;
					}
				}
				if (newObject!=null)
					AS3_vs_AS2.checkAllFieldsDeserialized(object, newObject);
					
				for (var key:String in object)
					res[key] = deserialize(object[key]); // might throw an illegal assignment (due to type mismatch)
			}
			//trace(JSON.stringify(object)+" object="+object+" res="+res+" isArray="+isArray+" isObj="+isObj);
			return res; 						
		} catch (err:Error) {
			// I can't throw an exception, because if a hacker stored illegal value in className, 
			//	then it will cause an error (that may be discovered only in the reveal stage)
			// instead the client should do a "is" check.
			trace("Exception thrown in deserialize:"+AS3_vs_AS2.error2String(err));
			if (IS_THROWING_EXCEPTIONS)
				throw err;
		}
		return object;
	}	
}
