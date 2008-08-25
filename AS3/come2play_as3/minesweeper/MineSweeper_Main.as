package come2play_as3.minesweeper
{
import come2play_as3.api.*;
import come2play_as3.api.auto_copied.*;
import come2play_as3.api.auto_generated.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
	public class MineSweeper_Main extends ClientGameAPI
	{
		private static var mineAmount:int=20;
		private static var boardSize:int=25;
		private var mineSweeper_Logic:MineSweeper_Logic;
	/**
	 * Written by: Ofir Vainshtein (ofirvins@yahoo.com)
 	**/
		public function MineSweeper_Main(graphics:MovieClip)
		{
			super(graphics);
			doRegisterOnServer();
		}

		override public function gotCustomInfo(infoEntries:Array):void
		{
			
		}
		override public function gotMyUserId(myUserId:int):void
		{
			
		}
		override public function gotUserInfo(userId:int, entries:Array/*InfoEntry*/):void 
		{
			
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
		{
			
		}
		override public function gotMatchEnded(finishedPlayerIds:Array/*int*/):void 
		{
			
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			
		}
		override public function gotKeyboardEvent(isKeyDown:Boolean, charCode:int, keyCode:int, keyLocation:int, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean):void
		{
			
		}
	}
}