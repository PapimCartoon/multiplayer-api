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
	 */ 
import come2play_as2.api.auto_copied.*;
	class come2play_as2.api.auto_copied.T
	{
		public static var dictionary/*:Object*/ = {};
		// for internationalization and localization	
		// i18n stands for "i"(nternationalizatio)"n"	
		public static function i18n(str:String):String { //internationalization
			var res:String = dictionary[str];
			return res==null ? str : res;
		}
		
		public static function i18nReplace(str:String, replacement/*:Object*/):String {
			var res:String = i18n(str);
			for (var key:String in replacement) {
				res = StaticFunctions.replaceAll(res, "$"+key+"$", ''+replacement[key]); 
			} 
			return res;			
		}
		
		public static var isLeftToRight:Boolean = true;
		
		private var arr:Array;
		public function T() {
			arr = [];
		}
		public function add(str:String):Void {
			if (isLeftToRight) 
				arr.push(str);
			else
				arr.unshift(str);
		}
		public function join():String {
			return arr.join("");
		}
	}
