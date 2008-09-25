// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/SerializableClass.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{

// This is a AUTOMATICALLY GENERATED! Do not change!


public class SerializableClass
{
	public static var IS_THROWING_EXCEPTIONS:Boolean = true; // in the online version we set it to false. (Consider the case that a hacker stores illegal values as secret data)
	
	public static const CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	
	// Because the shared classes have different package names, 
	// I need to replace it before and after serialization
	public static const REPLACE_IN_NAME:String = "emulator";

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static const REPLACE_TO:String = "COME2PLAY_PACKAGE";
	
	// Only in the API we should deserialize user-defined classes
	// (in the emulator and framework, we should deserialize only COME2PLAY_PACKAGE)  
	public static const isInAPI:Boolean =  REPLACE_IN_NAME=="come2play_as3."+"api";// I replace 'come2play_as3 . api .', so don't remove the  ."+"
	
	public var __CLASS_NAME__:String;
	public function SerializableClass() {
		__CLASS_NAME__ = AS3_vs_AS2.getClassName(this);
		if (__CLASS_NAME__==null || AS3_vs_AS2.stringIndexOf(__CLASS_NAME__,"$")!=-1) 

// This is a AUTOMATICALLY GENERATED! Do not change!

			StaticFunctions.throwError("Illegal class name '"+__CLASS_NAME__+"' for a class that extends SerializableClass. You should only use PUBLIC classes with SerializableClass");
		AS3_vs_AS2.checkConstructorHasNoArgs(this);
		
		
		if (StaticFunctions.startsWith(__CLASS_NAME__,REPLACE_IN_NAME)) {
			__CLASS_NAME__ = REPLACE_TO + __CLASS_NAME__.substr(REPLACE_IN_NAME.length);			
		}
	}
	public static function isToStringObject(str:String):Boolean {
		return str=="[object Object]";

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public static function isObject(o:Object):Boolean {
		return isToStringObject(o.toString());	
	}
	public static function deserialize(object:Object):Object {
		try {
			if (object==null) 
				return object;
			var isArray:Boolean = AS3_vs_AS2.isArray(object);
			var isObj:Boolean = isObject(object);

// This is a AUTOMATICALLY GENERATED! Do not change!

			var res:Object = object;
			if (isArray || isObj) {				
				var className:String = 
					object.hasOwnProperty(CLASS_NAME_FIELD) ? object[CLASS_NAME_FIELD] : null;
				res = isArray ? [] : {}; // we create a new copy
		
				var newObject:Object = null;
				if (className!=null) {
					var isAPI_Package:Boolean =
						StaticFunctions.startsWith(className, REPLACE_TO);

// This is a AUTOMATICALLY GENERATED! Do not change!

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

// This is a AUTOMATICALLY GENERATED! Do not change!

					
				for (var key:String in object)
					res[key] = deserialize(object[key]); // might throw an illegal assignment (due to type mismatch)
			}
			//trace(JSON.stringify(object)+" object="+object+" res="+res+" isArray="+isArray+" isObj="+isObj);
			return res; 						
		} catch (err:Error) {
			// I can't throw an exception, because if a hacker stored illegal value in className, 
			//	then it will cause an error (that may be discovered only in the reveal stage)
			// instead the client should do a "is" check.

// This is a AUTOMATICALLY GENERATED! Do not change!

			trace("Exception thrown in deserialize:"+AS3_vs_AS2.error2String(err));
			if (IS_THROWING_EXCEPTIONS)
				throw err;
		}
		return object;
	}	
}
}
