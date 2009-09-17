package come2play_as3.cheat.graphics
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.API_Message;
	
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class GameMessage extends Sprite
	{
		private var cheater:Cheater = new Cheater()
		private var notCheater:NotCheater = new NotCheater()
		private var cardsPic:CardsPic = new CardsPic()
		
		private var gameMessage:Message
		
		private var cheaterAlarm:CheaterAlarm
		private var heartBeat:HeartBeat
		private var magicZing:MagicZing
		private var playerSafe:PlayerSafe
		

		private var heartBeatSoundChannel:SoundChannel;
		private var backgroundSoundChannel:SoundChannel
		
		public function GameMessage(backgroundSoundChannel:SoundChannel)
		{
			this.backgroundSoundChannel = backgroundSoundChannel;
			cheaterAlarm = new CheaterAlarm()
			heartBeat = new HeartBeat()
			magicZing = new MagicZing()
			playerSafe = new PlayerSafe()			
			gameMessage = new Message()
			gameMessage.messageText.wordWrap = true;
			gameMessage.x = 150
			gameMessage.y = 180
			cardsPic.x = 13
			cardsPic.y = 8
			notCheater.x = cheater.x = 13
			notCheater.y = cheater.y = 8
			notCheater.scaleX = cheater.scaleX = 0.8
			notCheater.scaleY = cheater.scaleY = 0.8
			addChild(gameMessage);
			
		}
		private function removeGraphics():void{
			closeMessage()
			if(gameMessage.contains(cheater))	gameMessage.removeChild(cheater);
			if(gameMessage.contains(notCheater))	gameMessage.removeChild(notCheater);
			if(gameMessage.contains(cardsPic))	gameMessage.removeChild(cardsPic);
		}
		
		public function chooseCard():void{
			removeGraphics()
			gameMessage.messageText.text = T.i18n("Choose a card to place");
			gameMessage.addChild(cardsPic);
		}
		public function amIRight(isRight:Boolean,isBiengCalled:Boolean,id:int):void{
			removeGraphics()
			var userName:String = getUserName(id);
			if(isBiengCalled){
				if(isRight){
					cheaterAlarm.play()
					if(id == 0)
						gameMessage.messageText.text = T.i18nReplace("$userName$ got us there mate !",{userName:userName});
					
					gameMessage.addChild(cheater);
				}else{
					magicZing.play()
					
					gameMessage.messageText.text = T.i18nReplace("We got $userName$, Excellent !",{userName:userName});
					gameMessage.addChild(notCheater);
				}
			}else{
				if(isRight){
					magicZing.play()
					gameMessage.messageText.text = T.i18nReplace("Busted! $userName$ Cheated!",{userName:userName});
					gameMessage.addChild(cheater);
				}else{
					cheaterAlarm.play()
					gameMessage.messageText.text = T.i18nReplace("$userName$ is as innocent as a lamb, tough luck",{userName:userName});
					gameMessage.addChild(notCheater);
				}
			}
		}
		static public function getUserName(id:int):String{
			return (T.getUserValue(id,API_Message.USER_INFO_KEY_name,"our opponent") as String).substr(0,8);
		}
		public function willCallBluff(isBluff:Boolean,id:int):void{
			removeGraphics()
			var userName:String = getUserName(id)
			if(isBluff){
				if(backgroundSoundChannel.soundTransform.volume == 0.3){
					backgroundSoundChannel.soundTransform = new SoundTransform(0.1)
				}
				heartBeatSoundChannel = heartBeat.play(0,1000);
				gameMessage.messageText.text = T.i18nReplace("Will $userName$ call our bluff ?!",{userName:userName});
				gameMessage.addChild(cheater);
			}else{
				gameMessage.messageText.text = T.i18nReplace("Will $userName$ think we bluffed ?!",{userName:userName});
				gameMessage.addChild(notCheater);
			}
		}
		public function bluffSuccess():void{
			removeGraphics()
			playerSafe.play()
			gameMessage.messageText.text = T.i18n("SAFE !!!");
			gameMessage.addChild(cheater);
		}
		
		
		public function closeMessage():void{
			if(heartBeatSoundChannel!=null){	
				heartBeatSoundChannel.stop()
				if(backgroundSoundChannel.soundTransform.volume == 0.1){
					backgroundSoundChannel.soundTransform = new SoundTransform(0.3)
				}
			
			}
		}

		
	}
}