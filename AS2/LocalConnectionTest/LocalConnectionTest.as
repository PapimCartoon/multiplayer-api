class LocalConnectionTest extends ClientGameAPI {
	private var my_root:MovieClip;
	private var test_Arr:Array;
	public function LocalConnectionTest(my_root:MovieClip) {
		try{
			this.my_root = my_root;
			test_Arr = getNumberArr();
			traceMsg("test_Arr="+test_Arr);
			super(my_root);
			do_register_on_server();
		}catch (err:Error) {
			traceMsg(err.toString());
		}
	}
	public function got_my_user_id(user_id:Number):Void {
		do_send_message([user_id], test_Arr);
	}
	public function got_message(user_id:Number, value:Object):Void {
		traceMsg("got_message="+value);
		for (var i:Number=0; i<test_Arr.length; i++) {
			var val:Number = test_Arr[i];
			var val2:Number = value[i];
			if (val!=val2) {
				traceMsg("Found different values, val="+val+" val2="+val2);
				return;
			}
		}			
	}
		
	public function traceMsg(msg:String):Void {
		my_root.traceMsg.text += msg + "\n";
	}
	
	public static function getNumberArr():Array {
		var res:Array = [];
		for (var i:Number=0; i<4; i++) {
			var num:Number = Math.random()-0.5;
			while (num!=0 && num!=Number.NEGATIVE_INFINITY && num!=Number.POSITIVE_INFINITY && num!=Number.MAX_VALUE && num!=Number.MIN_VALUE) {					
				res.push(num);
				num = i<2 ? num/3.0 : num*3.0;
			}
		}
		return res; 
	}
}