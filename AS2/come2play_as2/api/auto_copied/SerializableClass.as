/**
 * Subclasses of SerializableClass MUST have an empty constructor,
 * i.e., their constructor must not take any arguments.
 * 
 * deserialize recurses inside the object (into arrays and objects)
 * and turns every object inside that has the attribute  __className__ 
 * It modifies the object!
 */
import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.SerializableClass
{
	public static var CLASS_NAME_FIELD:String = "__CLASS_NAME__";
	
	// because the shared classes have different package names, I need to replace it before and after serialization
	public static var REPLACE_IN_NAME:String = "come2play_as2.api.";
	public static var REPLACE_TO:String = "COME2PLAY_PACKAGE.";
	
	// Only in the API we should deserialize user-defined classes
	// (in the emulator and framework, we should deserialize only COME2PLAY_PACKAGE   
	public static var isInAPI:Boolean =  REPLACE_IN_NAME=="come2play_as2."+"api.";// I replace 'come2play_as2 . api .', so don't remove the  ."+"
	
	public var __CLASS_NAME__:String;
	public function SerializableClass() {
		__CLASS_NAME__ = AS3_vs_AS2.getClassName(this);
		if (__CLASS_NAME__.substr(0,REPLACE_IN_NAME.length)==REPLACE_IN_NAME) {
			__CLASS_NAME__ = REPLACE_TO + __CLASS_NAME__.substr(REPLACE_IN_NAME.length);			
		}
	}
	public static function deserialize(object:Object):Object {
		if (object==null) 
			return object;
		var className:String = 
			object.hasOwnProperty(CLASS_NAME_FIELD) ? object[CLASS_NAME_FIELD] : null;

		var res:Object = object; // we modify the object itself (so we can recurse into arrays and objects)

		if (className!=null) {
			var isAPI_Package:Boolean = className.substr(0,REPLACE_TO.length)==REPLACE_TO;
			if (isAPI_Package) {
				className = REPLACE_IN_NAME + className.substr(REPLACE_TO.length);
			}			 
			if (isInAPI || isAPI_Package) {
				var newObject:Object = AS3_vs_AS2.createInstanceOf(className);
				if (newObject!=null) res = newObject;
			}
		}
		for (var key:String in object)
			res[key] = deserialize(object[key]);
		return res; 
	}	
}
