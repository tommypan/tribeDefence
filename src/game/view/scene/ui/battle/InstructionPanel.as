package game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import qmang2d.utils.ClassManager;

	public class InstructionPanel extends Sprite
	{
		private var instraction:MovieClip;
		public var skip:SimpleButton;
		private var next:SimpleButton;
		public var gotIt:SimpleButton;
		
		public function InstructionPanel()
		{
			instraction = ClassManager.createInstance("Default") as MovieClip;
			addChild(instraction);
			
			skip = instraction.btnSkip;
			next = instraction.btnNext;
			gotIt = instraction.btnClose;
		}
		
		public function close():void
		{
			this.visible = false;
			instraction.gotoAndStop(1);
			next.removeEventListener(MouseEvent.CLICK,onNext);
		}
		
		protected function onNext(event:MouseEvent):void
		{
			instraction.play();
		}
		
		public function init():void
		{
			this.visible = true;
			instraction.play();
			next.addEventListener(MouseEvent.CLICK,onNext);
		}
	}
}