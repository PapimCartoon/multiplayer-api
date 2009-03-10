// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/T.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{		

// This is a AUTOMATICALLY GENERATED! Do not change!

	/**
	 * For Translations to other languages:
	 * The strings in your code should be passed to the translation function
	 * like this:
	 * 				T.i18n(". . .")
	 * or
	 * 				T.i18n('. . .')
	 * or
	 * 				T.i18nReplace('. . .$key1$. . .$key2$. . .', {key1: . . ., key2:. . .})
	 * 

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * We have a program that goes over the source files,
	 * finds all the above occurrences,
	 * and extracts them to an XML that is used for translation.
	 * 
	 * Similarly, you can use this class for customization points:
	 * 				T.custom("refresh room every X seconds", 30)
	 * By default the above code will return 30, 
	 * unless there is a different custom value.
	 *   
	 * 

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * Do NOT use the class like this:
	 * 				var str:String = "bla bla";
	 * 				T.i18n(str);  // BAD!
	 * or like this:
	 * 				T.i18n("bla "+i+" bla")  // BAD! use t.add to combine several strings
	 * or like this:
	 * 				T.i18n("bla $key$ foo", replacement)  // BAD! Because we check that the keys in replacement are identical to the $. . .$ in the string
	 * or like this:
	 * 		 		T.custom(key, 30)
	 * 

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * Handle left-to-right or right-to-left languages
	 * while creating long messages, like this:
	 * 				var t:T = new T();
	 * 				t.add(T.t("First part. . ."));
	 * 				t.add(someName1);
	 * 				t.add(T.t("Second part. . ."));
	 * 				t.add(someName2);
	 * 				return t.join();
	 */ 
	public final class T

// This is a AUTOMATICALLY GENERATED! Do not change!

	{
		private static var _dictionary:Object = {};
		private static var _custom:Object = {};
		private static var _usersInfo:Object = {};
		public static function initI18n(dictionary:Object, custom:Object):void {
			var key:String;
			for (key in dictionary)	_dictionary[key] = dictionary[key];			
			for (key in custom)	_custom[key] = custom[key];
		}
		static public function updateUser(userId:int, userObject:Object):void{

// This is a AUTOMATICALLY GENERATED! Do not change!

			var currentUser:Object = _usersInfo[userId];
			if(currentUser == null)
				_usersInfo[userId] = userObject;
			else{
				for(var str:String in userObject){
					currentUser[str] = userObject[str];
				}
			}
			
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		static public function getUserValue(userId:int,key:String,defaultValue:Object):Object{
			var userInfo:Object = _usersInfo[userId];
			if(userInfo == null)
				return defaultValue;
			var res:Object = userInfo[key];
			if(res == null)
				return defaultValue;
			isSameType(res,defaultValue);
			return res;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		// for customization, e.g., the frame-rate of the game.
		// If defaultValue is not null, then we require that the **type** of the return value
		// will be identical to the **type** of the defaultValue.		
		public static function getCustom():Object {
			return _custom;
		}
		public static function isSameType(res:Object,defaultValue:Object):void{
			if (defaultValue==null || res==null) return;
			var typeD:String = AS3_vs_AS2.getClassName(defaultValue);
			var typeR:String = AS3_vs_AS2.getClassName(res);

// This is a AUTOMATICALLY GENERATED! Do not change!

			StaticFunctions.assert(typeD==typeR, ["In T.custom and the T.getUserValue the type of defaultValue and the return value must be identical! DefaultValue=",defaultValue," type of DefaultValue=",typeD," result=",res," type of result=",typeR]); 
		}
		public static function custom(key:String, defaultValue:Object/*Type*/):Object/*Type*/ {
			var res:Object = _custom[key];
			if (res==null) return defaultValue;			
			// the type of defaultValue must be identical to res
			isSameType(res,defaultValue);
			return res; 
		}
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		// for internationalization	
		// i18n stands for "i"(nternationalizatio)"n"	
		public static function i18n(str:String):String { //internationalization			
			var res:Object = _dictionary[str];
			return res==null ? str : res.toString();
		}		
		public static function i18nReplace(str:String, replacement:Object):String {
			var res:String = i18n(str);
			for (var key:String in replacement) {
				res = StaticFunctions.replaceAll(res, "$"+key+"$", ''+replacement[key]); 

// This is a AUTOMATICALLY GENERATED! Do not change!

			} 
			return res;			
		}
		
		
		public static var isLeftToRight:Boolean = true;
		
		private var arr:Array;
		public function T() {
			arr = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public function add(str:String):void {
			if (isLeftToRight) 
				arr.push(str);
			else
				arr.unshift(str);
		}
		public function join():String {
			return arr.join("");
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
}
