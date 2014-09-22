package game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import qmang2d.protocol.LayerCollection;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.StageProxy;

	public class BattleMenuPanel extends Sprite
	{
		//战斗的菜单
		public var fightMenu:MovieClip;
		public var beginFight:SimpleButton;
		public var fire:SimpleButton;
		public var lightning:SimpleButton;
		public var zhiyuan:SimpleButton;
		public var startBattle :MovieClip;
		
		public function BattleMenuPanel()
		{
			//战斗菜单初始化
			fightMenu = ClassManager.createInstance("battleMenu") as MovieClip;
			addChild(fightMenu);
			fightMenu.x = StageProxy.width*0.25;
			fightMenu.y = StageProxy.height-65;
			
			beginFight = fightMenu.begin;
			lightning = fightMenu.lightning;
			zhiyuan = fightMenu.zhiyuan;
			fire = fightMenu.fire;
			startBattle = fightMenu.startBattle;
		}
	}
}