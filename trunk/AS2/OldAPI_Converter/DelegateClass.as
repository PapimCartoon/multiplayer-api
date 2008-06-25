/**
* ...
* @author Default
* @version 0.1
*/

class DelegateClass {
	public static function create(target:Object, handler:Function):Function {
		var extraArgs:Array = arguments.slice(2);
		var delegate:Function;
		delegate = function() {
			var fullArgs:Array = arguments.concat(extraArgs); //, [delegate]
			return handler.apply(target, fullArgs);
		};
		return delegate;
	}
} 