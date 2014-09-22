package game.view.mediator
{
	import game.event.SceneChangeEvent;
	import game.view.scene.MainScene;
	
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.Mediator;
	
	import qmang2d.protocol.SoundManager;
	
	public class MainSceneMediator extends Mediator
	{
		[Inject]
		public var menu:MainScene;
		private var count:int = 0;
		public function MainSceneMediator()
		{
			
		}
		override public function onRegister():void
		{
			addViewListener(SceneChangeEvent.TO_WORLD_SCENE,toWorld,SceneChangeEvent);
			
			addContextListener(SceneChangeEvent.BACK_MAIN_SCENE,toMain,SceneChangeEvent);
			
		}
		
		private function toMain(e:SceneChangeEvent):void
		{
			trace(menu.visible);
			menu.visible = true;
			SoundManager.getInstance().playBgSound("bg4",1);
			menu.huanDong();
		}
		private function toWorld(e:SceneChangeEvent):void
		{
			if(count <= 0){
				dispatch(new SceneChangeEvent(SceneChangeEvent.TO_WORLD_SCENE));
				menu.visible = false;
			}else{
				dispatch(new SceneChangeEvent(SceneChangeEvent.BACK_WORLD_SCENE));
			}
			count++;
		}
	}
}