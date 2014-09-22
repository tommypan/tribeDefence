package game.controller
{
	import game.view.mediator.MainSceneMediator;
	import game.view.scene.MainScene;
	
	import org.robotlegs.mvcs.Command;

	public class AddMainCommand extends Command
	{
		public function AddMainCommand()
		{
		}
		
		override public function execute():void
		{
			trace("进入游戏菜单选择界面");
			mediatorMap.mapView(MainScene,MainSceneMediator);
			//开始页面
			var menu:MainScene = new MainScene();
			contextView.addChild(menu);
			
			
		}
	}
}