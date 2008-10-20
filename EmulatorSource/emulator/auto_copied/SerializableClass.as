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

	
/**
 * A class extends SerializableClass
 * to get two features:
 * - serialization on LocalConnection
 * 	 by adding the field __CLASS_NAME__
 * - serialization to String
 *   by adding "toString()" method.
 *   The serialized string has JSON-like syntax:
 *   {$SHORT_CLASSNAME$ field1:value1 , field2:value2 , ... }

// This is a AUTOMATICALLY GENERATED! Do not change!

 *   For example: 
 *   {$EnumSupervisor$ name:"MiniSupervisor"}
 * 
 * Restriction:
 * - serialized fields must be public (non-static)
 * - constructor without arguments
 * - You must call 
 *   register()
 * 
 * Other features:

// This is a AUTOMATICALLY GENERATED! Do not change!

 * - fields starting with "__" are not serialized to String 
 *   (but they are serialized on LocalConnection)
 * - Your class may override
 *   public function postDeserialize():Object
 *   that may do post processing and even return a different object.
 *   This is useful in two cases:
 *   1) if you have fields that are derived from other fields (such as "__" fields).
 *   2) in Enum classes, postDeserialize may return a unique/interned object.   
 */
public class SerializableClass

// This is a AUTOMATICALLY GENERATED! Do not change!

{
	public static var IS_THROWING_EXCEPTIONS:Boolean = true; // in the online version we set it to false. (Consider the case that a hacker stores illegal values as secret data)
	
	public static const CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	public var __CLASS_NAME__:String;
	public function SerializableClass(shortName:String) {
		__CLASS_NAME__ = shortName;
		register();
	}
	public function toString():String {

// This is a AUTOMATICALLY GENERATED! Do not change!

		var fieldNames:Array/*String*/ = AS3_vs_AS2.getFieldNames(this);
		var values:Object = {};			
		for each (var key:String in fieldNames) {
			if (StaticFunctions.startsWith(key,"__")) continue;
			values[key] = this[key]; 
		}
		return JSON.instanceToString(__CLASS_NAME__, values);
	}
	public function isEqual(other:SerializableClass):Boolean {
		return ObjectDictionary.areEqual(this, other);

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
	public function postDeserialize():SerializableClass {
		return this;
	}
	public function register():void {
    	var xlass:Class = getClassOfInstance(this); 
    	var shortName:String = __CLASS_NAME__;
    	var oldXlass:Class = SHORTNAME_TO_CLASS[shortName];
    	if (oldXlass==xlass) return; // already entered this short name
    	

// This is a AUTOMATICALLY GENERATED! Do not change!

    	StaticFunctions.assert(oldXlass==null, ["Previously added shortName=",shortName, " with oldXlass=",oldXlass," and now with xlass=",xlass]);
    	SHORTNAME_TO_CLASS[shortName] = xlass; 
    	
    	AS3_vs_AS2.checkConstructorHasNoArgs(this);    	
    	StaticFunctions.storeTrace(["Registered class with shortName=",shortName," with exampleInstance=",this]);
    	// testing createInstance
    	var exampleInstance:SerializableClass = createInstance(shortName);    	
    }

	/**

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * Static methods and variables.
	 */
 	private static var SHORTNAME_TO_CLASS:Object = {};
 	private static function getShortNameOfInstance(instance:SerializableClass):String {
 		var xlass:Class = getClassOfInstance(instance);
		for (var shortName:String in SHORTNAME_TO_CLASS) {
			if (SHORTNAME_TO_CLASS[shortName]==xlass)
				return shortName;
		}
		return null; 		

// This is a AUTOMATICALLY GENERATED! Do not change!

 	}
 	private static function getClassOfInstance(instance:SerializableClass):Class {
 		return AS3_vs_AS2.getClassOfInstance(instance);
 	}
	private static function createInstance(shortName:String):SerializableClass {
		var xlass:Class = SHORTNAME_TO_CLASS[shortName];		
		return xlass==null ? null : new xlass();
	}    
 	
	public static function deserialize(object:Object):Object {

// This is a AUTOMATICALLY GENERATED! Do not change!

		try {
			if (object==null) 
				return object;
			var isArray:Boolean = AS3_vs_AS2.isArray(object);
			var isObj:Boolean = isObject(object);
			var res:Object = object;
			if (isArray || isObj) {				
				var shortName:String = 
					object.hasOwnProperty(CLASS_NAME_FIELD) ? 
					object[CLASS_NAME_FIELD] : null;

// This is a AUTOMATICALLY GENERATED! Do not change!

				res = isArray ? [] : {}; // we create a new copy
		
				for (var key:String in object)
					res[key] = deserialize(object[key]); 
					
				if (shortName!=null) {					
					var newObject:SerializableClass = createInstance(shortName);
					if (newObject!=null) {
						for (key in res)
							newObject[key] = res[key]; // might throw an illegal assignment (due to type mismatch)

// This is a AUTOMATICALLY GENERATED! Do not change!


						AS3_vs_AS2.checkAllFieldsDeserialized(res, newObject);

						res = newObject.postDeserialize();
					}
				}
										
			}
			//trace(JSON.stringify(object)+" object="+object+" res="+res+" isArray="+isArray+" isObj="+isObj);
			return res; 						

// This is a AUTOMATICALLY GENERATED! Do not change!

		} catch (err:Error) {
			// I can't throw an exception, because if a hacker stored illegal value in shortName, 
			//	then it will cause an error (that may be discovered only in the reveal stage)
			// instead the client should call setMaybeHackerUserId before processing secret data.
			StaticFunctions.storeTrace("Exception thrown in deserialize:"+AS3_vs_AS2.error2String(err));
			if (IS_THROWING_EXCEPTIONS)
				throw err;
		}
		return object;
	}	

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function isToStringObject(str:String):Boolean {
		return str=="[object Object]";
	}
	public static function isObject(o:Object):Boolean {
		return isToStringObject(o.toString());	
	}
}
}
