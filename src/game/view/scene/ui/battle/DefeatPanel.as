package game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import qmang2d.utils.ClassManager;
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-6
	 */	
	public class DefeatPanel extends Sprite
	{
		private static var  _instance :DefeatPanel;
		
		private var mc:MovieClip;
		
		public var btnRestart :SimpleButton;
		public var btnQuit :SimpleButton;
		
		public function DefeatPanel(singlton:SingltonEnforcer)
		{
			if(!singlton)
			{
				throw new IllegalOperationError(" this is a singlton");
			}else{
				
				mc = ClassManager.createInstance("defeat") as MovieClip;
				addChild(mc);
				mc.x = 200;
				btnQuit = mc.btnQuit;
				btnRestart = mc.btnRestart;
			}
		}
		
		public static function getInstance():DefeatPanel
		{
			_instance ||= new DefeatPanel(new SingltonEnforcer());
			return _instance;
		}
		
		public function setTips(str:String):void
		{
			mc.tipTextField.text = str;
		}
	}
}
internal class SingltonEnforcer{}