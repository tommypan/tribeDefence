package game.view.scene
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-17
	 */	
	public class FinalScene extends Sprite
	{
		private static var  _instance :FinalScene;

		private var dramaMc:MovieClip;
		
		public function FinalScene()
		{
			LoaderManager.getInstance().getModualSwf("assets/finalDrama.swf");
			LoaderManager.getInstance().getModualSwf("assets/finalSound.swf",callBack);
		}
		
		public static function getInstance():FinalScene
		{
			_instance ||= new FinalScene();
			return _instance;
		}
		
		private function callBack():void
		{
			dramaMc = ClassManager.createDisplayObjectInstance("finalDrama") as MovieClip;
			addChild(dramaMc);
			
			SoundManager.getInstance().playBgSound("finalSound",1);
			
			TimerManager.getInstance().add(36000,removeIt);
		}
		
		private function removeIt():void
		{
			dramaMc.stop();
			
		}
	}
}
