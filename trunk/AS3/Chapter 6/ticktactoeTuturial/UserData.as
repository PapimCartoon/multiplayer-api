package ticktactoeTuturial
{
	public class UserData
	{
		public var avatarUrl:String = "";
		public var userId:int;
		/**
		*Creates a user avatar
		*
		*@param avatarUrl url of an avatar
		*@param userId id of the user the avatar is associated to
		*/
		public function UserData(avatarUrl:String,userId:int)
		{
			this.avatarUrl = avatarUrl;
			this.userId = userId;
		}

	}
}