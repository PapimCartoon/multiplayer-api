// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/ObjectDictionary.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{
	import flash.utils.ByteArray;
	

// This is a AUTOMATICALLY GENERATED! Do not change!

public final class ObjectDictionary extends SerializableClass
{
	// maps a hash of an object to an array of entries
	// each entry is: [key,value]
	//all the variables of this class are public because it extends SerializableClass
	public var hashMap:Object;
	public var pSize:int;
	// the order of inserted keys and values is important in the API for server entries
	public var allKeys:Array;
	public var allValues:Array;

// This is a AUTOMATICALLY GENERATED! Do not change!


	public function ObjectDictionary()
	{
		hashMap = new Object();
		pSize = 0;	
		allKeys = [];
		allValues = [];
	}
	
	private function getEntry(key:Object):Array {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return getEntry2(key, hashObject(key));
	}
	private function getEntry2(key:Object, hash:int):Array {
		if (hashMap[hash]==null) return null;
		var entries:Array = hashMap[hash];
		for each (var entry:Array in entries) {
			var entryKey:Object = entry[0];
			if (areEqual(entryKey,key)) 
				return entry;
			// not equal, let's check if someone changed the keys
			/*
			if (hashObject(entryKey)!=hash)
				throw new Error("You have mutated a key that was previously inserted to this ObjectDictionary! All keys must be immutable! mutated-key="+JSON.stringify(entryKey)+" looking-for-key="+JSON.stringify(key));
		*/
		}
		return null;		
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	public function size():int {
		return pSize;
	}
	public function getValues():Array {		
		return allValues;		
	}
	public function getKeys():Array {		
		return allKeys;		
	}
	public function hasKey(key:Object):Boolean {

// This is a AUTOMATICALLY GENERATED! Do not change!

		return getEntry(key)!=null;
	}
	public function getValue(key:Object):Object {
		var entry:Array = getEntry(key);
		return entry==null ? null : entry[1];
	}
	public function remove(key:Object):Object {
		var hash:int = hashObject(key);
		if (hashMap[hash]==null) return null;
		var entries:Array = hashMap[hash];

// This is a AUTOMATICALLY GENERATED! Do not change!

		for (var i:int=0; i<entries.length; i++) {
			var entry:Array = entries[i];
			var oldKey:Object = entry[0];
			if (areEqual(oldKey,key)) {
				entries.splice(i,1);
				pSize--;
				
				var indexInAll:int = AS3_vs_AS2.IndexOf(allKeys,oldKey);
				if (indexInAll==-1) throw new Error("Internal error in ObjectDictionary");
				allKeys.splice(indexInAll,1);

// This is a AUTOMATICALLY GENERATED! Do not change!

				allValues.splice(indexInAll,1);
				
				return entry[1];					
			}				
		}
		return null;
	}
	public function put(key:Object, value:Object):void {
		var hash:int = hashObject(key);		
		var entry:Array = getEntry2(key, hash);

// This is a AUTOMATICALLY GENERATED! Do not change!

		if (entry==null) {
			if (hashMap[hash]==null) hashMap[hash] = [];
			var entries:Object = hashMap[hash];
			entries.push( [key, value] );
			pSize++;
			
			allKeys.push(key);
			allValues.push(value);		
		} else {
			// replace value

// This is a AUTOMATICALLY GENERATED! Do not change!

			entry[1] = value;		
						
			var oldKey:Object = entry[0];
			var indexInAll:int = AS3_vs_AS2.IndexOf(allKeys,oldKey);
			allValues[indexInAll] = value;
		}
	}
	
	// Some primes: Do I want to use them to hash an array?
	// 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function hashObject(o:Object):int {
		if (o==null) return 541;		
        if (AS3_vs_AS2.isBoolean(o))	
			return o ? 523 : 521;		
        if (AS3_vs_AS2.isNumber(o))
        	return AS3_vs_AS2.convertToInt(o);  
        var res:int;
	    if (AS3_vs_AS2.isString(o)) {
	    	var str:String = o.toString();
	    	var len:int = str.length;

// This is a AUTOMATICALLY GENERATED! Do not change!

	    	res = 509;
	    	for (var i:int = 0; i < len; i++) {
                res = 31*res + str.charCodeAt(i);
            }
            return res;
	    } 
        if (AS3_vs_AS2.isArray(o)) {
        	res = 503;        	
	       	for (i = 0; i < o.length; i++) {
	       		res = 31*res + hashObject(o[i]);

// This is a AUTOMATICALLY GENERATED! Do not change!

	       	}
	       	return res;        	
        }
        
        res = 499;        	
        for (var z:String in o) {
        	res += hashObject(z)*hashObject(o[z]);
	    }
        trace("o="+JSON.stringify(o)+" res="+res);
       	return res; 
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

	public static function areEqual(o1:Object, o2:Object):Boolean {
		if (o1===o2) return true; // because false==[] or {} was true!
		if (o1==null || o2==null) return false;
		var t:String = typeof(o1);
		if (t!=typeof(o2)) 
			return false;
		if (AS3_vs_AS2.getClassName(o1)!=AS3_vs_AS2.getClassName(o2))
			return false;
			
		if (t=="object") {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var x:String;
			for(x in o1)
				if (!areEqual(o1[x], o2[x])) return false;
			for(x in o2)
				if (!areEqual(o1[x], o2[x])) return false;
			return true;
		} else {
			return o1==o2;
		}
	}

// This is a AUTOMATICALLY GENERATED! Do not change!

}
}
