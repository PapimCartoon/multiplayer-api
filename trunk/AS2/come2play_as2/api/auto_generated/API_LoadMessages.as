//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*;
	import come2play_as2.api.auto_copied.*;
	import come2play_as2.api.auto_generated.*;

import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.API_LoadMessages  {
		public static function useAll():Void {
			new API_DoFinishedCallback().register();
			new API_DoRegisterOnServer().register();
			new API_DoTrace().register();
			new API_GotKeyboardEvent().register();

// This is a AUTOMATICALLY GENERATED! Do not change!

			new API_GotCustomInfo().register();
			new API_GotUserInfo().register();
			new API_GotUserDisconnected().register();
			new API_GotMyUserId().register();
			new API_GotMatchStarted().register();
			new API_GotMatchEnded().register();
			new API_GotStateChanged().register();
			new API_DoStoreState().register();
			new API_DoAllStoreState().register();
			new API_DoAllEndMatch().register();

// This is a AUTOMATICALLY GENERATED! Do not change!

			new API_DoAllSetTurn().register();
			new API_DoAllRevealState().register();
			new API_DoAllShuffleState().register();
			new API_DoAllRequestRandomState().register();
			new API_DoAllFoundHacker().register();
			new API_DoAllRequestStateCalculation().register();
			new API_GotRequestStateCalculation().register();
			new API_DoAllStoreStateCalculation().register();
			new API_DoConnectedSetScore().register();
			new API_DoConnectedEndMatch().register();

// This is a AUTOMATICALLY GENERATED! Do not change!

			new PlayerMatchOver().register();
			new InfoEntry().register();
			new RevealEntry().register();
			new UserEntry().register();
			new ServerEntry().register();
			new API_Transaction().register();
		}
	}
