package come2play_as3.dominoGame.serverClasses
{
	import come2play_as3.dominoGame.serverClasses.DominoPass;

	public class DominoComputerPass extends DominoPass
	{
		static public const DOMINO_COMPUTER_PASS:String = "DominoComputerPass"
		static public function create():DominoComputerPass{
			return new DominoComputerPass()
		}
		
	}
}