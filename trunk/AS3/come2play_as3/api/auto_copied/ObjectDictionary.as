package come2play_as3.api.auto_copied
{
public final class ObjectDictionary
{
	// maps a hash of an object to an array of entries
	// each entry is: [key,value]
	private var hashMap:Object;
	private var pSize:int;
	public function ObjectDictionary() {
		hashMap = new Object();
		pSize = 0;		
	}
	
	private function getEntry(key:Object):Array {
		var hash:int = hashObject(key);
		if (hashMap[hash]==null) return null;
		var entries:Array = hashMap[hash];
		for each (var entry:Array in entries) {
			if (areEqual(entry[0],key)) return entry;
		}
		return null;		
	}
	public function size():int {
		return pSize;
	}
	public function getKeys():Array {
		var res:Array = [];
		for each (var entries:Array in hashMap) {
			for each (var entry:Array in entries) {
				res.push( entry[0] );
			}
		}
		return res;		
	}
	public function hasKey(key:Object):Boolean {
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
		for (var i:int=0; i<entries.length; i++) {
			var entry:Array = entries[i];
			if (areEqual(entry[0],key)) {
				entries.splice(i,1);
				pSize--;
				return entry[1];					
			}				
		}
		return null;
	}
	public function put(key:Object, value:Object):void {		
		var entry:Array = getEntry(key);
		if (entry==null) {
			var newEntry:Array = [key, value];
			var hash:int = hashObject(key);
			if (hashMap[hash]==null) hashMap[hash] = [];
			var entries:Object = hashMap[hash];
			entries.push( newEntry );
			pSize++;		
		} else {
			// replace value
			entry[1] = value;			
		}
	}
	
	// Some primes: Do I want to use them to hash an array?
	// 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139
	public static function hashObject(o:Object):int {
		if (o==null) return 541;		
        if (AS3_vs_AS2.isBoolean(o))	
			return o ? 523 : 521;		
        if (AS3_vs_AS2.isNumber(o))
        	return AS3_vs_AS2.convertToInt(o); // I multiply by 31 so that small fractions will have different hashes 
        var res:int;
	    if (AS3_vs_AS2.isString(o)) {
	    	var str:String = o.toString();
	    	var len:int = str.length;
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
	       	}
	       	return res;        	
        }
        
        res = 499;        	
        for (var z:String in o) {
        	res += hashObject(z)*hashObject(o[z]);
	    }
       	return res; 
	}
	public static function areEqual(o1:Object, o2:Object):Boolean {
		if (o1===o2) return true;
		if (o1==null || o2==null) return false;
		var t:String = typeof(o1);
		if (t!=typeof(o2)) 
			return false;
		if (AS3_vs_AS2.getClassName(o1)!=AS3_vs_AS2.getClassName(o2))
			return false;
			
		if (t=="object") {
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
}
}