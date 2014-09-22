package  game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import qmang2d.pool.interfaces.IPool;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;

	/**
	 *小绵羊 
	 * <p>考虑到每个业务逻辑都不一样，所以不对此进行抽象
	 * <p>采用引擎对象池处理技术，提升效率
	 * @author panhao
	 * 
	 */	
	public class Sheep1 extends Sprite implements IPool
	{
		private var sheep1 :MovieClip;
		
		public function Sheep1()
		{
			sheep1 = ClassManager.createDisplayObjectInstance("sheep1") as MovieClip;
			addChild(sheep1);
			//sheep1.buttonMode = true;
			sheep1.mouseChildren = false;
			sheep1.stop();
			
			sheep1.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
		    SoundManager.getInstance().playEffectSound("sheep",1);
		}
		
		public function wakeUp():void
		{
			sheep1.play();
		}
		
		public function sleep():void
		{
			sheep1.stop();
		}
		
		
	}
}