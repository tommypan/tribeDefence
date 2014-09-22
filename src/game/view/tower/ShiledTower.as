package game.view.tower
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import game.event.BattleEvent;
	import game.model.vo.MonsterVo;
	import game.model.vo.PointVo;
	import game.view.monster.MonsterState;
	import game.view.scene.BattleScene;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.pool.ObjectPool;
	import qmang2d.pool.ObjectPoolManager;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	public class ShiledTower extends BaseTower
	{
		
		public var soilders :Vector.<Soldier>;
		private var _towerPool :ObjectPool;
		
		//------辅助变量
		private var _index :int;
		
		//----音效播放辅助变量
		private var _isReady :Boolean;
		
		public function ShiledTower()
		{
			super();
			
			soilders = new Vector.<Soldier>();
			_towerPool = ObjectPoolManager.getInstance().getObjectPool(Soldier);
			createAllInstance();
			
			createShiledTower(_level);
		}
		
		private function createShiledTower(level_:int):void
		{
			var towerMc :MovieClip  = ClassManager.createDisplayObjectInstance("shield"+_level) as MovieClip;
			_tower = LoaderManager.getInstance().changeMcToBitmapMovie(towerMc,true,"shield"+_level);
			addChild(_tower);
			_tower.y = -22;
			_tower.x = -5;
			_tower.gotoAndStop(1);
			_tower.mouseEnabled = true;
			_tower.buttonMode = true;
			
			for (var i:int = 0; i < soilders.length; i++) 
			{
				soilders[i].bitmapMovie.removeEventListener("end",checkHit);
				soilders[i].changeSkin("soilder"+_level,test);
				//				soilders[i].hitNum = _level;
				soilders[i].bitmapMovie.addEventListener("end",checkHit);
			}
			
		}
		
		override public function upGradeTower():void
		{
			_level++;
			if(_level <= 4)
			{
				createShiledTower(_level);
				
			}
			
			if(_level == 3 || _level == 4)
			{
				_tower.y -= 10; 
			}
		}
		
		public function createAllInstance():void
		{
			for (var i:int = 0; i < 3; i++) 
			{
				var soilder:Soldier;
				var lineIdNum :int = BattleScene._lines.length;
				var lineId :int = Math.random()*lineIdNum;
				var lines :Vector.<PointVo> = BattleScene._lines[lineId];
				soilder = _towerPool.getObject() as Soldier;
				//soilder.monsterVo = ;
				soilder.init(lines,"soilder1",createMonsterVo(),TowerType.SHIELD);
				soilder.x = lines[lines.length-1].x;
				soilder.y =lines[lines.length-1].y;
				soilders.push(soilder);
			}
			
			
			
			TimerManager.getInstance().add(3000,createMonster);
			//idel 2-24open_door;25closed_door
		}
		
		private function createMonster():void
		{
			if(_index < 3)
			{
				var soilder :Soldier = soilders[_index];
				soilder.bitmapMovie.addEventListener("end",checkHit);
				soilder.addEventListener(Event.COMPLETE,onWalkOver);
				soilder.addEventListener(BattleEvent.DEAD_PALY_OVER,onWalkOver);
				LayerCollection.playerLayer.addChild(soilder);//2-6running
				soilder.run();
				_index++;
				_tower.gotoAndPlay(2,false,2,24,onOpenOver); 
			}else{
				TimerManager.getInstance().remove(createMonster);
			}
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			TimerManager.getInstance().remove(createMonster);
			var soilder :Soldier;
			for (var i:int = 0; i < soilders.length; i++) 
			{
				soilder = soilders[i];
				soilder.bitmapMovie.removeEventListener("end",checkHit);
				soilder.removeEventListener(Event.COMPLETE,onWalkOver);
				soilder.removeEventListener(BattleEvent.DEAD_PALY_OVER,onWalkOver);
				soilder.bitmapMovie.stop();
				(LayerCollection.playerLayer.contains(soilder)) && (LayerCollection.playerLayer.removeChild(soilder));
				//				soilder = null;
			}
			removeChild(_tower);
			soilders = null;
		}
		
		
		//走完到终点，重新开始巡逻
		protected function onWalkOver(event:Event):void
		{
			
			_tower.gotoAndPlay(2,false,2,24,onOpenOver); 
			
			var soilder :Soldier = event.target as Soldier;
			createNewSoldier(soilder);
			
		}
		
		
		private function createNewSoldier(soilder:Soldier):void
		{
			var lineIdNum :int = BattleScene._lines.length;
			var lineId :int = Math.random()*lineIdNum;
			var lines :Vector.<PointVo> = BattleScene._lines[lineId];
			soilder.monsterVo = createMonsterVo();
			soilder.run();
			soilder.initLine(lines);
			soilder.x = lines[lines.length-1].x;
			soilder.y =lines[lines.length-1].y;
		}
		
		
		private function createMonsterVo():MonsterVo
		{
			var monsterVo :MonsterVo = new MonsterVo();
			monsterVo.attackPower=8;
			monsterVo.blood = 10;
			monsterVo.speed=3;
			monsterVo.reflectName = "soilder1";
			return monsterVo;
		}
		
		
		private function onOpenOver():void
		{
			_tower.gotoAndStop(1);
		}
		
		
		public function fightting(i:int):void
		{
			soilders[i].fighting(test);
		}
		
		private function test():void
		{
			
		}
		
		override public function Render():void
		{
			
			for (var i:int = 0; i < soilders.length; i++) 
			{
				if(soilders[i].state == MonsterState.RUN)
					soilders[i].moving();
			}
			
			//这里面写moving,不涉及到动画播放
			
		}
		
		private function checkHit(e:Event):void
		{
			var bitmapMovie :BitmapMovie = e.target as BitmapMovie;
			for (var i:int = 0; i < soilders.length; i++) 
			{
				if(soilders[i].bitmapMovie == bitmapMovie)
				{
					var curHp:int = soilders[i].bindMonster.monsterVo.blood
					soilders[i].bindMonster.monsterVo.blood -= _level*1.5;
					soilders[i].monsterVo.blood -= 1/_level;
					checkSound();
					
					soilders[i].bindMonster.updateBlood(curHp);
					//士兵升级后攻击
					if(soilders[i].bindMonster.monsterVo.blood <= 0 && soilders[i].monsterVo.blood > 0)
					{
						soilders[i].run();
						break;
					}
					if(soilders[i].monsterVo.blood <= 0 )
					{
						soilders[i].die();
						if(soilders[i].bindMonster.monsterVo.blood > 0)
						{
							soilders[i].bindMonster.run();
						}
					}
					
					
				}
			}
			
		}
		
		private function checkSound():void
		{
			_isReady = !_isReady;
			(_isReady) &&  (SoundManager.getInstance().playEffectSound("fight"+int((1+2*Math.random()))));
			
		}		
		
	}
}