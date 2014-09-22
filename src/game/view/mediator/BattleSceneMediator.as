package game.view.mediator
{
	import com.gs.TweenLite;
	
	import flash.display.SimpleButton;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	
	import flashx.textLayout.elements.SpecialCharacterElement;
	
	import game.event.BattleEvent;
	import game.event.SceneChangeEvent;
	import game.model.ChapterConfigModel;
	import game.model.ChapterModel;
	import game.model.LineModel;
	import game.model.TowerModel;
	import game.model.vo.ChapterPlayerVo;
	import game.model.vo.TowerVo;
	import game.view.monster.Monster;
	import game.view.monster.MonsterState;
	import game.view.scene.BattleScene;
	import game.view.scene.FinalScene;
	import game.view.scene.ui.battle.DefeatPanel;
	import game.view.scene.ui.battle.SetBar;
	import game.view.scene.ui.battle.Speed;
	import game.view.scene.ui.battle.VictoryPanel;
	import game.view.scene.ui.world.LibBar;
	import game.view.tower.ShiledTower;
	import game.view.tower.Soldier;
	import game.view.tower.Tower;
	import game.view.tower.TowerState;
	import game.view.tower.TowerType;
	
	import org.robotlegs.mvcs.Mediator;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.pool.ObjectPool;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.TimerManager;
	
	public class BattleSceneMediator extends Mediator
	{
		[Inject]
		public var chapterModel :ChapterModel;//进行匹配后的数据存放地，用到当前关的怪物信息
		
		[Inject]
		public var towerModel :TowerModel;//todo 用到里面的塔防属性
		
		[Inject]
		public var chapterConfigModel :ChapterConfigModel;//用到里面的每关的玩家资源配置
		
		[Inject]
		public var lineModel :LineModel;//用到里面的路点
		
		[Inject]
		public var battle:BattleScene;
		
		private var _towers  :Vector.<Tower>;
		
		private var _monsters :Vector.<Monster>;
		
		private var _monsterPool :ObjectPool;
		
		private var hitNum:int;
		
		private var _monsterNum :int;
		
		private var _setBar :SetBar;
		
		private var _setBot :SimpleButton;
		
		private var _mapNum:int;
		private var _pause :SimpleButton;
		private var _pauseBn :BitmapMovie;
		private var _libBot :SimpleButton;
		private var closeInstruct:SimpleButton;
		private var skip:SimpleButton;
		//		private var _fight:SimpleButton;
		private var timeTemp :int = 50;
		
		public function BattleSceneMediator()
		{
			
		}
		
		override public function onRegister():void
		{
			addContextListener(SceneChangeEvent.TO_BATTLE_SCENE,toBattle,SceneChangeEvent);
			addContextListener(SceneChangeEvent.FIRST_TO_BATTLE_SCENE,toBattle,SceneChangeEvent);
			addViewListener(SceneChangeEvent.BACK_WORLD_SCENE,toWorld,SceneChangeEvent);
			addViewListener(BattleEvent.CHANGE_QUALITY,onQuality);
			
			//addViewListener(Event.COMPLETE, onStartBattle);
			onStartBattle();
		}
		
		
		
		private function onStartBattle(e:Event=null):void
		{
			_towers = battle.towers;
			_monsters = battle.monsters;
			_monsterPool = battle.monsterPool;
			_setBar = battle.setBar;
			_setBot = battle.setBot;
			_pause = battle.pause;
			_pauseBn = battle.pauseBn;
			_libBot = battle.libBot;
			//			_fight = battle.battleMenu.beginFight;
			closeInstruct = battle.instruction.gotIt;
			skip = battle.instruction.skip;
			
			LibBar.getInstance().close.addEventListener(MouseEvent.CLICK,onUnlib);
			_libBot.addEventListener(MouseEvent.CLICK,onLib);
			_pause.addEventListener(MouseEvent.CLICK,onPause);
			_pauseBn.addEventListener(MouseEvent.CLICK,onUnpause);
			_setBar.addEventListener(SceneChangeEvent.BACK_WORLD_SCENE,onQuit);
			_setBot.addEventListener(MouseEvent.CLICK,onSet);
			
			var dePanel :DefeatPanel = DefeatPanel.getInstance();
			dePanel.btnQuit.addEventListener(MouseEvent.CLICK,onQuit);
			dePanel.btnRestart.addEventListener(MouseEvent.CLICK,onRestartGame);
			
			battle.addEventListener(BattleEvent.BATTLE_FAIL,onBattleFail);
			battle.addEventListener(BattleEvent.CHECK_BATTLE_OVER,checkAndHandleVictory);
			Speed.getInstance().addEventListener(BattleEvent.BATTLE_SPEED,modifyGameSpped);
		}
		
		private function modifyGameSpped(e:BattleEvent):void
		{
			var value :Number = Number(e.data);
			timeTemp = int(50/value);
			TimerManager.getInstance().remove(AI);
			TimerManager.getInstance().add(timeTemp,AI);
		}
		
		
		protected function onBattleFail(event:Event):void
		{
			playBattleEffectSound();
			TimerManager.getInstance().remove(AI);
		}
		
		protected function onUnlib(event:MouseEvent):void
		{
			playBattleEffectSound();
			TimerManager.getInstance().add(timeTemp,AI);
			battle.onResumeGame();
		}
		
		protected function onLib(event:MouseEvent):void
		{
			playBattleEffectSound();
			TimerManager.getInstance().remove(AI);
			battle.onLib();
		}
		
		protected function onUnpause(event:MouseEvent):void
		{
			playBattleEffectSound();
			TimerManager.getInstance().add(timeTemp,AI);
			battle.onUnpause();
		}
		
		protected function onPause(event:MouseEvent):void
		{
			playBattleEffectSound();
			TimerManager.getInstance().remove(AI);
			battle.onPause()
		}
		
		protected function onSet(event:MouseEvent):void
		{
			playBattleEffectSound();
			battle.onSet();
			TimerManager.getInstance().remove(AI);
			
			_setBar.restart.addEventListener(MouseEvent.CLICK,onRestartGame);
			_setBar.resume.addEventListener(MouseEvent.CLICK,onResumeGame);
		}
		
		protected function onResumeGame(event:MouseEvent):void
		{
			playBattleEffectSound();
			TimerManager.getInstance().add(timeTemp,AI);
			battle.onResumeGame();
			_setBar.restart.removeEventListener(MouseEvent.CLICK,onRestartGame);
			_setBar.resume.removeEventListener(MouseEvent.CLICK,onResumeGame);
		}
		
		protected function onRestartGame(event:MouseEvent):void
		{
			VictoryPanel.getInstance().btnContinue.removeEventListener(MouseEvent.CLICK,onContineGame);
			VictoryPanel.getInstance().btnRestart.removeEventListener(MouseEvent.CLICK,onRestartGame);
			
			playBattleEffectSound();
			battle.back.visible = false;
			TimerManager.getInstance().add(timeTemp,AI);
			battle.dispose();
			var data:Object = new Object();
			data = _mapNum;
			dispatch(new SceneChangeEvent(SceneChangeEvent.TO_BATTLE_SCENE,data));
			_setBar.restart.removeEventListener(MouseEvent.CLICK,onRestartGame);
			_setBar.resume.removeEventListener(MouseEvent.CLICK,onResumeGame);
			
		}
		
		
		protected function onQuit(event:Event):void
		{
			playBattleEffectSound();
			battle.onQuit();
		}
		
		private function AI():void
		{
			var towerVo :TowerVo,tower :Tower,monster :Monster,k:int,i:int,j:int;
			
			
			for (j = 0; j < _monsters.length; j++) 
			{
				monster = _monsters[j];
				// 如果血量小于0，从数组删除
				//trace("编号为"+monster.monsterVo.id+"的怪物，剩下的血量为："+monster.monsterVo.blood);
				if(monster.monsterVo.blood <= 0)
				{
					
					if(monster.state != MonsterState.DIE)
					{
						hitNum++;
						trace("被打死的怪物:",hitNum);
						monster.removeEventListener(Event.COMPLETE, destroyMonster);
						monster.addEventListener(BattleEvent.DEAD_PALY_OVER,releasePool);
						monster.die();
						_monsters.splice(j,1);
						checkAndHandleVictory();//todo 这个检查当怪物跑到终点也应该有
						BattleScene.money += monster.monsterVo.money;
						battle.updateMoney();
					}
				}
			}
			
			
			for ( i = 0; i <_towers.length; i++) 
			{
				tower = _towers[i];
				towerVo = _towers[i].towerVo;//towerVo地址一样
				
				
				if(towerVo)
				{
					if(tower.towerType == TowerType.CANNON || tower.towerType == TowerType.ARROW || tower.towerType == TowerType.MAGIC )
					{
						//如果有血量，继续算法
						if(tower.newTower.state == TowerState.IDEL)
						{
							//有绑定怪物
							if(towerVo.bindMonster)
							{
								monster = towerVo.bindMonster;
								// 如果血量小于0，从数组删除
								if(monster.monsterVo.blood <= 0)
								{
									towerVo.bindMonster = null;
									break;
								}
								
								
								if((towerVo.attackRadius - getDistance(tower.registerX,tower.registerY,towerVo.bindMonster.x,towerVo.bindMonster.y))>10)//满足条件，开始攻击
								{
									
									tower.shoot();
								}else{
									towerVo.bindMonster = null;
								}
								
							}else{
								for ( k = 0; k < _monsters.length; k++) 
								{
									if(getDistance(tower.registerX,tower.registerY,_monsters[k].x,_monsters[k].y) < towerVo.attackRadius)
									{
										if(_monsters[k].monsterVo.isFlying && tower.towerType == TowerType.CANNON)
										{
											continue;
										}
										towerVo.bindMonster = _monsters[k];
										tower.shoot();
										break;
									}
								}
							}//绑定判断结束
						}//待攻击状态结束
					}//三种塔判断结束
					else if(tower.towerType == TowerType.SHIELD){
						var shiledTower :ShiledTower = tower.newTower as ShiledTower;
						var soilders :Vector.<Soldier> = shiledTower.soilders;
						var soilder :Soldier;
						for ( j = 0; j < soilders.length; j++) 
						{
							soilder = soilders[j];
							if(soilder.state == MonsterState.RUN)
							{
								if(soilder.bindMonster)
								{
									if(soilder.bindMonster.monsterVo.blood <= 0)
									{
										soilder.bindMonster = null;
										soilder.state = MonsterState.RUN;
										break;
									}
									
									//这儿还有血量判断
									if((getDistance(soilder.x,soilder.y,soilder.bindMonster.x,soilder.bindMonster.y))<=15)//满足条件，开始攻击
									{
										
										tower.shoot(j);
										soilder.bindMonster.fighting();
									}else{
										soilder.bindMonster = null;
										soilder.state = MonsterState.RUN;
									}
								}else{//没有，遍历寻找
									
									for ( k= 0; k < _monsters.length; k++) 
									{
										if(getDistance(soilder.x,soilder.y,_monsters[k].x,_monsters[k].y) < 15 && _monsters[k].monsterVo.isFlying==false)
										{
											
											soilder.bindMonster = _monsters[k];
											tower.shoot(j);
											soilder.bindMonster.fighting();
											break;
										}
									}
								}//if bindMonster
							}//if RUN
						}//for循环
						
					}//各种塔
				}//towerVo结束
			}//遍历结束
			
			battle.Render();
		}
		
		private function checkAndHandleVictory(e:Event=null):void
		{
			if(hitNum + battle.deadNum == _monsterNum)
			{
				
				SoundManager.getInstance().playEffectSound("sVictory");
				var data:int;
				if(battle.deadNum<4)
				{
					data = 3;
					VictoryPanel.getInstance().getThreeStar();
				}else if(battle.deadNum<11){
					data = 2;
					VictoryPanel.getInstance().getTwoStar();
				}else{
					data = 1;
					VictoryPanel.getInstance().getOneStar();
				}
				dispatch(new BattleEvent(BattleEvent.WIN_STARS,data));
				var viPanel :VictoryPanel = VictoryPanel.getInstance();
				battle.back.visible = true;
				viPanel.play();
				LayerCollection.uiLayer.addChild(viPanel);
				viPanel.x = 150;
				viPanel.y = -500;
				if(_mapNum != 12)
				{
					viPanel.btnContinue.addEventListener(MouseEvent.CLICK,onContineGame);
					viPanel.btnRestart.addEventListener(MouseEvent.CLICK,onRestartGame);
				}else{
					TimerManager.getInstance().add(4000,onEnd);
				}
				TweenLite.to(viPanel,.6,{y:0});
			}
		}		
		
		private function onEnd():void
		{
			TimerManager.getInstance().remove(onEnd);
			var fi :FinalScene = new FinalScene()
			LayerCollection.uiLayer.addChild(fi);
			fi.x = -425;
			fi.y = -10;
		}
		
		protected function onContineGame(event:MouseEvent):void
		{
			VictoryPanel.getInstance().btnContinue.removeEventListener(MouseEvent.CLICK,onContineGame);
			VictoryPanel.getInstance().btnRestart.removeEventListener(MouseEvent.CLICK,onRestartGame);
			
			playBattleEffectSound();
			battle.back.visible = false;
			TimerManager.getInstance().add(timeTemp,AI);
			battle.dispose();
			var data:Object = new Object();
			(_mapNum!=12)  && (_mapNum++);
			data = _mapNum;
			dispatch(new SceneChangeEvent(SceneChangeEvent.TO_BATTLE_SCENE,data));
			_setBar.restart.removeEventListener(MouseEvent.CLICK,onRestartGame);
			_setBar.resume.removeEventListener(MouseEvent.CLICK,onResumeGame);
		}		
		
		private function releasePool(event:Event):void
		{
			var monster :Monster = event.target as Monster;
			monster.removeEventListener(BattleEvent.DEAD_PALY_OVER,releasePool);
			_monsterPool.releaseObject(monster);
			
		}
		
		//走完了-------
		private function destroyMonster(monster:Monster):void
		{
			if(monster.state != MonsterState.DIE)
			{
				hitNum++;
				trace("被打死的怪物:",hitNum);
				monster.removeEventListener(Event.COMPLETE, destroyMonster);
				monster.die();
				_monsters.splice(_monsters.indexOf(monster),1);
				_monsterPool.releaseObject(monster);
			}
		}
		
		
		
		private function getDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			return Math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
		}
		
		//退出战斗地图
		private function toWorld(e:Event):void
		{
			battle.visible = false;
			dispose();
			dispatch(new SceneChangeEvent(SceneChangeEvent.BACK_WORLD_SCENE));
		}
		
		private function dispose():void
		{
			timeTemp = 50;
			TimerManager.getInstance().remove(AI);
			battle.dispose();
			
		}
		
		private function toBattle(e:SceneChangeEvent):void
		{
			//重置一些变量
			hitNum = 0;
			
			var playerInfo :ChapterPlayerVo;
			
			removeContextListener(SceneChangeEvent.FIRST_TO_BATTLE_SCENE,toBattle,SceneChangeEvent);
			_mapNum = int(e.data);
			trace("初始化地图",_mapNum,chapterModel.monsterChapterVos.length);
			if(battle)
			{
				battle.visible = true;
				playBattleBgSound();
				Speed.getInstance().init();
				switch(_mapNum)
				{
					case 1:
					{
						closeInstruct.addEventListener(MouseEvent.CLICK,onCloseInstruct);
						skip.addEventListener(MouseEvent.CLICK,onCloseInstruct);
						battle.instruction.init();
						battle.back.visible = true;
						SoundManager.getInstance().playEffectSound("sBird");
						battle.createMap1();
						battle.initMonster(1,lineModel.line1,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[0];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 2:
					{
						battle.createMap2();
						battle.initMonster(2,lineModel.line2,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[1];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 3:
					{
						battle.createMap3();
						battle.initMonster(3,lineModel.line3,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[2];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 4:
					{
						battle.createMap4();
						battle.initMonster(4,lineModel.line4,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[3];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 5:
					{
						battle.createMap5();
						battle.initMonster(5,lineModel.line5,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[4];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 6:
					{
						battle.createMap6();
						battle.initMonster(6,lineModel.line6,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[5];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 7:
					{
						battle.createMap7();
						battle.initMonster(7,lineModel.line7,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[6];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 8:
					{
						battle.createMap8();
						battle.initMonster(8,lineModel.line8,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[7];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 9:
					{
						battle.createMap9();
						battle.initMonster(9,lineModel.line9,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[8];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 10:
					{
						battle.createMap10();
						battle.initMonster(10,lineModel.line10,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[9];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 11:
					{
						battle.createMap11();
						battle.initMonster(11,lineModel.line11,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[10];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
					case 12:
					{
						battle.createMap12();
						battle.initMonster(12,lineModel.line12,chapterModel.monsterChapterVos);
						playerInfo = chapterConfigModel.chapPlayers[11];
						battle.initPlayerInfo(playerInfo.life,playerInfo.money,0,playerInfo.wave);
						break;
					}
				}
				_monsterNum = chapterModel.monsterChapterVos.length;
				TimerManager.getInstance().add(timeTemp,AI);
			}
		}
		
		protected function onCloseInstruct(event:MouseEvent):void
		{
			battle.back.visible = false;
			battle.instruction.close();
			closeInstruct.removeEventListener(MouseEvent.CLICK,onCloseInstruct);
			skip.removeEventListener(MouseEvent.CLICK,onCloseInstruct);
		}
		public function playBattleBgSound():void
		{
			SoundManager.getInstance().playBgSound("bg8",1);
		}
		public function playBattleEffectSound():void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
		}
		private function onQuality(e:BattleEvent):void
		{
			var num:int = e.data.id;
			if(num == 1){
				contextView.stage.quality = StageQuality.LOW;
			}else if(num == 2){
				contextView.stage.quality = StageQuality.MEDIUM;
			}else if(num == 3){
				contextView.stage.quality = StageQuality.HIGH;
			}
		}
	}
}