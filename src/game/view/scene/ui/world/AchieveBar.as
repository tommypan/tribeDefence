package game.view.scene.ui.world
{
	import com.gs.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;

	/**
	 * 成就面板
	 * @author Star
	 * 
	 */
	public class AchieveBar extends Sprite
	{
		private var achieve:MovieClip;
		private var close:SimpleButton;
		public function AchieveBar()
		{
			achieve = ClassManager.createInstance("achieve") as MovieClip;
			addChild(achieve);
			close = achieve.butClose;
			close.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
			TweenLite.to(this,0.3,{y:-500});
		}
		public function huanDong():void
		{
			this.y = -200;
			TweenLite.to(this,0.3,{y:180});
		}
	}
}