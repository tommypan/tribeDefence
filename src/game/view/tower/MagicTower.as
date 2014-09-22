package game.view.tower
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.model.server.Calculator;
	import game.model.vo.TowerVo;
	import game.view.monster.Monster;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	public class MagicTower extends BaseTower
	{
		private var _towerSprite :BitmapMovie;
		private var _bullet :BitmapMovie;
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _isRender:Boolean;
		private var _rotation :Number;
		
		private var _totalFrame :int;
		
		public function MagicTower()
		{
			super();
			
			var towerMc:MovieClip = ClassManager.createDisplayObjectInstance("magic2") as MovieClip;
			_tower = LoaderManager.getInstance().changeMcToBitmapMovie(towerMc,true,"magic2");
			addChild(_tower);
			_tower.y = -45;//2
			_tower.x = -10;
			
			_tower.gotoAndStop(1);//2-39shoot
			
			
			var mage:MovieClip = ClassManager.createDisplayObjectInstance("mage4") as MovieClip;
			_towerSprite = LoaderManager.getInstance().changeMcToBitmapMovie(mage,true,"mage4");
			_tower.addChild(_towerSprite);
			_towerSprite.x = 43;
			_towerSprite.y = 45;
			_towerSprite.gotoAndStop(1);//1 idelDown,2 idelup；3-35shootDown，36-69shootUp
			
			_bullet = new BitmapMovie();
			LoaderManager.getInstance().getMovieClip("assets/magicBullect.swf",_bullet);
			LayerCollection.effectLayer.addChild(_bullet);
			
			_bullet.visible = false;
			
			_tower.mouseEnabled = true;
			_tower.buttonMode = true;
		}
		
		override public function upGradeTower():void
		{
			_level++;
			if(_level == 2)
			{
				_tower.scaleX = _tower.scaleY = 1.05;
				
			}else if(_level == 3){
				_tower.removeChild(_towerSprite);
				removeChild(_tower);
				_tower = null;
				
				var towerMc:MovieClip = ClassManager.createDisplayObjectInstance("magic4") as MovieClip;
				_tower = LoaderManager.getInstance().changeMcToBitmapMovie(towerMc,true,"magic4");
				addChild(_tower);
				_tower.x = -10;//3,4
				_tower.y = -60;
				
				_tower.addChild(_towerSprite);
				_towerSprite.x = 43;
				_towerSprite.y = 45;
				_tower.gotoAndStop(1);
				_towerSprite.gotoAndStop(1);
				
				_tower.mouseEnabled = true;
				_tower.buttonMode = true;
			}else if(_level == 4){
				_tower.scaleX = _tower.scaleY = 1.05;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_towerSprite.stop();
			_tower.stop();
			_bullet.stop();
			removeChild(_tower);
			LayerCollection.effectLayer.removeChild(_bullet);
			_tower.removeChild(_towerSprite);
			
			//			_towerSprite = null;
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
			_startPoint = new Point(20+_parentX,-70+_parentY);
		}
		
		override public function readyShoot(towerVo:TowerVo):void
		{
			super.readyShoot(towerVo);
			_bullet.x = _parentX+40;
			_bullet.y = _parentY-20;
			_tower.gotoAndPlay(2,false,2,39);
			if(getAngleOfTM() > 0)
			{
				_towerSprite.gotoAndPlay(3,false,3,35,shoot);;//shootDown
			}else{
				_towerSprite.gotoAndPlay(36,false,36,69,shoot);//idelUp
			}
		}
		
		/**
		 *大炮射击 
		 * 
		 */		
		override protected function shoot():void
		{
			super.shoot();
			SoundManager.getInstance().playEffectSound("sFightMagic1");
			_rotation = getAngleOfTM()/Math.PI * 180;
			_bullet.width = getDistance();
			_bullet.height = 10;
			_bullet.rotation = _rotation;
			_bullet.visible = true;
			TimerManager.getInstance().add(500/(2*div),startCool);
			checkHit();
			//trace("getAngleOfTM()/Math.PI * 180",getAngleOfTM()/Math.PI * 180);
		}
		
		override public function Render():void
		{
			_rotation = getAngleOfTM()/Math.PI * 180;
			_bullet.rotation = _rotation;
			//			_bullet.width = getDistance();
		}
		
		/**
		 *打击完毕，开启冷却 
		 * 
		 */		
		override protected function startCool():void
		{
			TimerManager.getInstance().remove(startCool);
			_bullet.x = _parentX+40;
			_bullet.y = _parentY-20;
			_bullet.rotation = 0;
			_bullet.visible = false;
			super.startCool();
		}
		
		/**
		 *返回怪物與塔防之間的角度 
		 * @return 
		 * 
		 */		
		protected function getDistance():Number
		{
			
			var dx :Number=_bindMonster.x - _bullet.x;
			var dy :Number=_bindMonster.y - _bullet.y;
			//计算角度
			return Math.sqrt(dx*dx+dy*dy);
		}
		
		override protected function getAngleOfTM():Number
		{
			var dx :Number=_bindMonster.x  - _bullet.x;
			var dy :Number=_bindMonster.y- _bullet.y;
			return Math.atan2(dy,dx);
		}
		
		private function checkHit():void
		{
			if(_towerVo.bindMonster)
			{
				if(_towerVo.bindMonster.monsterVo.blood >0)
				{
					var temp:int =  Calculator.hit(_towerVo.attackPowerMax,_towerVo.attackPowerMin);
					_towerVo.bindMonster.monsterVo.blood -= temp;
					_towerVo.bindMonster.updateBlood(_towerVo.bindMonster.monsterVo.blood);
					//trace("towerVo.id:",_towerVo.id,"monatserId:",_towerVo.bindMonster._monsterVo.id,"monsterBlood:",_towerVo.bindMonster._monsterVo.blood);
				}
			}
		}		
	}
	
}