import come2play_as2.api.*;

	
import come2play_as2.util.*;
class come2play_as2.util.Util
{
	public static function init(graphics:MovieClip):Void {
		graphics.stop();
		var parameters:Object = AS3_vs_AS2.getLoaderInfoParameters(graphics);
		if (parameters["apiType"]==null) {
			// so we can do local testing (inside the flash 
			new SinglePlayerEmulator(graphics);
		}
	}

}
