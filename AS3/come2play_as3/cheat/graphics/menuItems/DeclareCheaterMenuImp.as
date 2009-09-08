package come2play_as3.cheat.graphics.menuItems
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.cheat.graphics.WrapButton;
	
	public class DeclareCheaterMenuImp extends DeclareCheaterMenu
	{
		public var trustButtonImp:WrapButton
		public var doNotTrustButtonImp:WrapButton
		public function DeclareCheaterMenuImp()
		{
			trustButtonImp = new WrapButton(trustButton,T.i18n("Trust"))
			doNotTrustButtonImp = new WrapButton(doNotTrustButton,T.i18n("Call cheater"))
		}
		
	}
}