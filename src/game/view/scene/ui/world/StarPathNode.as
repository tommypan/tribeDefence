package game.view.scene.ui.world
{
	import qmang2d.utils.ClassManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class StarPathNode extends Sprite
	{
		private var _starNode :MovieClip;
		private var _glow :GlowFilter;
		
		public function StarPathNode()
		{
			_starNode = ClassManager.createInstance("starNodeMc") as MovieClip;
			_starNode.gotoAndStop(2);
			_starNode.buttonMode = true;
			_starNode.mouseChildren = false;
			addChild(_starNode);
			
			_starNode.x = -37;
			_starNode.y = 10;
			_glow = new GlowFilter();
			_glow.color = 0xffff00;
			
			
			_starNode.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_starNode.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function onOut(event:MouseEvent):void
		{
			_starNode.filters = [];
		}
		
		private function onOver(event:MouseEvent):void
		{
			_starNode.filters = [_glow];
		}
		
	}
}