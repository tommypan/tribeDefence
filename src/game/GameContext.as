package game
{
	import flash.display.DisplayObjectContainer;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import game.controller.InitCommand;
	import game.model.ChapterConfigModel;
	import game.model.ChapterModel;
	import game.model.LineModel;
	import game.model.MonsterModel;
	import game.model.PlayerModel;
	import game.model.TowerModel;
	import game.view.events.ViewBus;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	import qmang2d.utils.StageProxy;
	
	public class GameContext extends Context
	{
		public function GameContext(contextView:DisplayObjectContainer, autoStartup:Boolean=true )
		{
			//只有当autoStartup为true，starup函数在内部才会执行，由于多态，导致此类中starup执行
			super(contextView,autoStartup) ;
			
			//外部的stage
			contextView.stage.scaleMode = StageScaleMode.NO_SCALE;
			contextView.stage.align = StageAlign.TOP_LEFT;
			contextView.stage.quality = StageQuality.MEDIUM;  
//			contextView.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRmd);
//			function onRmd(e:MouseEvent):void
//			{
//				
//			}
		}
		
		override public function startup():void
		{
			injectModel();
			
			regiestSinglton();
			
			//Context创建完成后，单机测试，直接开启资源加载界面
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, InitCommand, ContextEvent);
			
			super.startup();
		}
		
		private function regiestSinglton():void
		{
			StageProxy.registed(contextView.stage);
			
			ViewBus.registerInstance();
			
		}
		
		private function injectModel():void
		{
			injector.mapSingleton(PlayerModel);
			
			injector.mapSingleton(MonsterModel);
			
			injector.mapSingleton(TowerModel);
			
			injector.mapSingleton(ChapterConfigModel);
			
			injector.mapSingleton(LineModel);
			
			injector.mapSingleton(ChapterModel);
			
			
			//			injector.mapSingleton(SocketService);
			
		}	
		
	}
}