package emulator {
	import flash.display.*; 

	public class Test extends MovieClip {
		private var txt:TextField;
		
		public function Test() {
			this.stop();
			
			txt = new TextField();
			txt.text = "!!!";
			this.addChild(txt);
			
			Security.allowDomain("*");
			
			if(ExternalInterface.available) {
				var obj:Object=ExternalInterface.call("parseObj","aaa:'aaa';bbb:111");
				txt.text = "";
				for (var prop in obj) { 
					txt.appendText("obj."+prop+" = "+obj[prop]+"\n"); 
				}
			}
			else {
			   txt.text="externalinterface unavailable";
			}
		}
	}
}