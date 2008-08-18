package come2play_as3.api
{
/**
 * Subclasses of SerializableClass MUST have an empty constructor,
 * i.e., their constructor must not take any arguments.
 * 
 * deserialize recurses inside the object (into arrays and objects)
 * and turns every object inside that has the attribute  __className__ 
 * It modifies the object!
 */
public class SerializableClass
{
	private var __className__:String;
	public function SerializableClass() {
		__className__ = AS3_vs_AS2.getClassName(this);		
	}
	public static function deserialize(object:Object):Object {
		if (object==null) 
			return object;
		var className:String = 
			AS3_vs_AS2.hasOwnProperty(object,"__className__") ? object["__className__"] : null; 
		var res:Object = 
			className==null ? object : // we modify the object itself (so we can recurse into arrays and objects)
			AS3_vs_AS2.createInstanceOf(className);
		for (var key:String in object)
			res[key] = deserialize(object[key]);
		return res; 
	}	
}
}