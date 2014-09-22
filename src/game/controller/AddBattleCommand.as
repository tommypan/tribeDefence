package game.controller
{
	import game.event.SceneChangeEvent;
	import game.model.ChapterConfigModel;
	import game.model.ChapterModel;
	import game.model.LineModel;
	import game.model.MonsterModel;
	import game.model.PlayerModel;
	import game.model.TowerModel;
	import game.model.vo.ChapterMonsterVo;
	import game.model.vo.MonsterVo;
	import game.view.mediator.BattleSceneMediator;
	import game.view.scene.BattleScene;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddBattleCommand extends Command
	{
		[Inject]
		public var towerModel :TowerModel; //type level.这个不需要进行匹配
		
		[Inject]
		public var playerModel :PlayerModel; //不需要进行匹配
		
		[Inject]
		public var chapterConfigModel :ChapterConfigModel; //monster,line与chapter需要匹配：(线路id，monsterId,monsterLevel)章节chap
		
		[Inject]
		public var monsterModel :MonsterModel;
		
		[Inject]
		public var chapterModel :ChapterModel;//进行匹配后的数据存放地
		
		[Inject]
		public var lineModel :LineModel;
		
		[Inject]
		public var e :SceneChangeEvent;
		
		private static var isFrirst:Boolean= false;
		private var battle:BattleScene;
		
		public function AddBattleCommand()
		{
			
		}
		
		override public function execute():void
		{
			
			chapterModel.removeAll();
			
			matchModel(int(e.data));
			
			trace("进入战斗界面");
			if(isFrirst == false)
			{
				isFrirst = true;
				mediatorMap.mapView(BattleScene,BattleSceneMediator);
				battle= new BattleScene(towerModel.towerVos);
				contextView.addChild(battle);
				dispatch( new SceneChangeEvent(SceneChangeEvent.FIRST_TO_BATTLE_SCENE,e.data));
			}
			
		}
		
		private function matchModel(num:int):void
		{
			var chaps :Vector.<ChapterMonsterVo>;
			
			switch(num)
			{
				case 1:
				{
					chaps = chapterConfigModel.chap1s;
					break;
				}
				case 2:
				{
					chaps = chapterConfigModel.chap2s;
					break;
				}
				case 3:
				{
					chaps = chapterConfigModel.chap3s;
					break;
				}
				case 4:
				{
					chaps = chapterConfigModel.chap4s;
					break;
				}
				case 5:
				{
					chaps = chapterConfigModel.chap5s;
					break;
				}
				case 6:
				{
					chaps = chapterConfigModel.chap6s;
					break;
				}
				case 7:
				{
					chaps = chapterConfigModel.chap7s;
					break;
				}
				case 8:
				{
					chaps = chapterConfigModel.chap8s;
					break;
				}
				case 9:
				{
					chaps = chapterConfigModel.chap9s;
					break;
				}
				case 10:
				{
					chaps = chapterConfigModel.chap10s;
					break;
				}
				case 11:
				{
					chaps = chapterConfigModel.chap11s;
					break;
				}
				case 12:
				{
					chaps = chapterConfigModel.chap12s;
					break;
				}
					
			}
			
			var len :uint = chaps.length;
			var monsterCfg :Vector.<MonsterVo> = monsterModel.monsterVos;
			var len1 :uint = monsterCfg.length;
			var monsterVo :MonsterVo;
			var copyMonster :MonsterVo;
			for (var i:int = 0; i < len; i++) 
			{
				for (var j:int = 0; j < len1; j++) 
				{
					if(chaps[i].monsterType ==monsterCfg[j].type && chaps[i].monsterLevel == monsterCfg[j].level)
					{
						copyMonster = monsterCfg[j];
						monsterVo = new MonsterVo();
						monsterVo.money = copyMonster.money;
						monsterVo.attackPower = copyMonster.attackPower;
						monsterVo.blood = copyMonster.blood;
						monsterVo.defencePower = copyMonster.defencePower;
						monsterVo.describe = copyMonster.describe;
						monsterVo.level = copyMonster.level;
						monsterVo.lineId = chaps[i].lineId;
						monsterVo.reflectName= copyMonster.reflectName;
						monsterVo.speed = copyMonster.speed;
						monsterVo.isFlying = copyMonster.isFlying;
						monsterVo.type = copyMonster.type;
						monsterVo.time = chaps[i].time;
						monsterVo.wave = chaps[i].wave;
						monsterVo.id = chaps[i].id;
						chapterModel.addEnemy(monsterVo);
					}
				}
				
			}
			
		}
		
	}
}