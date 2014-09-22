package  game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import qmang2d.pool.interfaces.IPool;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	
	/** 
	 * 大绵羊
	 * <p>采用引擎对象池处理技术，提升效率
	 * @author panhao
	 * 
	 */	
	public class Sheep2 extends Sprite implements IPool
	{
		private var sheep2 :MovieClip;
		
		public function Sheep2()
		{
			sheep2 = ClassManager.createDisplayObjectInstance("sheep2") as MovieClip;
			addChild(sheep2);
			sheep2.buttonMode = true;
			sheep2.mouseChildren = false;
			sheep2.stop();
			
			sheep2.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			SoundManager.getInstance().playEffectSound("sheep",1);
		}
		
		public function wakeUp():void
		{
			sheep2.play();
		}
		
		public function sleep():void
		{
			sheep2.stop();
		}
	}
}