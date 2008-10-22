package come2play_as3.Template
{
	import come2play_as3.api.auto_copied.SerializableClass;
	/*
	this is an example of a class you might send throgh the server
	notice that the class:
	 
	has to be a public class
	must not have a constructor
	and must extend SerializableClass
	*/
	public class SomeClass extends SerializableClass
	{
		/*
		all the variables should be public
		*/
		public var name:String;
		public var hp:int;
		public function SomeClass()
		{
			super("SomeClass");
		}
		
		static public function create(name:String,hp:int):SomeClass
		{
			/*
			we suggest to use a static create function instead of the missing constructor
			to allow you yo easely build instances of this class
			and to avoid mistakes caused by forgetfullness		
			*/
			var res:SomeClass = new SomeClass()
			res.hp = hp;
			res.name = name;
			return res;
		}
	}
}