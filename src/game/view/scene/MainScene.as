package game.view.scene
{
	import com.gs.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.event.SceneChangeEvent;
	
	import org.osmf.elements.BeaconElement;
	
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;

	public class MainScene extends Sprite
	{
		private var menu:MovieClip;
		private var beginBot:SimpleButton;
		
		public function MainScene()
		{
			
			menu = ClassManager.createInstance("mainMC") as MovieClip;
			addChild(menu);
			SoundManager.getInstance().playBgSound("bg4",1);
			beginBot = menu.botBegin;
			beginBot.addEventListener(MouseEvent.CLICK,onBegin);
			huanDong();
		}
		
		public function huanDong():void
		{
			beginBot.y = -400;
			TweenLite.to(beginBot,1,{y:400});
		}
		
		private function onBegin(event:MouseEvent):void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.TO_WORLD_SCENE));
		}
	}
}