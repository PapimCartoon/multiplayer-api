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
	 * 				T.i18n("...")
	 * or
	 * 				T.i18n('...')
	 * or
	 * 				T.i18nReplace('...$key1$...$key2$...', {key1: ..., key2:...})
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
	 * 				T.i18n("bla $key$ foo", replacement)  // BAD! Because we check that the keys in replacement are identical to the $...$ in the string
	 * or like this:
	 * 		 		T.custom(key, 30)
	 * 

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * Handle left-to-right or right-to-left languages
	 * while creating long messages, like this:
	 * 				var t:T = new T();
	 * 				t.add(T.t("First part..."));
	 * 				t.add(someName1);
	 * 				t.add(T.t("Second part..."));
	 * 				t.add(someName2);
	 * 				return t.join();
	 */ 
	public final class T

// This is a AUTOMATICALLY GENERATED! Do not change!

	{
		private static var _dictionary:Object = null;
		private static var _custom:Object = null;
		public static function initI18n(dictionary:Object, custom:Object):void {
			StaticFunctions.assert(_dictionary==null, ["You called T.initI18n twice!"]);
			_dictionary = dictionary;
			_custom = custom;
		}
		
		// for customization, e.g., the frame-rate of the game.

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function custom(key:String, defaultValue:Object/*Type*/):Object/*Type*/ {
			var res:Object = _custom[key];
			return res==null ? defaultValue : res;
		}
		
		// for internationalization	
		// i18n stands for "i"(nternationalizatio)"n"	
		public static function i18n(str:String):String { //internationalization			
			var res:Object = _dictionary[str];
			return res==null ? str : res.toString();

// This is a AUTOMATICALLY GENERATED! Do not change!

		}		
		public static function i18nReplace(str:String, replacement:Object):String {
			var res:String = i18n(str);
			for (var key:String in replacement) {
				res = StaticFunctions.replaceAll(res, "$"+key+"$", ''+replacement[key]); 
			} 
			return res;			
		}
		
		

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static var isLeftToRight:Boolean = true;
		
		private var arr:Array;
		public function T() {
			arr = [];
		}
		public function add(str:String):void {
			if (isLeftToRight) 
				arr.push(str);
			else

// This is a AUTOMATICALLY GENERATED! Do not change!

				arr.unshift(str);
		}
		public function join():String {
			return arr.join("");
		}
	}
}
