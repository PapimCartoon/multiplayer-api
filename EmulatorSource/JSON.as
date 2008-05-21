package
{	
	/*
	Copyright (c) 2005 JSON.org
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The Software shall be used for Good, not Evil.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	*/
	
	/*
	Ported to Actionscript 2 May 2005 by Trannie Carter <tranniec@designvox.com>,
	wwww.designvox.com
	
	Updated 2007-03-30
	
	USAGE:
	            var json = new JSON();
	    try {
	        var o:Object = json.parse(jsonStr);
	        var s:String = json.stringify(obj);
	    } catch(ex) {
	        trace(ex.name + ":" + ex.message + ":" + ex.at + ":" + ex.text);
	    }
	
	*/
	public final class JSON {

        private var ch:String = '';
        private var at:int = 0;
        private var text:String;

		public static function doTest():void {
			// I don't support real numbers!
			doTestLine( "[ 1,2, -98, -03 , \n"+
                   "true, false, \n"+
                   "null, \n"+
                   "\"\", '', \n"+
                   "\"hi! I'm here!\", \"a\\\"ba\",\n"+
                   "\"newline=\\n\",\n"+
                   " \"unicode=\\u05D0\\u05D1\\u05d0 \",\n"+
                   " {a:2,\"b\":[3,56], \"a b a\" : 9 ,  c : [] } , {}, {4:null}, [], 'dsf' ]" );
           	doTestLine("player0-7 ");   
           	doTestLine("'I\\'m a legal, string!\n'");
			doTestLine("['an','array',42, null, true, false, -42, 'unicode=\u05D0']");
			doTestLine("{ an : 'object field', 'foo bar' : 'other field' }");
           	try {         
           		doTestLine("player0-7 : sdsds");
           	} catch(err:Error) {
           		trace("Error="+err);
           	}            
  		}
		public static function doTestLine(test:String):void {
			var o:Object = parse(test);
            trace("Object = "+o+"\n\nstringify="+stringify(o));		
		}
  		
                   
	    public static function stringify(arg:Object):String{
			if (arg==null) return 'null';
			if (arg is int) return ''+arg;
	        var c:String, i:int, l:int, s:String = '', v:String;
	
	        switch (typeof arg) {
	        case 'object':
                if (arg is Array) {
                    for (i = 0; i < arg.length; ++i) {
                        v = stringify(arg[i]);
                        if (s) {
                            s += ',';
                        }
                        s += v;
                    }
                    return '[' + s + ']';
                }else if (typeof arg.toString() != 'undefined') {
                    for (var z:String in arg) {
                        v = arg[z];
                        if (typeof v != 'undefined' && typeof v != 'function') {
                            v = stringify(arg[z]);
                            if (s) {
                                s += ',';
                            }
                            s += z + ':' + v;
                        }
                    }
                    return '{' + s + '}';
                }else{
					return "null";
				}
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
	                            var charCode:int = c.charCodeAt();
	                            s += '\\u00' + Math.floor(charCode / 16).toString(16) +
	                                (charCode % 16).toString(16);
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
                                    throw error("Unterminated comment");
                                }
                            }
                            break;
                        default:
                            throw error("Syntax error");
                    }
                } else {
                    break;
                }
            }
        }

        private function error(m:String):Error {
            throw new Error('Error converting a string to a flash object: '+m + "\nError in position="+(at-1)+" containing character=' "+text.charAt(at-1)+" '\nThe entire string:\n'"+text+"'\nThe successfully parsed string:\n'"+text.substring(0,at-1)+"'\n"+
            	"The string should be in a format that is a legal ActionScript3 literal (including Boolean, String, Array, int, or Object). For example, the following are legal strings:\n"+
            	"'I\\'m a legal, string!\\n'\n"+
            	"['an','array',42, null, true, false, -42, 'unicode=\\u05D0']\n"+
            	"{ an : 'object field', 'foo bar' : 'other field' }\n"
            	);
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
				// if the user didn't user "..." , then the string goes until we find a special symbol: ' " , : [ ] {}   
				do {
					if (ch==',' || ch=='"' || ch=="'" || ch=='[' || ch=="]" || ch=='{' || ch=="}" || ch==':' || ch==' ' || ch=='\b' || ch=='\f' || ch=='\n' || ch=='\r' || ch=='\t') {
						break;
					} else
						s += ch;
				} while (this.next());
				if (s=='') throw error("Bad string: a string without \"...\" must be only alpha-numeric");
				return s; 
			}
            throw error("Bad string"); // cannot happen
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
            throw error("Bad array");
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
            throw error("Bad object");
        }

        private function num():int {
            var n:String = '';
            var v:int;

            if (ch == '-') {
                n = '-';
                this.next();
            }
            while (ch >= '0' && ch <= '9') {
                n += ch;
                this.next();
            }
            /*if (ch == '.') {
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
            }*/
            v = int(n);
            if (!isFinite(v)) {
                throw error("Bad number");
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
            //throw error("Syntax error");
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
	    public function parse(_text:String):Object {
	        text = _text;
            at = 0;
	        ch = ' ';
	        var res:Object = value();
	        this.white();
	        if (at!=_text.length+1) throw error("Could not parse the entire string, string length="+_text.length+" and the parsing reached position="+(at-1));
	        return res;
	    }
	    public static function parse(_text:String):Object {
	    	var json:JSON = new JSON();
	    	return json.parse(_text);
	    }

	}
}