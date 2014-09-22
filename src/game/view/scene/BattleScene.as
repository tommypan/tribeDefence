package game.view.scene
{
	import com.gs.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.event.BattleEvent;
	import game.event.SceneChangeEvent;
	import game.event.TowerEvent;
	import game.model.MonsterModel;
	import game.model.PlayerModel;
	import game.model.server.Calculator;
	import game.model.vo.MonsterVo;
	import game.model.vo.PointVo;
	import game.model.vo.TowerVo;
	import game.view.events.ViewBus;
	import game.view.events.ViewEvent;
	import game.view.monster.Monster;
	import game.view.scene.ui.battle.BattleMenuPanel;
	import game.view.scene.ui.battle.DefeatPanel;
	import game.view.scene.ui.battle.InstructionPanel;
	import game.view.scene.ui.battle.PlayerInfo;
	import game.view.scene.ui.battle.SetBar;
	import game.view.scene.ui.battle.Sheep1;
	import game.view.scene.ui.battle.Sheep2;
	import game.view.scene.ui.battle.Speed;
	import game.view.scene.ui.battle.VictoryPanel;
	import game.view.scene.ui.battle.Windmill;
	import game.view.scene.ui.world.LibBar;
	import game.view.tower.CannonTower;
	import game.view.tower.Tower;
	import game.view.tower.TowerState;
	import game.view.tower.TowerType;
	
	import org.osmf.media.PluginInfo;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.pool.ObjectPool;
	import qmang2d.pool.ObjectPoolManager;
	import qmang2d.pool.interfaces.IPool;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.StageProxy;
	import qmang2d.utils.TimerManager;
	
	public class BattleScene extends Sprite
	{
		
		private var xOffset :int = 00;
		
		private var map1 :Bitmap;
		private var map2 :Bitmap;
		private var map3 :MovieClip;
		private var map4 :MovieClip;
		private var map5 :Bitmap;
		private var map6 :Bitmap;
		private var map7 :Bitmap;
		private var map8 :Bitmap;
		private var map9 :Bitmap;
		private var map10 :Bitmap;
		private var map11 :Bitmap;
		private var map12 :Bitmap;
		private var dest :MovieClip;
		private var mapId :int;
		
		public static var money :int;//以此处money为准
		
		//------------------对象池相关
		private var _towerPool:ObjectPool; 
		private var _sheep1Pool:ObjectPool;  
		private var _sheep2Pool:ObjectPool;  
		private var _windmillPool:ObjectPool;  
		public var monsterPool :ObjectPool
		
		//---------------一次性实例化完，防止手机在游戏中途出现顿卡
		public var towers  :Vector.<Tower> = new Vector.<Tower>();
		private var _sheep1s :Vector.<Sheep1>    = new Vector.<Sheep1>();
		private var _sheep2s :Vector.<Sheep2>    = new Vector.<Sheep2>();
		private var _windmills   :Vector.<Windmill>  = new Vector.<Windmill>();
		private var _towerVos:Vector.<TowerVo>;//直接持有数据引用，不搞监听，迭代了
		
		//----------------怪物移动
		private var paths:Array
		
		
		public var monsters :Vector.<Monster> = new Vector.<Monster>();
		public var soldiers :Vector.<Monster> = new Vector.<Monster>();
		private var _monsterVos :Vector.<MonsterVo>;
		public static var _lines:Vector.<Vector.<PointVo>>;//妈的，不管了，直接设为静态在sheildTower使用
		private var _timeCounter :int;
		
		private var mapNum:int;
		
		//战斗地图的UI  
		public var playerInfo:PlayerInfo;
		private var mainBot:MovieClip;
		public var libBot:SimpleButton;
		public var pause:SimpleButton;
		public var setBot:SimpleButton;
		private var _nextWaveBtn:SimpleButton;
		
		private var _live :int;
		private var _curLive :int;
		private var _totalWave :int;
		private var _curWave :int;
		
		public var setBar:SetBar;
		public var back:Sprite;
		public var deadNum:int;
		//暂停后弹出的按钮
		public var pauseBn:BitmapMovie;
		
		private var dePanel:DefeatPanel;
		
		public var battleMenu:BattleMenuPanel;
		
		public var instruction:InstructionPanel;
		
		private var _isBattle :Boolean;

		//private var test:Test;
		
		public function BattleScene($towerVos :Vector.<TowerVo>)
		{
			//test = new Test();
			
			
			_towerVos = $towerVos;
			//战斗地图分层
			addChild(LayerCollection.mapLayer);
			addChild(LayerCollection.buildingLayer);
			addChild(LayerCollection.playerLayer);
			addChild(LayerCollection.effectLayer);
			addChild(LayerCollection.uiLayer);
			
			_towerPool       = ObjectPoolManager.getInstance().getObjectPool(Tower,10);
			_sheep1Pool      = ObjectPoolManager.getInstance().getObjectPool(Sheep1,4);
			_sheep2Pool      = ObjectPoolManager.getInstance().getObjectPool(Sheep2,4);
			_windmillPool    = ObjectPoolManager.getInstance().getObjectPool(Windmill);
			monsterPool     = ObjectPoolManager.getInstance().getObjectPool(Monster,10);
			dest = ClassManager.createDisplayObjectInstance("dest") as MovieClip;
			
			
			pauseBn = new BitmapMovie();
			pauseBn.mouseEnabled = true;
			LoaderManager.getInstance().getMovieClip("assets/pauseBtn.swf",pauseBn,true);
			
			battleMenu = new BattleMenuPanel();
			LayerCollection.uiLayer.addChild(battleMenu);
			
			instruction = new InstructionPanel();
			
			instruction.x = StageProxy.width/4;
			instruction.y = StageProxy.height/2.5;
			instruction.visible = false;
			
			mainBot = ClassManager.createInstance("battleSet") as MovieClip;
			LayerCollection.uiLayer.addChild(mainBot);
			mainBot.x = StageProxy.width/2.3;
			mainBot.y = StageProxy.height/100;
			setBot = mainBot.setting;
			libBot = mainBot.lib;
			pause = mainBot.pause;
			
			var spped :Speed = Speed.getInstance();
			LayerCollection.uiLayer.addChild(spped);
			spped.x = 420;
			spped.y = 10;
			
			//玩家信息面板
			playerInfo = PlayerInfo.getInstance();
			LayerCollection.uiLayer.addChild(playerInfo);
			
			//--------半透明图片层
			back = new Sprite();
			back.graphics.lineStyle(0.5,0x0e1615);
			back.graphics.beginFill(0x000000,0.8);
			back.graphics.drawRoundRect(0,0,2000,1000,8,8);
			back.graphics.endFill();
			back.alpha = .3;
			LayerCollection.uiLayer.addChild(back);
			back.visible = false;
			LayerCollection.uiLayer.addChild(instruction);
			
			//设置面板
			setBar = new SetBar();
			setBar.addEventListener(BattleEvent.CHANGE_QUALITY,onQuality);
			setBar.addEventListener(BattleEvent.CLOSE_SET,onClose);
			LayerCollection.uiLayer.addChild(setBar);
			setBar.x = StageProxy.width*0.25;
			setBar.y = -520;
			
			//M=20,cpu=00.6
			//			Fps.setup(this);
			//			Fps.visible = true;
			
			this.addEventListener(MouseEvent.CLICK, onHideTower);
			ViewBus.instance.addEventListener(BattleEvent.ATTACK_SUCCESS,onCannonAttack);
		}
		
		protected function onCannonAttack(event:BattleEvent):void
		{
			
			var cannon :CannonTower = event.data as CannonTower;
			var loseBlood :int = Calculator.hit(cannon.towerVo.attackPowerMax,cannon.towerVo.attackPowerMin)
			var monster :Monster;
			for (var i:int = 0; i < monsters.length; i++) 
			{
				monster = monsters[i];
				if(monster == cannon._bindMonster)
				{
					if(cannon.bullet.hitTestObject(cannon._bindMonster))
					{
						monster.monsterVo.blood -= loseBlood;
						monster.updateBlood(monster.monsterVo.blood);
					}
					continue;
				}
				
				if(cannon.bullet.hitTestObject(monster))
				{
					monster.monsterVo.blood -= (loseBlood-4);
					
				}
			}
			
		}		
		
		
		protected function onClose(event:Event):void
		{
			back.visible = false;
		}
		
		protected function onQuality(event:BattleEvent):void
		{
			dispatchEvent(new BattleEvent(BattleEvent.CHANGE_QUALITY,event.data));
		}
		
		public function onPause():void
		{
			TimerManager.getInstance().remove(checkCreateMonster)
			back.visible = true;
			LayerCollection.uiLayer.addChild(pauseBn);
			pauseBn.x = 100;pauseBn.y=80;
		}
		
		public function onUnpause():void
		{
			if(_isBattle == true)
			TimerManager.getInstance().add(1000,checkCreateMonster);
			
			back.visible = false;
			LayerCollection.uiLayer.removeChild(pauseBn);
		}
		
		public function onLib():void
		{
			TimerManager.getInstance().remove(checkCreateMonster);
			var libBar:LibBar =  LibBar.getInstance();
			libBar.x = 350;libBar.y = -500;
			addChild(libBar);
			libBar.huanDong();
		}
		
		public function onSet():void
		{
			back.visible =true;
			setBar.huanDong();
			setBar.init();
			TimerManager.getInstance().remove(checkCreateMonster)
		}		
		
		public function onResumeGame():void
		{
			if(_isBattle == true)
			TimerManager.getInstance().add(1000,checkCreateMonster);
		}
		
		public function onQuit(e:MouseEvent=null):void
		{
			back.visible = false;
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.BACK_WORLD_SCENE));
		}
		
		public function onRestartGame():void
		{
			dispose();
		}
		
		protected function onUpdateTower(event:TowerEvent):void
		{
			var tower :Tower = event.target as Tower;
			//tower.removeEventListener(TowerEvent.UPDATE,onUpdateTower);
			
			switch(event.data)
			{
				case TowerEvent.ARROW1:
				{
					updateTowerCommom(tower,TowerType.ARROW,1);
					break;
				}
				case TowerEvent.CANNON1:
				{
					updateTowerCommom(tower,TowerType.CANNON,1);
					break;
				}
				case TowerEvent.MAGIC1:
				{
					updateTowerCommom(tower,TowerType.MAGIC,1);
					break;
				}
				case TowerEvent.SHIELD1:
				{
					updateTowerCommom(tower,TowerType.SHIELD,1);
					break;
				}
					
				case TowerEvent.ARROW2:
				{
					updateTowerCommom(tower,TowerType.ARROW,2);
					break;
				}
				case TowerEvent.CANNON2:
				{
					updateTowerCommom(tower,TowerType.CANNON,2);
					break;
				}
				case TowerEvent.MAGIC2:
				{
					updateTowerCommom(tower,TowerType.MAGIC,2);
					break;
				}
				case TowerEvent.SHIELD2:
				{
					updateTowerCommom(tower,TowerType.SHIELD,2);
					break;
				}
					
				case TowerEvent.ARROW3:
				{
					updateTowerCommom(tower,TowerType.ARROW,3);
					break;
				}
				case TowerEvent.CANNON3:
				{
					updateTowerCommom(tower,TowerType.CANNON,3);
					break;
				}
				case TowerEvent.MAGIC3:
				{
					updateTowerCommom(tower,TowerType.MAGIC,3);
					break;
				}
				case TowerEvent.SHIELD3:
				{
					updateTowerCommom(tower,TowerType.SHIELD,3);
					break;
				}
					
				case TowerEvent.ARROW4:
				{
					updateTowerCommom(tower,TowerType.ARROW,4);
					break;
				}
				case TowerEvent.CANNON4:
				{
					updateTowerCommom(tower,TowerType.CANNON,4);
					break;
				}
				case TowerEvent.MAGIC4:
				{
					updateTowerCommom(tower,TowerType.MAGIC,4);
					break;
				}
				case TowerEvent.SHIELD4:
				{
					updateTowerCommom(tower,TowerType.SHIELD,4);
					break;
				}
			}
			playerInfo.updataMoney(money);
		}
		
		private function updateTowerCommom(tower:Tower,type:String,level_:int):void
		{
			var towerVo :TowerVo;
			for (var i:int = 0; i < _towerVos.length; i++) 
			{
				towerVo = _towerVos[i];
				if(towerVo.level == level_ && towerVo.type == type)
				{
					tower.updateTower(towerVo);
				}
			}
			
		}
		
		public function updateMoney():void
		{
			playerInfo.updataMoney(money);
		}
		
		public function initPlayerInfo(live:int,money_:int,curWave:int,totalWave:int):void
		{
			_live = live;
			_totalWave = totalWave;
			money = money_;
			//test.test2();
			//变更玩家信息
			playerInfo.updataLive(live);
			playerInfo.updataMoney(money);
			playerInfo.upDateWave(curWave,totalWave);
			battleMenu.beginFight.addEventListener(MouseEvent.CLICK,onBeginBattle);
		}
		
		
		/**
		 *初始化怪物以及配置数据 
		 * @param num
		 * 
		 */		
		public function initMonster(num:int,lines:Vector.<Vector.<PointVo>>,monsterVos:Vector.<MonsterVo>):void
		{
			mapId = num;
			_monsterVos = monsterVos;
			_lines = lines;
			
			battleMenu.startBattle.visible = true;
		}		
		
		/**
		 *开始出怪，战斗开始 
		 * 
		 */		
		public function onBeginBattle(e:MouseEvent):void
		{
			_isBattle = true;
			battleMenu.startBattle.visible = false;
			SoundManager.getInstance().playEffectSound("start");
			battleMenu.beginFight.removeEventListener(MouseEvent.CLICK,onBeginBattle);
			createMonster(0);
			TimerManager.getInstance().add(1000,checkCreateMonster);
		}
		
		private function checkCreateMonster():void
		{
			_timeCounter++;
			createMonster(_timeCounter);
		}		
		
		//出现时间	
		private function createMonster(time :int):void
		{
			var monsterVo :MonsterVo;
			var monster:Monster;
			for (var i:int = 0; i <_monsterVos.length; i++) 
			{
				monsterVo = _monsterVos[i];
				if(monsterVo.time == time)
				{
					monster=monsterPool.getObject() as Monster;
					monster.init(_lines[monsterVo.lineId],monsterVo.reflectName,monsterVo);
					monsters.push(monster);
					monster.x=_lines[monsterVo.lineId][0].x;monster.y=_lines[monsterVo.lineId][0].y;
					LayerCollection.playerLayer.addChild(monster);
					monster.run();
					monster.addEventListener(Event.COMPLETE, onWalkOver);
					if(_curWave != monsterVo.wave)
					{
						SoundManager.getInstance().playEffectSound("start");
						_curWave = monsterVo.wave;
						checkWave();
					}//每一波出来之前都应该有提前出怪，计算提前时间量即相对时间,后又按照顺序出怪
				}
			}
		}
		
		private function checkWave():void
		{
			playerInfo.upDateWave(_curWave,_totalWave);
		}
		
		//走完了-------
		private function onWalkOver(event:Event):void
		{
			SoundManager.getInstance().playEffectSound("sClock");
			deadNum++;
			_curLive = _live-deadNum;
			playerInfo.updataLive(_curLive);
			trace("逃脱掉的怪物数:",deadNum);
			var monster :Monster = event.target as Monster;
			monster.removeEventListener(Event.COMPLETE, onWalkOver);
			monster.onRemoveIt();
			monsters.splice(monsters.indexOf(monster),1);
			monsterPool.releaseObject(monster);
			checkDefeat();
			dispatchEvent(new Event(BattleEvent.CHECK_BATTLE_OVER));
		}
		
		private function checkDefeat():void
		{
			if(_curLive == 0)
			{
				dePanel = DefeatPanel.getInstance();
				LayerCollection.uiLayer.addChild(dePanel);
				dePanel.x = 150;
				dePanel.y = -500;
				TweenLite.to(dePanel,.6,{y:0});
				back.visible = true;
				dispatchEvent(new BattleEvent(BattleEvent.BATTLE_FAIL));
			}
		}
		
		
		
		public function Render():void
		{
			for (var i:int = 0; i < monsters.length; i++) 
			{
				monsters[i].moving()
			}
			
			for (var j:int = 0; j < towers.length; j++) 
			{
				if(towers[j].newTower && towers[j].towerType == TowerType.SHIELD)
				{
					if(towers[j].newTower.state == TowerState.IDEL)
					{
						towers[j].newTower.Render();
					}
					continue;
				}
				if(towers[j].newTower && towers[j].newTower.state == TowerState.SHOOT)
					towers[j].newTower.Render();
			}
			
			
		}
		
		
		/**
		 *释放地图资源以及地图上的建筑等 
		 * 
		 */		
		public function dispose():void
		{
			TimerManager.getInstance().remove(checkCreateMonster)
			_timeCounter = 0;
			deadNum = 0;
			_curWave = 0;
			_isBattle = false;
			
			//---------------------清除地图上的建筑物
			var animator :IPool;
			var monster:Monster;
			var len :int; 
			
			len = _sheep1s.length;
			for (var i:int = 0; i < len; i++) 
			{
				animator = _sheep1s.pop();
				animator.sleep();
				LayerCollection.mapLayer.removeChild(animator as Sprite);
				_sheep1Pool.releaseObject(animator);
			}
			
			len = _sheep2s.length;
			for ( i = 0; i < len; i++) 
			{
				animator = _sheep2s.pop();
				animator.sleep();
				LayerCollection.mapLayer.removeChild(animator as Sprite);
				_sheep2Pool.releaseObject(animator);
			}
			
			len = towers.length;
			for ( i = 0; i < len; i++) 
			{
				animator = towers.pop();
				animator.sleep();
				LayerCollection.buildingLayer.removeChild(animator as Sprite);
				_towerPool.releaseObject(animator);
			}
			
			len = _windmills.length;
			for ( i = 0; i < len; i++) 
			{
				animator = _windmills.pop();
				animator.sleep();
				LayerCollection.buildingLayer.removeChild(animator as Sprite);
				_windmillPool.releaseObject(animator);
			}
			
			//-----------------清除地图上的人物
			len = monsters.length;
			for ( i = 0; i < len; i++) 
			{
				monster = monsters.pop();
				monster.onRemoveIt();
				monster.removeEventListener(Event.COMPLETE, onWalkOver);
				//trace("monsters.indexOf(monster)",monsters.indexOf(monster));
			}
			
			//-----------------清除可能的特效
			
			disposeMap();
			
			(LayerCollection.uiLayer.contains(DefeatPanel.getInstance())) && (LayerCollection.uiLayer.removeChild(DefeatPanel.getInstance())); 
			(LayerCollection.uiLayer.contains(VictoryPanel.getInstance())) && (LayerCollection.uiLayer.removeChild(VictoryPanel.getInstance())); 
		}
		
		private function disposeMap():void
		{
			//-----------------清除地图
			switch(mapId)
			{
				case 1:
					LayerCollection.mapLayer.removeChild(map1);
					break;
				case 2:
					LayerCollection.mapLayer.removeChild(map2);
					break;
				case 3:
					LayerCollection.mapLayer.removeChild(map3);
					break;
				case 4:
					LayerCollection.mapLayer.removeChild(map4);
					break;
				case 5:
					LayerCollection.mapLayer.removeChild(map5);
					break;
				case 6:
					LayerCollection.mapLayer.removeChild(map6);
					break;
				case 7:
					LayerCollection.mapLayer.removeChild(map7);
					break;
				case 8:
					LayerCollection.mapLayer.removeChild(map8);
					break;
				case 9:
					LayerCollection.mapLayer.removeChild(map9);
					break;
				case 10:
					LayerCollection.mapLayer.removeChild(map10);
					break;
				case 11:
					LayerCollection.mapLayer.removeChild(map11);
					break;
				case 12:
					LayerCollection.mapLayer.removeChild(map12);
					break;
			}
		}
		public function createMap1():void
		{
			
			map1 = new Bitmap(ClassManager.createBitmapDataInstance("map1"));
			LayerCollection.mapLayer.addChild(map1);
			map1.x = xOffset;
			
			
			var sheep1 :Sheep1, sheep2 :Sheep2, windmill:Windmill;
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;
			sheep1.x = xOffset+500;sheep1.y = 300;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+500;sheep1.y = 330;
			addAnimationOnMap(sheep1);
			
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+300;sheep1.y = 530;
			addAnimationOnMap(sheep1);
			
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+270;sheep1.y = 530;
			sheep1.scaleX = -1;
			addAnimationOnMap(sheep1);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+450;sheep2.y = 300;
			addAnimationOnMap(sheep2);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+320;sheep2.y = 300;
			addAnimationOnMap(sheep2);
			
			windmill = _windmillPool.getObject() as Windmill;
			windmill.x = xOffset+520;windmill.y = 250;
			addAnimationOnMap(windmill);
			
			windmill = _windmillPool.getObject() as Windmill;
			windmill.x = xOffset+500;windmill.y = 200;
			addAnimationOnMap(windmill);
			
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+430;tower.y = 350;
			addAnimationOnMap(tower);
			
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+545;tower.y = 420;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+350;tower.y = 440;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+290;tower.y = 340;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+220;tower.y = 345;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+220;tower.y = 285;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+150;tower.y = 185;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+205;tower.y = 159;
			addAnimationOnMap(tower);
			
			LayerCollection.mapLayer.addChild(dest);
			dest.x = xOffset+660;dest.y = 350;
			
		}
		
		
		public function createMap2():void
		{
			map2 = new Bitmap(ClassManager.createBitmapDataInstance("map2"));
			LayerCollection.mapLayer.addChild(map2);
			map2.x = xOffset;
			
			var sheep1 :Sheep1, sheep2 :Sheep2, windmill:Windmill;
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+500;sheep1.y = 320;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+500;sheep1.y = 350;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+200;sheep1.y = 530;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+170;sheep1.y = 550;
			sheep1.scaleX = -1;
			addAnimationOnMap(sheep1);
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+500;sheep2.y = 300;
			addAnimationOnMap(sheep2);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+430;sheep2.y = 500;
			addAnimationOnMap(sheep2);
			
			
			windmill = _windmillPool.getObject() as Windmill;
			windmill.x = xOffset+520;windmill.y = 380;
			addAnimationOnMap(windmill);
			
			windmill = _windmillPool.getObject() as Windmill;
			windmill.x = xOffset+500;windmill.y = 230;
			addAnimationOnMap(windmill);
			
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+260;tower.y = 135;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+350;tower.y = 460;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+340;tower.y = 345;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+255;tower.y = 360;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+210;tower.y = 245;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+400;tower.y = 185;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+400;tower.y = 119;
			addAnimationOnMap(tower);
			
			LayerCollection.mapLayer.addChild(dest);
			dest.x = xOffset+300;dest.y = 550;
		}
		
		public function createMap3():void
		{
			map3 = ClassManager.createDisplayObjectInstance("map3") as MovieClip;
			LayerCollection.mapLayer.addChild(map3);
			map3.y = -10;map3.x=-7;
			
			var sheep1 :Sheep1, sheep2 :Sheep2, windmill:Windmill;
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+590;sheep1.y = 320;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+590;sheep1.y = 350;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+400;sheep1.y = 530;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+370;sheep1.y = 550;
			sheep1.scaleX = -1;
			addAnimationOnMap(sheep1);
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+590;sheep2.y = 300;
			addAnimationOnMap(sheep2);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+430;sheep2.y = 530;
			addAnimationOnMap(sheep2);
			
			
			windmill = _windmillPool.getObject() as Windmill;
			windmill.x = xOffset+580;windmill.y = 40;
			addAnimationOnMap(windmill);
			
			windmill = _windmillPool.getObject() as Windmill; 
			windmill.x = xOffset+540;windmill.y = 60;
			addAnimationOnMap(windmill);
			
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+179;tower.y = 425;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+253;tower.y = 455;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+245;tower.y = 310;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+328;tower.y = 343;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+409;tower.y = 370;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+540;tower.y = 445;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+434;tower.y = 275;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+300;tower.y = 185;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+240;tower.y = 98;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+312;tower.y = 76;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+382;tower.y = 172;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+477;tower.y = 166;
			addAnimationOnMap(tower);
		}
		
		public function createMap4():void
		{
			map4 = ClassManager.createDisplayObjectInstance("map4") as MovieClip;
			LayerCollection.mapLayer.addChild(map4);
			
			
			var sheep1 :Sheep1, windmill:Windmill;
			
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+430;sheep1.y = 330;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+415;sheep1.y = 350;
			sheep1.scaleX = -1;
			addAnimationOnMap(sheep1);
			
			
			windmill = _windmillPool.getObject() as Windmill;
			windmill.x = xOffset+580;windmill.y = 20;
			addAnimationOnMap(windmill);
			
			windmill = _windmillPool.getObject() as Windmill; 
			windmill.x = xOffset+540;windmill.y = 40;
			addAnimationOnMap(windmill);
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+58;tower.y = 326;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+435;tower.y = 470;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+552;tower.y = 455;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+295;tower.y = 365;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+380;tower.y = 370;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+460;tower.y = 370;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+515;tower.y = 310;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+510;tower.y = 251;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+480;tower.y = 190;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+177;tower.y = 278;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+162;tower.y = 225;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+168;tower.y = 164;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+220;tower.y = 130;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+291;tower.y = 108;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+370;tower.y = 113;
			addAnimationOnMap(tower);
		}
		
		public function createMap5():void
		{
			map5 = new Bitmap(ClassManager.createBitmapDataInstance("map5"));
			LayerCollection.mapLayer.addChild(map5);
			map5.x = xOffset;
			
			var sheep1 :Sheep1, windmill:Windmill;
			
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+430;sheep1.y = 330;
			addAnimationOnMap(sheep1);
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+415;sheep1.y = 350;
			sheep1.scaleX = -1;
			addAnimationOnMap(sheep1);
			
			windmill = _windmillPool.getObject() as Windmill; 
			windmill.x = xOffset+530;windmill.y = 65;
			addAnimationOnMap(windmill);
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+200;tower.y = 445;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+420;tower.y = 413;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+314;tower.y = 350;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+432;tower.y = 354;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+154;tower.y = 321;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+320;tower.y = 301;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+442;tower.y = 302;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+76;tower.y = 655;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+220;tower.y = 225;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+345;tower.y = 181;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+538;tower.y = 212;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+503;tower.y = 168;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+360;tower.y = 75;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+70;tower.y = 155;
			addAnimationOnMap(tower);
		}
		
		public function createMap6():void
		{
			map6 = new Bitmap(ClassManager.createBitmapDataInstance("map6"));
			LayerCollection.mapLayer.addChild(map6);
			map6.x = xOffset;
			
			var sheep1 :Sheep1, windmill:Windmill;
			
			
			sheep1 = _sheep1Pool.getObject() as Sheep1;;
			sheep1.x = xOffset+430;sheep1.y = 530;
			addAnimationOnMap(sheep1);
			
			
			windmill = _windmillPool.getObject() as Windmill; 
			windmill.x = xOffset+560;windmill.y = 65;
			addAnimationOnMap(windmill);
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+222;tower.y = 439;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+414;tower.y = 439;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+86;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+240;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+315;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+395;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+550;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+154;tower.y = 210;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+235;tower.y = 210;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+403;tower.y = 210;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+480;tower.y = 210;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+145;tower.y = 100;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+225;tower.y = 100;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+410;tower.y = 100;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(1);
			tower.x = xOffset+495;tower.y = 100;
			addAnimationOnMap(tower);
		}
		
		
		public function createMap7():void
		{
			map7 = new Bitmap(ClassManager.createBitmapDataInstance("map7"));
			LayerCollection.mapLayer.addChild(map7);
			map7.x = xOffset;
			
			var sheep2 :Sheep2;
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+600;sheep2.y = 350;
			addAnimationOnMap(sheep2);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+580;sheep2.y = 450;
			addAnimationOnMap(sheep2);
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+600;sheep2.y = 430;
			sheep2.scaleX = -1;
			addAnimationOnMap(sheep2);
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+283;tower.y = 408;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+357;tower.y = 408;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+435;tower.y = 408;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+503;tower.y = 442;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+197;tower.y = 290;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+272;tower.y = 290;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+345;tower.y = 290;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+430;tower.y = 290;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+225;tower.y = 170;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+300;tower.y = 170;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+385;tower.y = 170;
			addAnimationOnMap(tower);
		}
		
		public function createMap8():void
		{
			map8 = new Bitmap(ClassManager.createBitmapDataInstance("map8"));
			LayerCollection.mapLayer.addChild(map8);
			map8.x = xOffset;
			
			var sheep2 :Sheep2;
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+620;sheep2.y = 350;
			addAnimationOnMap(sheep2);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+630;sheep2.y = 400;
			sheep2.scaleX = -1;
			addAnimationOnMap(sheep2);
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+80;tower.y = 368;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+234;tower.y = 418;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+314;tower.y = 418;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+328;tower.y = 460;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+471;tower.y = 391;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+543;tower.y = 391;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+220;tower.y = 305;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+293;tower.y = 305;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+365;tower.y = 305;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+348;tower.y = 190;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+425;tower.y = 190;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+505;tower.y = 190;
			addAnimationOnMap(tower);
		}
		
		public function createMap9():void
		{
			map9 = new Bitmap(ClassManager.createBitmapDataInstance("map9"));
			LayerCollection.mapLayer.addChild(map9);
			map9.x = xOffset;
			
			var sheep2 :Sheep2;
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+270;sheep2.y = 515;
			addAnimationOnMap(sheep2);
			
			
			sheep2 = _sheep2Pool.getObject() as Sheep2;
			sheep2.x = xOffset+280;sheep2.y = 500;
			sheep2.scaleX = -1;
			addAnimationOnMap(sheep2);
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+285;tower.y = 437;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+364;tower.y = 437;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+450;tower.y = 437;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+313;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+389;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+474;tower.y = 320;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+543;tower.y = 340;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+538;tower.y = 280;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+173;tower.y = 184;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+241;tower.y = 208;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+318;tower.y = 208;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+394;tower.y = 208;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+300;tower.y = 90;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+380;tower.y = 92;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(2);
			tower.x = xOffset+455;tower.y = 95;
			addAnimationOnMap(tower);
		}
		
		public function createMap10():void
		{
			map10 = new Bitmap(ClassManager.createBitmapDataInstance("map10"));
			LayerCollection.mapLayer.addChild(map10);
			map10.x = xOffset;
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+80;tower.y = 390;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+155;tower.y = 390;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+545;tower.y = 390;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+540;tower.y = 293;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+370;tower.y = 380;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+310;tower.y = 337;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+373;tower.y = 312;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+188;tower.y = 281;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+260;tower.y = 281;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+380;tower.y = 247;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+425;tower.y = 210;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+390;tower.y = 150;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+460;tower.y = 150;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+230;tower.y = 160;
			addAnimationOnMap(tower);
		}
		
		public function createMap11():void
		{
			map11 = new Bitmap(ClassManager.createBitmapDataInstance("map11"));
			LayerCollection.mapLayer.addChild(map11);
			map11.x = xOffset;
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+95;tower.y = 440;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+515;tower.y = 440;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+272;tower.y = 425;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+350;tower.y = 425;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+220;tower.y = 353;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+145;tower.y = 330;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+120;tower.y = 278;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+135;tower.y = 217;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+195;tower.y = 190;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+262;tower.y = 185;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+345;tower.y = 185;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+430;tower.y = 187;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+495;tower.y = 218;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+513;tower.y = 271;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+480;tower.y = 335;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+400;tower.y = 353;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+220;tower.y = 77;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+400;tower.y = 77;
			addAnimationOnMap(tower);
		}
		
		public function createMap12():void
		{
			map12 = new Bitmap(ClassManager.createBitmapDataInstance("map12"));
			LayerCollection.mapLayer.addChild(map12);
			map12.x = xOffset;
			
			var tower :Tower;
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+152;tower.y = 155;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+515;tower.y = 165;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+520;tower.y = 220;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+186;tower.y = 275;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+265;tower.y = 275;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+345;tower.y = 275;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+508;tower.y = 275;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+230;tower.y = 400;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+303;tower.y = 400;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+383;tower.y = 400;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+465;tower.y = 400;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+545;tower.y = 400;
			addAnimationOnMap(tower);
			
			tower = _towerPool.getObject() as Tower;
			tower.setColorForm(3);
			tower.x = xOffset+565;tower.y = 450;
			addAnimationOnMap(tower);
			
		}
		
		private function addAnimationOnMap(ani :IPool):void
		{
			
			if(ani is Sheep1 )
			{
				LayerCollection.mapLayer.addChild(ani as Sprite);
				_sheep1s.push(ani);
			}else if(ani is Sheep2){
				LayerCollection.mapLayer.addChild(ani as Sprite);
				_sheep2s.push(ani);
			}else if(ani is Tower){
				LayerCollection.buildingLayer.addChild(ani as Sprite);
				Tower(ani).addEventListener(TowerEvent.UPDATE,onUpdateTower);
				towers.push(ani);
			}else if(ani is Windmill){
				LayerCollection.buildingLayer.addChild(ani as Sprite);
				_windmills.push(ani);
			}
			
			ani.wakeUp();
		}
		
		
		private function onHideTower(event:MouseEvent):void
		{
			ViewBus.instance.dispatchEvent(new ViewEvent(ViewBus.HIDE_TOWER,this));
		}	
		
		
		
		
	}
}