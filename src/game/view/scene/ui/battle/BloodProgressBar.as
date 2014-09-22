package game.view.scene.ui.battle
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import qmang2d.utils.ClassManager;
	
	public class BloodProgressBar  extends Sprite
	{
		private var bloodMC:MovieClip;
		private var bloodMC1:MovieClip;
		
		private var green:MovieClip;
		private var bloodWidth:Number;
		public function BloodProgressBar()
		{
			bloodMC = ClassManager.createInstance("smallBlood") as MovieClip;
			addChild(bloodMC);
			green = bloodMC.green;
			bloodWidth = green.width;
			
		
		}
		
		/**
		 * 给一个百分比 
		 * @param percent
		 * 
		 */		
		public function update(percent:Number):void
		{
			if(percent < 0) percent = 0;
			green.width = percent*bloodWidth;
		}
		
		/**
		 *清除 
		 */		
		public function clear():void
		{
			removeChild(bloodMC);
		}
	}
}
