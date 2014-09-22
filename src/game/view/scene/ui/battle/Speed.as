package game.view.scene.ui.battle
{
	import com.gs.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	
	import game.event.BattleEvent;
	
	import qmang2d.utils.ClassManager;
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-16
	 */	
	public class Speed extends Sprite
	{
		private static var  _instance :Speed;
		
		private var _main :MovieClip;
		private var _bot1 :SimpleButton;
		private var _bot2 :SimpleButton;
		private var _bot3 :SimpleButton;
		private var _bot4 :SimpleButton;
		
		public function Speed(singlton:SingltonEnforcer)
		{
			if(!singlton)
			{
				throw new IllegalOperationError(" this is a singlton");
			}else{
				
				_main = ClassManager.createDisplayObjectInstance("quickly") as MovieClip;
				addChild(_main);
				
				_bot1 = _main.bot1;
				_bot2 = _main.bot2;
				_bot3 = _main.bot3;
				_bot4 = _main.bot4;
				
				_bot1.addEventListener(MouseEvent.CLICK,onCLick);
			}
			
			
		}
		
		public static function getInstance():Speed
		{
			_instance ||= new Speed(new SingltonEnforcer());
			return _instance;
		}
		
		public function init():void
		{
			if(!_main.contains(_bot1))
			{
				clickCommom();
			}
		}
		
		
		public function onCLick(e:MouseEvent):void
		{
			_main.removeChild(_bot1);
			
			TweenLite.to(_bot2,.1,{y:0});
			TweenLite.to(_bot3,.1,{y:0});
			TweenLite.to(_bot4,.1,{y:0});
			
			_bot2.addEventListener(MouseEvent.CLICK,onClickNormal);
			_bot3.addEventListener(MouseEvent.CLICK,onClickQuick);
			_bot4.addEventListener(MouseEvent.CLICK,onClickTop);
		}
		
		protected function onClickTop(event:MouseEvent):void
		{
			dispatchEvent(new BattleEvent(BattleEvent.BATTLE_SPEED,1.75));
			clickCommom();
		}
		
		protected function onClickQuick(event:MouseEvent):void
		{
			dispatchEvent(new BattleEvent(BattleEvent.BATTLE_SPEED,1.5));
			clickCommom();
		}
		
		protected function onClickNormal(event:MouseEvent):void
		{
			dispatchEvent(new BattleEvent(BattleEvent.BATTLE_SPEED,1));
			clickCommom();
		}
		
		private function clickCommom():void
		{
			TweenLite.to(_bot2,.1,{y:-33});
			TweenLite.to(_bot3,.1,{y:-33});
			TweenLite.to(_bot4,.1,{y:-33,onComplete:addBot1});
		}
		
		private function addBot1():void
		{
			_main.addChild(_bot1);
		}
		
	}
}
internal class SingltonEnforcer{}