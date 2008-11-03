import come2play_as2.api.auto_copied.*;
class come2play_as2.api.auto_copied.ObjectDictionary extends SerializableClass
{
	// maps a hash of an object to an array of entries
	// each entry is: [key,value]
	//all the variables of this class are public because it extends SerializableClass
	public var hashMap:Object;
	public var pSize:Number;
	// the order of inserted keys and values is important in the API for server entries
	public var allKeys:Array;
	public var allValues:Array;

	public function ObjectDictionary()
	{
		hashMap = new Object();
		pSize = 0;	
		allKeys = [];
		allValues = [];
	}
	
	private function getEntry(key:Object):Array {
		return getEntry2(key, hashObject(key));
	}
	private function getEntry2(key:Object, hash:Number):Array {
		if (hashMap[hash]==null) return null;
		var entries:Array = hashMap[hash];
		for (var i26:Number=0; i26<entries.length; i26++) { var entry:Array = entries[i26]; 
			var entryKey:Object = entry[0];
			if (areEqual(entryKey,key)) 
				return entry;
			// not equal, let's check if someone changed the keys
			
			/*if (hashObject(entryKey)!=hash)
				throw new Error("You have mutated a key that was previously inserted to this ObjectDictionary! All keys must be immutable! mutated-key="+JSON.stringify(entryKey)+" looking-for-key="+JSON.stringify(key));
		*/
		}
		return null;		
	}
	public function size():Number {
		return pSize;
	}
	public function getValues():Array {		
		return allValues;		
	}
	public function getKeys():Array {		
		return allKeys;		
	}
	public function hasKey(key:Object):Boolean {
		return getEntry(key)!=null;
	}
	public function getValue(key:Object):Object {
		var entry:Array = getEntry(key);
		return entry==null ? null : entry[1];
	}
	public function remove(key:Object):Object {
		var hash:Number = hashObject(key);
		if (hashMap[hash]==null) return null;
		var entries:Array = hashMap[hash];
		for (var i:Number=0; i<entries.length; i++) {
			var entry:Array = entries[i];
			var oldKey:Object = entry[0];
			if (areEqual(oldKey,key)) {
				entries.splice(i,1);
				pSize--;
				
				var indexInAll:Number = AS3_vs_AS2.IndexOf(allKeys,oldKey);
				if (indexInAll==-1) throw new Error("Internal error in ObjectDictionary");
				allKeys.splice(indexInAll,1);
				allValues.splice(indexInAll,1);
				
				return entry[1];					
			}				
		}
		return null;
	}
	public function put(key:Object, value:Object):Void {
		var hash:Number = hashObject(key);		
		var entry:Array = getEntry2(key, hash);
		if (entry==null) {
			if (hashMap[hash]==null) hashMap[hash] = [];
			var entries:Object = hashMap[hash];
			entries.push( [key, value] );
			pSize++;
			
			allKeys.push(key);
			allValues.push(value);		
		} else {
			// replace value
			entry[1] = value;		
						
			var oldKey:Object = entry[0];
			var indexInAll:Number = AS3_vs_AS2.IndexOf(allKeys,oldKey);
			allValues[indexInAll] = value;
		}
	}
	
	// Some primes: Do I want to use them to hash an array?
	// 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139
	public static function hashObject(o:Object):Number {
		if (o==null) return 541;		
        if (AS3_vs_AS2.isBoolean(o))	
			return o ? 523 : 521;		
        if (AS3_vs_AS2.isNumber(o))
        	return AS3_vs_AS2.convertToInt(o);  
        var res:Number;
	    if (AS3_vs_AS2.isString(o)) {
	    	var str:String = o.toString();
	    	var len:Number = str.length;
	    	res = 509;
	    	for (var i:Number = 0; i < len; i++) {
	       		res <<= 1;
                res ^= str.charCodeAt(i);
            }
            return res;
	    } 
        if (AS3_vs_AS2.isArray(o)) {
        	res = 503;        	
	       	for (i = 0; i < o.length; i++) {
	       		res <<= 1;
	       		res ^= hashObject(o[i]);
	       	}
	       	return res;        	
        }
        
        res = 499;        	
        for (var z:String in o) {
        	res ^= hashObject(z)^hashObject(o[z]);
	    }
       	return res; 
	}
	public static function areEqual(o1:Object, o2:Object):Boolean {
		if (o1===o2) return true; // because false==[] or {} was true!
		if (o1==null || o2==null) return false;
		var t:String = typeof(o1);
		if (t!=typeof(o2)) 
			return false;
		if (AS3_vs_AS2.getClassName(o1)!=AS3_vs_AS2.getClassName(o2))
			return false;
			
		if (t=="object") {
			var x:String;	
			var allFields:Object = {};
			var c:Number = 0;	
			for (x in o1) {
				allFields[x] = true;
				c++;
			}			
			for (x in o2) {
				if (allFields[x]==null) return false;
				c--;
			}
			if (c!=0) return false; // not the same number of dynamic properties
			if (AS3_vs_AS2.isAS3) {
				// for static properties we use describeType
				// because o1 and o2 have the same type, it is enough to use the fields of o1.
				var fieldsArr:Array = AS3_vs_AS2.getFieldNames(o1);
				for (var i156:Number=0; i156<fieldsArr.length; i156++) { var field:String = fieldsArr[i156]; 
					allFields[field] = true;
				}
			}
			for (x in allFields) 	
				if (!o1.hasOwnProperty(x) || 
					!o2.hasOwnProperty(x) || 
					!areEqual(o1[x], o2[x])) return false;
			return true;
		} else {
			return o1==o2;
		}
	}
}
