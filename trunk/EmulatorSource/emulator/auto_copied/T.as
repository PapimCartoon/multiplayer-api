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
	 * Do NOT use the class like this:
	 * 				var str:String = "bla bla";
	 * 				T.i18n(str);  // BAD!
	 * or like this:
	 * 				T.i18n("bla "+i+" bla")  // BAD! use t.add to combine several strings
	 * or like this:

// This is a AUTOMATICALLY GENERATED! Do not change!

	 * 				T.i18n("bla $key$ foo", replacement)  // BAD! Because we check that the keys in replacement are identical to the $...$ in the string 
	 * 
	 * Handle left-to-right or right-to-left languages
	 * while creating long messages, like this:
	 * 				var t:T = new T();
	 * 				t.add(T.t("First part..."));
	 * 				t.add(someName1);
	 * 				t.add(T.t("Second part..."));
	 * 				t.add(someName2);
	 * 				return t.join();

// This is a AUTOMATICALLY GENERATED! Do not change!

	 */ 
	public final class T
	{
		public static var dictionary:Object = {};
		// for internationalization and localization	
		// i18n stands for "i"(nternationalizatio)"n"	
		public static function i18n(str:String):String { //internationalization
			var res:String = dictionary[str];
			return res==null ? str : res;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		public static function i18nReplace(str:String, replacement:Object):String {
			var res:String = i18n(str);
			for (var key:String in replacement) {
				res = StaticFunctions.replaceAll(res, "$"+key+"$", ''+replacement[key]); 
			} 
			return res;			
		}
		
		public static var isLeftToRight:Boolean = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

		
		private var arr:Array;
		public function T() {
			arr = [];
		}
		public function add(str:String):void {
			if (isLeftToRight) 
				arr.push(str);
			else
				arr.unshift(str);

// This is a AUTOMATICALLY GENERATED! Do not change!

		}
		public function join():String {
			return arr.join("");
		}
	}
}
