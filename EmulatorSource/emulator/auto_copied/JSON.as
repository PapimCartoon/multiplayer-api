// IMPORTANT: THIS FILE IS A COPY OF THE FILE:
//    'google_api_svn/as3/come2play_as3/api/auto_copied/JSON.as'
// so DO ***NOT*** CHANGE THIS FILE!!!
// You should change the file in google_api_svn, 
// and then run the java program that automatically copies and changes the as file.
// We do not share the code because the flash goes crazy if it loads to SWFs files with classes of identical names and packages.
// So we changed the package name when we copied the directory 'auto_copied'
package emulator.auto_copied
{		

// This is a AUTOMATICALLY GENERATED! Do not change!

	// The initial source code was taken from JSON.org
	public final class JSON {
		public static var isDoingTesting:Boolean = false;
		public static var KEEP_NEWLINES:Boolean = true; // because of stack traces, I want to keep new lines
		public static var KEEP_TABS:Boolean = true;
		
        private var ch:String = '';
        private var at:int = 0;
        private var text:String;


// This is a AUTOMATICALLY GENERATED! Do not change!

	    public static function stringify(arg:Object):String{
			if (arg==null) return 'null';
			
	        var c:String, i:int, l:int, res:Array, v:String;
		    
	        if (AS3_vs_AS2.isNumber(arg) || AS3_vs_AS2.isBoolean(arg))
	        	return ''+arg; 	 
	        if (AS3_vs_AS2.isArray(arg)) {
	        	res = [];
	       		for (i = 0; i < arg.length; ++i) {

// This is a AUTOMATICALLY GENERATED! Do not change!

                    v = stringify(arg[i]);
                    res.push(v);
                }
                return '[' + res.join(",") + ']';
         	}
	        if (AS3_vs_AS2.isString(arg)) {
	        	 
	        	res = [];      
	            l = arg.length;
	            for (i = 0; i < l; i += 1) {

// This is a AUTOMATICALLY GENERATED! Do not change!

	                c = arg.charAt(i);
	                if (c >= ' ') {
	                    if (c == '\\' || c == '"') {
	                        res.push('\\');
	                    }
	                    res.push(c);
	                } else {
	                    switch (c) {
	                        case '\b':
	                            res.push('\\b');

// This is a AUTOMATICALLY GENERATED! Do not change!

	                            break;
	                        case '\f':
	                            res.push('\\f');
	                            break;
	                        case '\n':
	                            res.push(KEEP_NEWLINES ? '\n' : '\\n');
	                            break;
	                        case '\r':
	                            res.push(KEEP_NEWLINES ? '\r' : '\\r');
	                            break;

// This is a AUTOMATICALLY GENERATED! Do not change!

	                        case '\t':
	                            res.push(KEEP_NEWLINES ? '\t' : '\\t');
	                            break;
	                        default:
	                            var charCode:int = c.charCodeAt();
	                            res.push( '\\u00' + Math.floor(charCode / 16).toString(16) +
	                                (charCode % 16).toString(16) );
	                    }
	                }
	            }

// This is a AUTOMATICALLY GENERATED! Do not change!

	            return '"' + res.join("") + '"';
	        }
	        var argToString:String = "";
	        try {
	        	argToString = AS3_vs_AS2.specialToString(arg);
	        } catch(e:Error) {
	        	if (isDoingTesting) 
					throw e;
				argToString = "ERROR in toString() method of "+AS3_vs_AS2.getClassName(arg)+" err="+AS3_vs_AS2.error2String(e);
	        }

// This is a AUTOMATICALLY GENERATED! Do not change!

	        
	        if (SerializableClass.isToStringObject(argToString)) {	        	
	            return '{' + object2JSON(arg) + '}';
	        }
	        // I do not do stringify again, because Enum, Stake, User, and other classes, create toString that is parsable.
	        // E.g.,  { $Enum$ name:"NormalUser" , type:"come2play_as3.auto_generated::EnumSupervisor"}
	        return argToString;                 
	    }
	    public static function getSortedKeys(arg:Object):Array/*String*/ {
	    	var keys:Array = [];

// This is a AUTOMATICALLY GENERATED! Do not change!

        	for (var key:String in arg) 
        		keys.push(key);
        	keys.sort();
        	return keys;
	    }
	    private static function object2JSON(arg:Object):String {
	    	var res:Array = [];
        	// I want deterministic output, so sort the keys
        	var keys:Array = getSortedKeys(arg);
        	for each (var z:String in keys) {

// This is a AUTOMATICALLY GENERATED! Do not change!

                res.push( stringify(z) + ':' + stringify(arg[z]) );
            }
            return res.join(" , ");	    	
	    }
        private function white():void {
            while (ch) {
                if (ch <= ' ') {
                    this.next();
                } else if (ch == '/') {
                    switch (this.next()) {

// This is a AUTOMATICALLY GENERATED! Do not change!

                        case '/':
                            while (this.next() && ch != '\n' && ch != '\r') {}
                            break;
                        case '*':
                            this.next();
                            for (;;) {
                                if (ch) {
                                    if (ch == '*') {
                                        if (this.next() == '/') {
                                            next();

// This is a AUTOMATICALLY GENERATED! Do not change!

                                            break;
                                        }
                                    } else {
                                        this.next();
                                    }
                                } else {
                                    throwError("Unterminated comment");
                                }
                            }
                            break;

// This is a AUTOMATICALLY GENERATED! Do not change!

                        default:
                            throwError("Syntax error");
                    }
                } else {
                    break;
                }
            }
        }

        private function throwError(m:String):void {

// This is a AUTOMATICALLY GENERATED! Do not change!

            StaticFunctions.throwError('Error converting a string to a flash object: '+m + "\nError in position="+(at-1)+" containing character=' "+text.charAt(at-1)+" '\nThe entire string:\n'"+text+"'\nThe successfully parsed string:\n'"+text.substring(0,at-1)+"'\n"+"The string should be in a format that is a legal ActionScript3 literal (including Boolean, String, Array, int, or Object). For example, the following are legal strings:\n"+ 	"'I\\'m a legal, string!\\n'\n"+"['an','array',42, null, true, false, -42, 'unicode=\\u05D0']\n"+"{ an : 'object field', 'foo bar' : 'other field' }\n"   	);
        }
        private function next():String {
            ch = text.charAt(at);
            at += 1;
            return ch;
        }
        private function str():String {
            var i:int, s:String = '', t:int, u:int;
            var outer:Boolean = false;

// This is a AUTOMATICALLY GENERATED! Do not change!


            if (ch == '"' || ch == "'") {
				var firstApos:String = ch;
                while (this.next()) {
                    if (ch == firstApos) {
                        this.next();
                        return s;
                    } else if (ch == '\\') {
                        switch (this.next()) {
                        case 'b':

// This is a AUTOMATICALLY GENERATED! Do not change!

                            s += '\b';
                            break;
                        case 'f':
                            s += '\f';
                            break;
                        case 'n':
                            s += '\n';
                            break;
                        case 'r':
                            s += '\r';

// This is a AUTOMATICALLY GENERATED! Do not change!

                            break;
                        case 't':
                            s += '\t';
                            break;
                        case 'u':
                            u = 0;
                            for (i = 0; i < 4; i += 1) {
                                t = parseInt(this.next(), 16);
                                if (!isFinite(t)) {
                                    outer = true;

// This is a AUTOMATICALLY GENERATED! Do not change!

                                    break;
                                }
                                u = u * 16 + t;
                            }
                            if(outer) {
                                outer = false;
                                break;
                            }
                            s += String.fromCharCode(u);
                            break;

// This is a AUTOMATICALLY GENERATED! Do not change!

                        default:
                            s += ch;
                        }
                    } else {
                        s += ch;
                    }
                }
            } else {
				// if the user didn't use apostrophies ("...") , then the string goes until we find a special symbol: ' " , : [ ] {}   
				do {

// This is a AUTOMATICALLY GENERATED! Do not change!

					if (ch==',' || ch=='"' || ch=="'" || ch=='[' || ch=="]" || ch=='{' || ch=="}" || ch==':' || ch==' ' || ch=='\b' || ch=='\f' || ch=='\n' || ch=='\r' || ch=='\t') {
						break;
					} else
						s += ch;
				} while (this.next());
				if (s=='') throwError("Bad string: a string without \"...\" must be only alpha-numeric");
				return s; 
			}
            throwError("Bad string"); // cannot happen
            return "";

// This is a AUTOMATICALLY GENERATED! Do not change!

        }

        private function arr():Array {
            var a:Array = [];

            if (ch == '[') {
                this.next();
                this.white();
                if (ch == ']') {
                    this.next();

// This is a AUTOMATICALLY GENERATED! Do not change!

                    return a;
                }
                while (ch) {
                    a.push(this.value());
                    this.white();
                    if (ch == ']') {
                        this.next();
                        return a;
                    } else if (ch != ',') {
                        break;

// This is a AUTOMATICALLY GENERATED! Do not change!

                    }
                    this.next();
                    this.white();
                }
            }
            throwError("Bad array");
            return [];
        }

        private function obj():Object {

// This is a AUTOMATICALLY GENERATED! Do not change!

            var k:String, o:Object = {};

            if (ch == '{') {
                this.next();
                this.white();
                
				// E.g., trace( SerializableClass.deserialize( JSON.parse("{ $API_DoStoreState$ userEntries:[{ $UserEntry$ key:0 , value:{ row:0 , col:0} , isSecret:false}]}")) );
                if (ch == '$') {
                	// special syntax for SerializableClass to make toString more readable                	
                    this.next();

// This is a AUTOMATICALLY GENERATED! Do not change!

                    var classNameArr:Array = [];
                    while (ch!='$') {
                    	classNameArr.push(ch);
                    	this.next();                    	
                    }
                    var className:String = classNameArr.join("");
                    this.next();
                	this.white();
                    o[SerializableClass.CLASS_NAME_FIELD] = className;                    		
                }

// This is a AUTOMATICALLY GENERATED! Do not change!

                if (ch == '}') {
                    this.next();
                    return o;
                }
                while (ch) {
                    k = this.str();
                    this.white();
                    if (ch != ':') {
                        break;
                    }

// This is a AUTOMATICALLY GENERATED! Do not change!

                    this.next();
                    o[k] = this.value();
                    this.white();
                    if (ch == '}') {
                        this.next();
                        return o;
                    } else if (ch != ',') {
                        break;
                    }
                    this.next();

// This is a AUTOMATICALLY GENERATED! Do not change!

                    this.white();
                }
            }
            throwError("Bad object");
            return {};
        }

        private function num():Number {
            var n:String = '';
            var v:Number;

// This is a AUTOMATICALLY GENERATED! Do not change!


            if (ch == '-') {
                n = '-';
                this.next();
            }
            while (ch >= '0' && ch <= '9') {
                n += ch;
                this.next();
            }
            if (ch == '.') {

// This is a AUTOMATICALLY GENERATED! Do not change!

                n += '.';
                this.next();
                while (ch >= '0' && ch <= '9') {
                    n += ch;
                    this.next();
                }
            }
            if (ch == 'e' || ch == 'E') {
                n += ch;
                this.next();

// This is a AUTOMATICALLY GENERATED! Do not change!

                if (ch == '-' || ch == '+') {
                    n += ch;
                    this.next();
                }
                while (ch >= '0' && ch <= '9') {
                    n += ch;
                    this.next();
                }
            }
            v = Number(n);

// This is a AUTOMATICALLY GENERATED! Do not change!

			//trace("v="+v+" n="+n);
            if (!isFinite(v)) {
                throwError("Bad number");
            }
            return v;
        }

        private function word():Object {
			var oldAt:int = at;
            switch (ch) {

// This is a AUTOMATICALLY GENERATED! Do not change!

                case 't':
                    if (this.next() == 'r' && this.next() == 'u' &&
                            this.next() == 'e') {
                        this.next();
                        return true;
                    }
                    break;
                case 'f':
                    if (this.next() == 'a' && this.next() == 'l' &&
                            this.next() == 's' && this.next() == 'e') {

// This is a AUTOMATICALLY GENERATED! Do not change!

                        this.next();
                        return false;
                    }
                    break;
                case 'n':
                    if (this.next() == 'u' && this.next() == 'l' &&
                            this.next() == 'l') {
                        this.next();
                        return null;
                    }

// This is a AUTOMATICALLY GENERATED! Do not change!

                    break;
            }
			at = oldAt;
			return str();
            //throwError("Syntax error");
        }

        private function value():Object {
            this.white();
            switch (ch) {

// This is a AUTOMATICALLY GENERATED! Do not change!

                case '{':
                    return this.obj();
                case '[':
                    return this.arr();
                case '"':
                case "'":
                    return this.str();
                case '-':
                    return this.num();
                default:

// This is a AUTOMATICALLY GENERATED! Do not change!

                    return ch >= '0' && ch <= '9' ? this.num() : this.word();
            }
            return {};
        }
	    public function p_parse(_text:String):Object {
	        text = _text;
            at = 0;
	        ch = ' ';
	        var res:Object = value();
	        this.white();

// This is a AUTOMATICALLY GENERATED! Do not change!

	        if (at!=_text.length+1) throwError("Could not parse the entire string, string length="+_text.length+" and the parsing reached position="+(at-1));
	        return res;
	    }
	    public static function parse(_text:String):Object {
	    	var json:JSON = new JSON();
	    	return json.p_parse(_text);
	    }
	    

		public static function instanceToString(className:String, values:Object):String {			

// This is a AUTOMATICALLY GENERATED! Do not change!

			return "{ $"+className+"$ " + object2JSON(values) + "}"; // see parse
		}
	}
}
