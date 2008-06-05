class JSON_AS2 {
	
	public static function doTest() {		
		doTestLine( "[ 1,2, -98, -03 , 7.03951716561533e+2, -1.70839354210796e-3, \n"+
			   "true, false, \n"+
			   "null, \n"+
			   "\"\", '', \n"+
			   "\"hi! I'm here!\", \"a\\\"ba\",\n"+
			   "\"newline=\\n\",\n"+
			   " \"unicode=\\u05D0\\u05D1\\u05d0 \",\n"+
			   " {a:2,b:[3,56], \"a_b_a\" : 9 ,  c : [] } , {}, {a4:null}, [], 'dsf' ]",
			[ 1,2, -98, -03 , 7.03951716561533e+2, -1.70839354210796e-3, 
			   true, false, 
			   null,
			   "", '', 
			   "hi! I'm here!", "a\"ba",
			   "newline=\n",
			   "unicode=\u05D0\u05D1\u05d0 ",
			   {a:2,b:[3,56], a_b_a : 9 ,  c : [] } , {}, {a4:null}, [], 'dsf' ]);
		doTestLine("player0-7 ", "player0-7");   
		doTestLine("'I\\'m a legal, string!\n'", 'I\'m a legal, string!\n');
		doTestLine("['an','array',42, null, true, false, -42, 'unicode=\u05D0']", ['an','array',42, null, true, false, -42, 'unicode=\u05D0']);
		doTestLine("{ an : 'object field', 'foo_bar' : 'other field' }", { an : 'object field', foo_bar : 'other field' });
		try {         
			doTestLine("player0-7 : sdsds", "player0-7");
			trace("BAD: should have thrown an error!");
		} catch(err:Error) {
			//trace("Error="+err);
		}    
	}
	public static function doTestLine(test:String, expectedRes:Object) {
		var o:Object = parseJSON(test);
		if (!deepCompare(o, expectedRes)) trace("BAD: objects are not equal! o="+o+" expectedRes="+expectedRes);
		//trace("test="+test+" Object = "+o+"\n\nstringify="+stringifyJSON(o));		
	}
	
	public static function deepCompare(o1, o2):Boolean {
		var t:String = typeof(o1);
		if (t!=typeof(o2)) {
			trace("BAD types: objects are not equal! o1="+o1+" o2="+o2);
			return false;
		}
		if (t=="object") {
			var x;
			for(x in o1)
				if (!deepCompare(o1[x], o2[x])) return false;
			for(x in o2)
				if (!deepCompare(o1[x], o2[x])) return false;
			return true;
		} else {
			if (o1==o2 || ''+o1==''+o2) // for double numbers, equality doesn't hold (o1=-1.70839354210796e-180 o2=-1.70839354210796e-180)
				return true
			else {
				trace("BAD: objects are not equal! o1="+o1+" o2="+o2);
				return false;
			}
		}
	}

	public static function parseJSON(_text:String):Object {
		var json:JSON_AS2 = new JSON_AS2();
		return json.parse(_text);
	}

    public static function stringifyJSON(arg):String {

        var c, i, l, s = '', v;

        switch (typeof arg) {
        case 'object':
            if (arg) {
                if (arg instanceof Array) {
                    for (i = 0; i < arg.length; ++i) {
                        v = stringifyJSON(arg[i]);
                        if (s) {
                            s += ',';
                        }
                        s += v;
                    }
                    return '[' + s + ']';
                } else if (typeof arg.toString != 'undefined') {
                    for (i in arg) {
                        v = arg[i];
                        if (typeof v != 'undefined' && typeof v != 'function') {
                            v = stringifyJSON(arg[i]);
                            if (s) {
                                s += ',';
                            }
                            s += stringifyJSON(i) + ':' + v;
                        }
                    }
                    return '{' + s + '}';
                }
            }
            return 'null';
        case 'number':
            return isFinite(arg) ? String(arg) : 'null';
        case 'string':
            l = arg.length;
            s = '"';
            for (i = 0; i < l; i += 1) {
                c = arg.charAt(i);
                if (c >= ' ') {
                    if (c == '\\' || c == '"') {
                        s += '\\';
                    }
                    s += c;
                } else {
                    switch (c) {
                        case '\b':
                            s += '\\b';
                            break;
                        case '\f':
                            s += '\\f';
                            break;
                        case '\n':
                            s += '\\n';
                            break;
                        case '\r':
                            s += '\\r';
                            break;
                        case '\t':
                            s += '\\t';
                            break;
                        default:
                            c = c.charCodeAt();
                            s += '\\u00' + Math.floor(c / 16).toString(16) +
                                (c % 16).toString(16);
                    }
                }
            }
            return s + '"';
        case 'boolean':
            return String(arg);
        default:
            return 'null';
        }
    }


	

		var ch:String = '';
		var at:Number = 0;
		var t,u;
		var text:String;
		function stringify(arg):String {
			return stringifyJSON(arg);
		}

        function white() {
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
                                    error("Unterminated comment");
                                }
                            }
                            break;
                        default:
                            this.error("Syntax error");
                    }
                } else {
                    break;
                }
            }
        }

        function error(m) {
            throw new Error('JSONError: '+m + " (error in position="+(at-1)+", containing character='"+text.charAt(at-1)+"',  problematic text='"+text.substring(0,at)+"'");
        }
        function next() {
            ch = text.charAt(at);
            at += 1;
            return ch;
        }
        function str() {
            var i, s = '', t, u;
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
				if (s=='') throw error("Bad string: a string without \"...\" must be only alpha-numeric");
				return s; 
			}
            this.error("Bad string"); // cannot happen
        }

        function arr() {
            var a = [];

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
            this.error("Bad array");
        }

        function obj() {
            var k, o = {};

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
            this.error("Bad object");
        }

        function num() {
            var n = '', v;

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
            if (!isFinite(v)) {
                this.error("Bad number");
            }
            return v;
        }

        function word() {
			var oldAt:Number = at;
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
            //this.error("Syntax error");
        }

        function value() {
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
    function parse(_text:String):Object {
        text = _text;
        at = 0;
        ch = ' ';
		var res:Object = value();
		this.white();
		if (at!=_text.length+1) throw error("Could not parse the entire string, string length="+_text.length+" and the parsing reached position="+(at-1));
		return res;
    }
}