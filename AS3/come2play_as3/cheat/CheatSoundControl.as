package come2play_as3.cheat
{
	public class CheatSoundControl
	{
		static private var clickSound:ClickSound = new ClickSound()
		static public function playClick():void{
			clickSound.play()
		}

	}
}