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
	public var __CLASS_NAME__:String;
	public function SerializableClass() {
		__CLASS_NAME__ = AS3_vs_AS2.getClassName(this);
	}
	public static function deserialize(object:Object):Object {
		if (object==null) 
			return object;
		var className:String = 
			object.hasOwnProperty(CLASS_NAME_FIELD) ? object[CLASS_NAME_FIELD] : null; 
		var res:Object = 
			className==null ? object : // we modify the object itself (so we can recurse into arrays and objects)
			AS3_vs_AS2.createInstanceOf(className);
		for (var key:String in object)
			res[key] = deserialize(object[key]);
		return res; 
	}	
}
