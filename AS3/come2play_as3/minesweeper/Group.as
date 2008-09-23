package come2play_as3.minesweeper
{

	public class Group {
		public var group:Group = null;
		public var size:int = 1;
		public static var groupId:int = 0;
		public var id:int = groupId++;
		
		public function findRoot():Group { // find
			var p:Group = this;
			if (p.group!=null) {
				while (p.group!=null) p = p.group;
				this.group = p;
			}
			return p;
		}
		public function union(other:Group):void {
			var otherRoot:Group = other.findRoot();
			var myRoot:Group = findRoot();
			var otherSize:int = otherRoot.size;
			
			if (myRoot!=otherRoot) {
				var isMeSmaller:Boolean = size<otherSize;
				var smallerGroup:Group = isMeSmaller ? myRoot : otherRoot;
				var biggerGroup:Group = isMeSmaller ? otherRoot : myRoot;
				smallerGroup.group = biggerGroup;
				biggerGroup.size += smallerGroup.size;
			}
		}
	}
}