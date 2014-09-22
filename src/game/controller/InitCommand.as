package game.controller
{
	import flash.utils.setTimeout;
	
	import game.event.SceneChangeEvent;
	import game.view.mediator.InitSceneMediator;
	import game.view.scene.InitScene;
	
	import org.robotlegs.mvcs.Command;
	
	public class InitCommand extends Command
	{
		public function InitCommand()
		{
		}
		
		override public function execute():void
		{
			trace("初始化开始");
			addlistener();
			
			//setTimeout(addlistener,1000);
			mediatorMap.mapView(InitScene, InitSceneMediator);
			
			contextView.addChild(new InitScene());
			
		}
		
		private function addlistener():void
		{
			commandMap.mapEvent(SceneChangeEvent.TO_MIAN_SCENE,AddMainCommand,SceneChangeEvent);
			
			commandMap.mapEvent(SceneChangeEvent.TO_WORLD_SCENE,AddWorldCommand,SceneChangeEvent);
			
			commandMap.mapEvent(SceneChangeEvent.TO_BATTLE_SCENE,AddBattleCommand,SceneChangeEvent);
			
		}
	}
}