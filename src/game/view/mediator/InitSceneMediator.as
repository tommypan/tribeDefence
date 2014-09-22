package game.view.mediator
{
	import flash.events.Event;
	
	import game.event.SceneChangeEvent;
	import game.view.scene.InitScene;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class InitSceneMediator extends Mediator
	{
		[Inject]
		public var initScene :InitScene;
		
		public function InitSceneMediator()
		{
		}
		
		override public function onRegister():void
		{
			
//			addViewListener(SceneChangeEvent.TO_LOGIN_SCENE, onSendEnterGame);
			addViewListener(SceneChangeEvent.TO_MIAN_SCENE,toMain,SceneChangeEvent);
		}
		
//		override public function onRemove():void
//		{
//			removeViewListener(SceneChangeEvent.TO_LOGIN_SCENE, onSendEnterGame, Event);
//		}
		private function toMain(e:SceneChangeEvent):void
		{
//			trace("login",login);
			contextView.removeChildAt(0);
			dispatch(new SceneChangeEvent(SceneChangeEvent.TO_MIAN_SCENE));
		}
//		private function onSendEnterGame(e:Event):void
//		{
//			dispatch(e);
//		}
	}
}