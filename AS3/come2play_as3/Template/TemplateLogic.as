package AS3.come2play_as3.Template
{
	import come2play_as3.Template.TemplateMain;
	
	import flash.display.MovieClip;
	/*
	Handles the game logic
	*/
	public class TemplateLogic
	{
		private var graphic:MovieClip;
		private var templateMainPointer:TemplateMain; // pointer to the template main class
		private var templateGraphic:TemplateGraphic;
		public function TemplateLogic(graphic:MovieClip,templateMainPointer:TemplateMain)
		{
			this.graphic = graphic;
			this.templateMainPointer = templateMainPointer;
			
			templateGraphic = new TemplateGraphic();
			graphic.addChild(templateGraphic);
		}
		

	}
}