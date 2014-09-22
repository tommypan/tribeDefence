package game.view.tower
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.event.BattleEvent;
	import game.model.vo.TowerVo;
	import game.view.monster.Monster;
	import game.view.scene.ui.battle.CicleMenu;
	import game.view.scene.ui.battle.Speed;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-2
	 */	
	public class BaseTower extends Sprite
	{
		protected var _tower:BitmapMovie;
		protected var _coolTime :int;
		protected var _parentX :Number=0;
		protected var _parentY :Number=0;
		public var _bindMonster :Monster;
		protected var _id :int;
		public var state :String; 
		protected var _towerVo:TowerVo;
		protected var _level :int;
		protected var div :Number = 1;
		
		public function BaseTower()
		{
			_level++;
			Speed.getInstance().addEventListener(BattleEvent.BATTLE_SPEED,modifyGameSpped);
			super();
		}
		
		protected function modifyGameSpped(e:BattleEvent):void
		{
			div = Number(e.data);
		}		
		
		public function get level():int
		{
			return _level;
		}

		public function get towerVo():TowerVo
		{
			return _towerVo;
		}

		/**
		 *初始化 
		 * 
		 */			
		public	function init():void
		{
			state = TowerState.IDEL;
		}
		
		/**
		 *准备射击 
		 * 
		 */		
		public function readyShoot(towerVo:TowerVo):void
		{
			_towerVo = towerVo;
			_coolTime = towerVo.coolTime;
			_id = towerVo.id;
			_parentX = this.parent.x;
			_parentY = this.parent.y
			_bindMonster = towerVo.bindMonster;
			state = TowerState.READY_SHOOT;
		}
		
		
		/**
		 *开始射击打击
		 * 
		 */		
		protected	function shoot():void
		{
			state = TowerState.SHOOT;
		}
		
		/**
		 *渲染射击动画 
		 * 
		 */		
		public function Render():void
		{
			
		}
		
		/**
		 *打击完毕，开启冷却 
		 * 
		 */		
		protected function startCool():void
		{
			state = TowerState.COOL;
			TimerManager.getInstance().add(_coolTime/(4*div),coolOff);
		}
		
		
		/**
		 *冷却结束 
		 * 
		 */		
		protected function coolOff():void
		{
			state = TowerState.IDEL;
			TimerManager.getInstance().remove(coolOff);
		}
		
		/**
		 *返回怪物與塔防之間的角度 
		 * @return 
		 * 
		 */		
		protected function getAngleOfTM():Number
		{
			
			var dx :Number=_bindMonster.x - this.parent.x;
			var dy :Number=_bindMonster.y - this.parent.y;
			//计算角度
			return Math.atan2(dy,dx)//todo 气死我了，atan2不是atan
		}
		
		public function dispose():void
		{
			TimerManager.getInstance().remove(coolOff);
		}
		
		public function upGradeTower():void
		{
		}
		
		
//		/**
//		 *返回怪物與塔防之間的角度 
//		 * @return 
//		 * 
//		 */		
//		protected function getDistance():Number
//		{
//			var dx :Number=_bindMonster1.x - this.parent.x;
//			var dy :Number=_bindMonster1.y - this.parent.y;
//			//计算角度
//			return Math.sqrt(dx*dx+dy*dy);
//		}
	}
}