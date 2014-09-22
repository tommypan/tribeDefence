package game.view.tower
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import game.event.BattleEvent;
	import game.model.vo.TowerVo;
	import game.view.events.ViewBus;
	import game.view.monster.Monster;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.Bezier;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	
	/**
	 *大炮打击横向敌人不精确问题可以由提前量解决，可以算出怪物移动方向，准本好相应提前量 
	 * @author panhao
	 * 
	 */	
	public class CannonTower extends BaseTower
	{
		public var bullet:CannonBullet;
		private var bezier:Bezier;
		private var steps:uint;
		private var curStp:uint;
		//private var _fixedStp :uint;
		
		private var _controlPoint :Point;
		private var _startPoint :Point;
		private var _endPoint :Point;
		
		
		private var monsterX :Number;
		private var monsterY :Number;
		
		private var _checkHitNum :int;
		
		public function CannonTower()
		{
			super();
			
			createCannonTower(_level);
			
			bullet = new CannonBullet();
			LayerCollection.effectLayer.addChild(bullet);
		}
		
		private function createCannonTower(level_:int):void
		{
			var cannonMc :MovieClip = ClassManager.createDisplayObjectInstance("cannon"+level_) as MovieClip;
			_tower = LoaderManager.getInstance().changeMcToBitmapMovie(cannonMc,true,"cnnnon"+level_);
			addChild(_tower);
			_tower.y = -33;
			_tower.x = -5;
			
			_tower.gotoAndStop(1);
			
			_tower.mouseEnabled = true;
			_tower.buttonMode = true;
		}
		
		override public function upGradeTower():void
		{
			_level++;
			if(_level <= 2)
			{
				removeChild(_tower);
				_tower = null;
				
				createCannonTower(_level);
			}else if(_level == 3){
				removeChild(_tower);
				_tower = null;
				
				createCannonTower(_level);
				_tower.y -= 10;
			}else if(_level == 4){
				_tower.scaleX = _tower.scaleY = 1.05;
			}
			
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			_tower.stop();
			bullet.mc.stop();
			removeChild(_tower);
			LayerCollection.effectLayer.removeChild(bullet);
			
			//			_tower = null;
			//			_bullet = null;
		}
		
		
		/**
		 *初始化变量 
		 * 
		 */		
		override public function init():void
		{
			super.init();
			
			bezier = new Bezier();
			
		}
		
		override public function readyShoot(towerVo:TowerVo):void
		{
			super.readyShoot(towerVo);
			monsterX = _bindMonster.x;
			monsterY = _bindMonster.y;
			_tower.gotoAndPlay(2,false,2,13,shoot);
			_startPoint = new Point(20+_parentX,-70+_parentY);
		}
		
		
		/**
		 *大炮射击 
		 * 
		 */		
		override protected function shoot():void
		{
			SoundManager.getInstance().playEffectSound("sFightCannon1");
			_tower.gotoAndPlay(13,false,13,1);
			
			_controlPoint = new Point(( monsterX - (20+_parentX))/2+_parentX,-140+_parentY);
			_endPoint = new Point(monsterX,monsterY);
			
			
			bullet.updateXY();
			bullet.mc.gotoAndStop(1);
			bullet.visible = true;
			
			curStp = 0;
			steps  = bezier.init(_startPoint,_controlPoint,_endPoint,15);
			//trace("steps",steps);
			var endPonit :Point = _bindMonster.getNextPoint(steps);
			var controlPoint :Point = new Point((endPonit.x - (20+_parentX))/2+_parentX,-140+_parentY);
			steps  = bezier.init(_startPoint,controlPoint,endPonit,15);
			super.shoot();
		}
		
		override public function Render():void
		{
			
			if(curStp < steps)
			{
				var tmpArr:Array = bezier.getAnchorPoint(curStp);
				bullet.x =  tmpArr[0];
				bullet.y =  tmpArr[1];
				curStp ++;
				//要rotation是有问题的
			}else if(curStp == steps){
				SoundManager.getInstance().playEffectSound("sFightCannon2");
				bullet.mc.gotoAndPlay(2,false,2,12,checkHit);
				curStp ++;
			}
			
		}
		
		/**
		 *打击完毕，开启冷却 
		 * 
		 */		
		override protected function startCool():void
		{
			super.startCool();
			bullet.visible = false;
			
		}
		
		private function checkHit():void
		{
			ViewBus.instance.dispatchEvent(new BattleEvent(BattleEvent.ATTACK_SUCCESS,this));
			bullet.mc.gotoAndPlay(12,false,12,21,startCool);
		}		
		
		
	}
}