package game.view.mediator
{
	
	import flash.display.Scene;
	
	import game.event.BattleEvent;
	import game.event.SceneChangeEvent;
	import game.view.scene.WorldScene;
	
	import org.robotlegs.mvcs.Mediator;
	
	import qmang2d.protocol.SoundManager;

	public class WorldSceneMediater extends Mediator
	{
		[Inject]
		public var world:WorldScene;
		
		public function WorldSceneMediater()
		{
			
		}
		override public function onRegister():void
		{
			addViewListener(SceneChangeEvent.BACK_MAIN_SCENE,toMain,SceneChangeEvent);
			addContextListener(SceneChangeEvent.BACK_WORLD_SCENE,toWorld,SceneChangeEvent);
			addContextListener(BattleEvent.WIN_STARS,onChangeStar,BattleEvent);
			addViewListener(SceneChangeEvent.TO_BATTLE_SCENE,toBattle,SceneChangeEvent);
		}
		
		private function onChangeStar(e:BattleEvent):void
		{
			var nowStar:int = world.starNum + e.data;
			world.starTxt.text = nowStar+"/99";
			world.lvUpBar.starAll = nowStar;
			world.lvUpBar.changeStar(nowStar);
		}
		
		private function toBattle(e:SceneChangeEvent):void
		{
			dispatch(new SceneChangeEvent(SceneChangeEvent.TO_BATTLE_SCENE,e.data.id));
			world.visible = false;
		}
		
		private function toWorld(e:SceneChangeEvent):void
		{
			world.visible = true;
			SoundManager.getInstance().playBgSound("bg5",1);
			world.huanDong();
			
		}
		private function toMain(e:SceneChangeEvent):void
		{
			trace("派发");
			dispatch(new SceneChangeEvent(SceneChangeEvent.BACK_MAIN_SCENE));
			world.visible = false;
			
		}
	}
}