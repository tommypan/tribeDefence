package game.view.scene
{
	import com.gs.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import game.event.SceneChangeEvent;
	import game.view.scene.ui.world.AchieveBar;
	import game.view.scene.ui.world.JihuoBar;
	import game.view.scene.ui.world.LibBar;
	import game.view.scene.ui.world.LvUpBar;
	import game.view.scene.ui.world.PathNode;
	import game.view.scene.ui.world.ScenarioBar;
	import game.view.scene.ui.world.StarPathNode;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.StageProxy;
	
	public class WorldScene extends Sprite
	{
		
		/**当前关卡数*/
		private var _curNum :int = -1;
		
		/**主文件*/
		private var mainMc:MovieClip;
		
		/**路点*/
		private var pathMc:MovieClip;
		
		/**星星路牌*/
		private var starNode:StarPathNode;
		
		/**路牌*/
		private var node :PathNode;
		
		/**星星文本*/
		public var starNum:int=30;
		public var starTxt:TextField;
		
		private var _startBattle:MovieClip;
		//五个主按钮*/
		public var caiDanBtn :SimpleButton;
		public var lvUpBtn:SimpleButton;
		public var achiveBtn:SimpleButton;
		public var libBtn:SimpleButton;
		public var jiHuoBtn:SimpleButton;
		//UI面板
		/**剧情面板*/
		public var scenarioBar:ScenarioBar;
		/**升级面板*/
		public var lvUpBar:LvUpBar;
		/**激活面板*/
		private var jiHuoBar:JihuoBar;
		/**资料库*/
		private var libBar:LibBar;
		/**成就面板*/
		private var achieveBar:AchieveBar;
		public function WorldScene()
		{
			onTest();
			//ExternalInterface.call("speakTTS","hello my name is tommy");
			
		}
		
		private function onTest():void
		{
			SoundManager.getInstance().playBgSound("bg5",1);
			mainMc = ClassManager.createInstance("worldMainMc") as MovieClip;
			addChild(mainMc);
			starTxt = mainMc.starTxt;
			starTxt.text = starNum+"/99";
			caiDanBtn = mainMc.caiDanBtn;
			lvUpBtn = mainMc.lvUpBtn;
			achiveBtn = mainMc.achiveBtn;
			libBtn = mainMc.libBtn;
			jiHuoBtn = mainMc.jiHuoBtn;
			
			caiDanBtn.addEventListener(MouseEvent.CLICK,onCaidan);
			lvUpBtn.addEventListener(MouseEvent.CLICK,onLvUp);
			achiveBtn.addEventListener(MouseEvent.CLICK,onAchive);
			libBtn.addEventListener(MouseEvent.CLICK,onLib);
			jiHuoBtn.addEventListener(MouseEvent.CLICK,onJiHuo);
			huanDong();
			_startBattle = ClassManager.createInstance("startBattle") as MovieClip;
			
			pathMc = mainMc.worldPathMc as MovieClip;
			pathMc.gotoAndStop(1);
			
			//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
			//			var i: int;
			//			function onDown(event:KeyboardEvent):void
			//			{
			//			setMapNum(i,1);
			//				i++;
			//				
			//			}
			//			_curNum=11;
			setMapNum(0,1);
			setMapNum(1,1);
			setMapNum(2,1);
			setMapNum(3,1);
			setMapNum(4,1);
			setMapNum(5,1);
			setMapNum(6,1);
			setMapNum(7,1);
			setMapNum(8,1);
			setMapNum(9,1);
			setMapNum(10,1);
			setMapNum(11,1);
			setMapNum(12,1);
			
			scenarioBar = new ScenarioBar();
			scenarioBar.x = 330;scenarioBar.y = 200;
			addChild(scenarioBar);
			scenarioBar.visible = false;
			scenarioBar.alpha = 0;
			
			lvUpBar = new LvUpBar(30);
			lvUpBar.x = 350;lvUpBar.y = -500;
			addChild(lvUpBar);
			
			jiHuoBar = new JihuoBar();
			jiHuoBar.x = 310;jiHuoBar.y = -500;
			addChild(jiHuoBar);
			
			libBar =  LibBar.getInstance();
			
			
			achieveBar = new AchieveBar();
			addChild(achieveBar);
			achieveBar.x = 350; achieveBar.y = -500;
		}
		public function huanDong():void{
			lvUpBtn.alpha = achiveBtn.alpha = libBtn.alpha = jiHuoBtn.alpha = caiDanBtn.alpha = 0;
			lvUpBtn.y = achiveBtn.y = libBtn.y = jiHuoBtn.y = caiDanBtn.y = 400;
			TweenLite.to(caiDanBtn,1,{alpha:1,y:500});
			TweenLite.to(lvUpBtn,1,{alpha:1,y:500});
			TweenLite.to(achiveBtn,1,{alpha:1,y:500});
			TweenLite.to(libBtn,1,{alpha:1,y:500});
			TweenLite.to(jiHuoBtn,1,{alpha:1,y:500});
		}
		
		protected function onJiHuo(event:MouseEvent):void
		{
			playWorldEffectSound();
			jiHuoBar.huanDong();
			
		}
		
		protected function onLib(event:MouseEvent):void
		{
			playWorldEffectSound();
			addChild(libBar);
			libBar.x = 350;libBar.y = -500;
			libBar.huanDong();
		}
		
		protected function onAchive(event:MouseEvent):void
		{
			playWorldEffectSound();
			achieveBar.huanDong();
		}
		
		private function onLvUp(event:MouseEvent):void
		{
			playWorldEffectSound();
			lvUpBar.huanDong();
			lvUpBar.init();
		}
		
		private function onCaidan(event:MouseEvent):void
		{
			trace("点击返回主菜单");
			playWorldEffectSound();
			//各种面板打开了的需要关闭
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.BACK_MAIN_SCENE));
			
		}		
		
		/**
		 * 默认为第一关，从零开始
		 * @param num
		 * @param stars
		 * 
		 */		
		public function setMapNum(num:int,stars:int):void
		{
			_curNum++;
			if(_curNum != num)
			{
				throw new IllegalOperationError("设置关卡数与实际不匹配(-.-)");
			}else{
				node = PathNode.getInstance();
				addChild(node);
				addChild(_startBattle);
				
				if(num == 0)
				{
					pathMc.gotoAndStop(1);//0
					
					node.x = 100;node.y = 418;
					node.name = "1";
					node.addEventListener(MouseEvent.CLICK,onStartBattleBar);
					
					_startBattle.x = 30;_startBattle.y = 380;
				}else if(num == 1){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "1";
					node.name = "2";
					pathMc.gotoAndStop(18);//0
					starNode.x = 100;starNode.y = 418;
					node.x = 100;node.y = 365;
					_startBattle.x = 30;_startBattle.y = 330;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
					
				}else if(num == 2){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "2";
					node.name = "3";
					pathMc.gotoAndStop(34);//1
					starNode.x = 90;starNode.y = 358;
					node.x = 146;node.y = 338;
					_startBattle.x = 76;_startBattle.y = 300;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 3){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "3";
					node.name = "4";
					pathMc.gotoAndStop(53);//2
					starNode.x = 146;starNode.y = 338;
					node.x = 202;node.y = 312;
					_startBattle.x = 132;_startBattle.y = 274;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 4){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "4";
					node.name = "5";
					pathMc.gotoAndStop(81);//3
					starNode.x = 202;starNode.y = 312;
					node.x = 155;node.y = 232;
					_startBattle.x = 85;_startBattle.y = 195;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 5){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "5";
					node.name = "6";
					pathMc.gotoAndStop(109);//4
					starNode.x = 155;starNode.y = 232;
					node.x = 145;node.y = 130;
					_startBattle.x = 75;_startBattle.y = 97;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 6){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "6";
					node.name = "7";
					pathMc.gotoAndStop(146);//5
					starNode.x = 145;starNode.y = 130;
					node.x = 278;node.y = 67;
					_startBattle.x = 205;_startBattle.y = 30;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 7){
					starNode = new StarPathNode();
					addChild(starNode);
					starNode.name = "7";
					pathMc.gotoAndStop(159);//6
					node.name = "8";
					starNode.x = 278;starNode.y = 67;
					node.x = 358;node.y = 60;
					_startBattle.x = 288;_startBattle.y = 22;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 8){
					starNode = new StarPathNode();
					removeChild(_startBattle);
					addChild(starNode);
					starNode.name = "8";
					node.name = "9";
					addChild(_startBattle);
					pathMc.gotoAndStop(175);//7
					starNode.x = 358;starNode.y = 60;
					node.x = 438;node.y = 95;
					_startBattle.x = 368;_startBattle.y = 60;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 9){
					starNode = new StarPathNode();
					removeChild(_startBattle);
					addChild(starNode);
					addChild(_startBattle);
					starNode.name = "9";
					node.name = "10";
					pathMc.gotoAndStop(200);//8
					starNode.x = 438;starNode.y = 95;
					node.x = 528;node.y = 148;
					_startBattle.x = 458;_startBattle.y = 110;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 10){
					starNode = new StarPathNode();
					removeChild(_startBattle);
					addChild(starNode);
					addChild(_startBattle);
					starNode.name = "10";
					node.name = "11";
					pathMc.gotoAndStop(225);//9
					starNode.x = 528;starNode.y = 148;
					node.x = 528;node.y = 238;
					_startBattle.x = 458;_startBattle.y = 200;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 11){
					starNode = new StarPathNode();
					removeChild(_startBattle);
					addChild(starNode);
					addChild(_startBattle);
					starNode.name = "11";
					node.name = "12";
					pathMc.gotoAndStop(250);//10
					starNode.x = 528;starNode.y = 238;
					node.x = 548;node.y = 328;
					_startBattle.x = 478;_startBattle.y = 290;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
				}else if(num == 12){
					starNode = new StarPathNode();
					removeChild(_startBattle);
					addChild(starNode);
					starNode.name = "12";
					pathMc.gotoAndStop(250);//11
					starNode.x = 548;starNode.y = 328;
					starNode.addEventListener(MouseEvent.CLICK,onStartBattleBar);
					removeChild(node);
				}
			}
		}
		
		private var currMap:int = 1;
		private function onStartBattleBar(event:MouseEvent):void
		{
			playWorldEffectSound();
			currMap = int(event.currentTarget.name);
			scenarioBar.changeLv(currMap);
			scenarioBar.huanDong();
			scenarioBar.addEventListener(SceneChangeEvent.TO_BATTLE_SCENE,onStartBattle);
			
			
		}		
		
		protected function onStartBattle(event:SceneChangeEvent):void
		{
			scenarioBar.removeEventListener(SceneChangeEvent.TO_BATTLE_SCENE,onStartBattle);
			scenarioBar.visible = false;
			trace("进入第",currMap,"关");
			var data:Object = new Object();
			data.id = currMap;
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.TO_BATTLE_SCENE,data));
			
		}
		public function playWorldEffectSound():void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
		}
	}
}