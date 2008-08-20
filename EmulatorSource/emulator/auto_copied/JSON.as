package emulator.auto_copied
{		
	/*
	I don't print XML nicely because it doesn't exists in AS2.
	*/
	/*
	Copyright (c) 2005 JSON.org
	*/
	
	public final class JSON {
		public static var isDoingTesting:Boolean = false;

        private var ch:String = '';
        private var at:int = 0;
        private var text:String;

	    public static function stringify(arg:Object):String{
			if (arg==null) return 'null';
			
	        var c:String, i:int, l:int, res:Array, v:String;
		    
	        if (AS3_vs_AS2.isNumber(arg) || AS3_vs_AS2.isBoolean(arg))
	        	return ''+arg; 	 
	        if (AS3_vs_AS2.isArray(arg)) {
	        	res = [];
	       		for (i = 0; i < arg.length; ++i) {
                    v = stringify(arg[i]);
                    res.push(v);
                }
                return '[' + res.join(",") + ']';
         	}
	        if (AS3_vs_AS2.isString(arg)) {
	        	 
	        	res = [];      
	            l = arg.length;
	            for (i = 0; i < l; i += 1) {
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
	                            break;
	                        case '\f':
	                            res.push('\\f');
	                            break;
	                        case '\n':
	                            res.push('\\n');
	                            break;
	                        case '\r':
	                            res.push('\\r');
	                            break;
	                        case '\t':
	                            res.push('\\t');
	                            break;
	                        default:
	                            var charCode:int = c.charCodeAt();
	                            res.push( '\\u00' + Math.floor(charCode / 16).toString(16) +
	                                (charCode % 16).toString(16) );
	                    }
	                }
	            }
	            return '"' + res.join("") + '"';
	        }
	        var argToString:String = arg.toString();
	        if (argToString=="[object Object]") {
	        	res = [];
	        	for (var z:String in arg) {
	                res.push( stringify(z) + ':' + stringify(arg[z]) );
	            }
	            return '{' + res.join(",") + '}';
	        }
	        return argToString;                
	    }
        private function white():void {
            while (ch) {
                if (ch <= ' ') {
                    this.next();
                } else if (ch == '/') {
                    switch (this.next()) {
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
                        default:
                            throwError("Syntax error");
                    }
                } else {
                    break;
                }
            }
        }

        private function throwError(m:String):void {
            LocalConnectionUser.throwError('Error converting a string to a flash object: '+m + "\nError in position="+(at-1)+" containing character=' "+text.charAt(at-1)+" '\nThe entire string:\n'"+text+"'\nThe successfully parsed string:\n'"+text.substring(0,at-1)+"'\n"+"The string should be in a format that is a legal ActionScript3 literal (including Boolean, String, Array, int, or Object). For example, the following are legal strings:\n"+ 	"'I\\'m a legal, string!\\n'\n"+"['an','array',42, null, true, false, -42, 'unicode=\\u05D0']\n"+"{ an : 'object field', 'foo bar' : 'other field' }\n"   	);
        }
        private function next():String {
            ch = text.charAt(at);
            at += 1;
            return ch;
        }
        private function str():String {
            var i:int, s:String = '', t:int, u:int;
            var outer:Boolean = false;

            if (ch == '"' || ch == "'") {
				var firstApos:String = ch;
                while (this.next()) {
                    if (ch == firstApos) {
                        this.next();
                        return s;
                    } else if (ch == '\\') {
                        switch (this.next()) {
                        case 'b':
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
        }

        private function arr():Array {
            var a:Array = [];

            if (ch == '[') {
                this.next();
                this.white();
                if (ch == ']') {
                    this.next();
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
                    }
                    this.next();
                    this.white();
                }
            }
            throwError("Bad array");
            return [];
        }

        private function obj():Object {
            var k:String, o:Object = {};

            if (ch == '{') {
                this.next();
                this.white();
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
                    this.white();
                }
            }
            throwError("Bad object");
            return {};
        }

        private function num():Number {
            var n:String = '';
            var v:Number;

            if (ch == '-') {
                n = '-';
                this.next();
            }
            while (ch >= '0' && ch <= '9') {
                n += ch;
                this.next();
            }
            if (ch == '.') {
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
			//trace("v="+v+" n="+n);
            if (!isFinite(v)) {
                throwError("Bad number");
            }
            return v;
        }

        private function word():Object {
			var oldAt:int = at;
            switch (ch) {
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
                    break;
            }
			// backtrack and parse as string
			at = oldAt;
			return str();
            //throwError("Syntax error");
        }

        private function value():Object {
            this.white();
            switch (ch) {
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
                    return ch >= '0' && ch <= '9' ? this.num() : this.word();
            }
        }
	    public function p_parse(_text:String):Object {
	        text = _text;
            at = 0;
	        ch = ' ';
	        var res:Object = value();
	        this.white();
	        if (at!=_text.length+1) throwError("Could not parse the entire string, string length="+_text.length+" and the parsing reached position="+(at-1));
	        return res;
	    }
	    public static function parse(_text:String):Object {
	    	var json:JSON = new JSON();
	    	return json.p_parse(_text);
	    }

	}
}
