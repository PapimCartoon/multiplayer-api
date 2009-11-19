package come2play_as3.Template
{
	import come2play_as3.Template.TemplateMain;
	
	import flash.display.MovieClip;
	/*
	Handles the game logic
	*/
	public class TemplateLogic
	{
		private var templateMainPointer:TemplateMain; // pointer to the template main class
		private var templateGraphic:TemplateGraphic;
		public function TemplateLogic(templateMainPointer:TemplateMain)
		{
			this.templateMainPointer = templateMainPointer;
			
			templateGraphic = new TemplateGraphic();
			templateMainPointer.addChild(templateGraphic);
		}
		

	}
}