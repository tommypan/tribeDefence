package  game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	import qmang2d.pool.interfaces.IPool;
	import qmang2d.utils.ClassManager;
	
	/**
	 *风车 
	 * <p>采用引擎对象池处理技术，提升效率
	 * @author panhao
	 * 
	 */	
	public class Windmill extends Sprite implements IPool
	{
		private var windmill :MovieClip;
		private var isStop :Boolean;
		
		public function Windmill()
		{
			windmill = ClassManager.createDisplayObjectInstance("windmill") as MovieClip;
			addChild(windmill);
			windmill.buttonMode = true;
			windmill.mouseChildren = false;
			windmill.stop();
			
			windmill.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			isStop = !isStop;
			
			isStop ? windmill.stop(): windmill.play();
		}
		
		public function wakeUp():void
		{
			windmill.play();
		}
		
		public function sleep():void
		{
			windmill.stop();
		}
	}
}