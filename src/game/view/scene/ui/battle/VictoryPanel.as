package game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import qmang2d.utils.ClassManager;
	
	
	/**
	 * 胜利面板
	 * @author panhao
	 * @date 2013-8-6
	 */	
	public class VictoryPanel extends Sprite
	{
		private static var  _instance :VictoryPanel;
		
		private var mc:MovieClip;
		
		public var btnContinue :SimpleButton;
		
		public var btnRestart :SimpleButton;
		
		public function VictoryPanel(singlton:SingltonEnforcer)
		{
			if(!singlton)
			{
				throw new IllegalOperationError(" this is a singlton");
			}else{
				
				mc = ClassManager.createInstance("victory") as MovieClip;
				addChild(mc);
				mc.x = 200;
				btnContinue = mc.btnContinue;
				btnRestart = mc.btnRestart;
			}
		}
		
		public static function getInstance():VictoryPanel
		{
			_instance ||= new VictoryPanel(new SingltonEnforcer());
			return _instance;
		}
		
		public function play():void
		{
			mc.play();
		}
		
		
		/**
		 *得到一颗星星 
		 * 
		 */		
		public function getOneStar():void
		{
			mc.star1.visible= false;
			mc.star2.visible= true;
			mc.star3.visible= false;
		}
		
		/**
		 *得到两颗星星 
		 * 
		 */
		public function getTwoStar():void
		{
			mc.star1.visible= true;
			mc.star2.visible= false;
			mc.star3.visible= true;
		}
		
		/**
		 *得到三颗星星 
		 * 
		 */
		public function getThreeStar():void
		{
			mc.star1.visible= true;
			mc.star2.visible= true;
			mc.star3.visible= true;
		}
	}
}
internal class SingltonEnforcer{}