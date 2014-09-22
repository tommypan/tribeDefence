package game.controller
{
	import game.event.SceneChangeEvent;
	import game.view.mediator.WorldSceneMediater;
	import game.view.scene.MainScene;
	import game.view.scene.WorldScene;
	
	import org.robotlegs.mvcs.Command;

	public class AddWorldCommand extends Command
	{
		public function AddWorldCommand()
		{
			
		}
		override public function execute():void
		{
			trace("进入游戏地图选择界面");
			mediatorMap.mapView(WorldScene,WorldSceneMediater);
			//开始页面
			var world:WorldScene = new WorldScene();
			contextView.addChild(world);
			
		}
	}
}