package game.view.scene
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import game.event.SceneChangeEvent;
	import game.view.scene.ui.battle.DefeatPanel;
	import game.view.scene.ui.battle.VictoryPanel;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.EnhancedProgressEvent;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	public class InitScene extends Sprite
	{
		private var playBot:SimpleButton;
		private var loginBG:MovieClip;
		private var progressTxt:TextField;
		private var tipTxt:TextField;
		private var progressBar:MovieClip;
		private var _width:Number;
		private var _monster :MovieClip;
		
		private var roleBitmap:BitmapMovie;
		public function InitScene()
		{
			trace("加载场景");
			LoaderManager.getInstance().getModualSwf("assets/loadingScene.swf",initLogin);
			
		}
		
		private function initLogin():void
		{
			loginBG = ClassManager.createInstance("loginMc") as MovieClip;
			addChild(loginBG);
			playBot = loginBG.playBot;
			progressBar = loginBG.progress;
			progressTxt = loginBG.jinDu;
			tipTxt = loginBG.tishi;
			_monster = loginBG.monster;
			playBot.visible = false;
			_width = progressBar.width;
			LoaderManager.getInstance().addEventListener(ProgressEvent.PROGRESS,onProgress);
			beginLoad();
			
		}
		
		protected function onProgress(event:EnhancedProgressEvent):void
		{
			
			
			
			switch(event.resType)
			{
				case "res/commom/tower.xml":
				{
					progressBar.width = 0.2*_width ;
					progressTxt.text = "小贴士：重邮01团队研发";
					tipTxt.text = "几十关看的我眼晕啊，有木有???";
					break;
				}
				case "assets/magicBullect.swf":
				{
					progressBar.width = 0.4*_width ;
					progressTxt.text = "小贴士：好好学习，多打代码";
					tipTxt.text = "几十关看的我眼晕啊，有木有???";
					break;
				}
				case "assets/soldier1.swf":
				{
					progressBar.width = 0.6*_width ;
					progressTxt.text = "小贴士：升级是最好的防御";
					tipTxt.text = "几十关看的我眼晕啊，有木有???";
					break;
				}
				case "assets/battleMenu.swf":
				{
					progressBar.width = 0.8*_width ;
					progressTxt.text = "小贴士：援兵是阻挡金工的最佳选择";
					tipTxt.text = "关卡还在不断更新啊，有木有???";
					break;
				}
				case "assets/mapElement.swf":
				{
					progressBar.width = _width ;
					progressTxt.text = "小贴士：成就系统给你意外惊喜";
					tipTxt.text = "关卡还在不断更新啊，有木有???";
					break;
				}
				default:
				{
					break;
				}
			}
			
		}
		private function beginLoad():void
		{
			LoaderManager.getInstance().getXml("res/commom/tower.xml",null,true);
			LoaderManager.getInstance().getXml("res/commom/monster.xml",null,true);
			LoaderManager.getInstance().getXml("res/chapterConfig/chapterPlayer.xml",null,true);
			LoaderManager.getInstance().getXml("res/chapterConfig/chapterMonster.xml",null,true);
			LoaderManager.getInstance().getXml("res/chapterConfig/chapterLine.xml",null,true);
			LoaderManager.getInstance().getMovieClip("assets/magicBullect.swf",new BitmapMovie(),true);
			LoaderManager.getInstance().getMovieClip("assets/arrow.swf",new BitmapMovie(),true);
			LoaderManager.getInstance().getModualSwf("assets/sound.swf");
			LoaderManager.getInstance().getModualSwf("assets/blood.swf");
			LoaderManager.getInstance().getModualSwf("assets/blood1.swf");
			LoaderManager.getInstance().getModualSwf("assets/instructionsPanel1.swf");
			LoaderManager.getInstance().getModualSwf("assets/battleElement.swf");
			LoaderManager.getInstance().getModualSwf("assets/upTowerCicle.swf");
			LoaderManager.getInstance().getModualSwf("assets/circleMenuBtn.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster110.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster120.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster130.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster140.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster150.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster210.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster220.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster230.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster240.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster250.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster801.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster802.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster803.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster901.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster902.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster903.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster9366.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster9763.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster10087.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster10331.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster10507.swf");
			LoaderManager.getInstance().getModualSwf("assets/monster/monster10812.swf");
			LoaderManager.getInstance().getModualSwf("assets/cannon1.swf");
			LoaderManager.getInstance().getModualSwf("assets/cannon2.swf");
			LoaderManager.getInstance().getModualSwf("assets/cannon3.swf");
			LoaderManager.getInstance().getModualSwf("assets/soldier1.swf");
			LoaderManager.getInstance().getModualSwf("assets/soldier2.swf");
			LoaderManager.getInstance().getModualSwf("assets/soldier3.swf");
			LoaderManager.getInstance().getModualSwf("assets/soldier4.swf");
			LoaderManager.getInstance().getModualSwf("assets/magic4.swf");
			LoaderManager.getInstance().getModualSwf("assets/magic2.swf");
			LoaderManager.getInstance().getModualSwf("assets/arrow1.swf");
			LoaderManager.getInstance().getModualSwf("assets/arrow2.swf");
			LoaderManager.getInstance().getModualSwf("assets/arrow3.swf");
			LoaderManager.getInstance().getModualSwf("assets/arrow4.swf");
			LoaderManager.getInstance().getModualSwf("assets/quickly.swf");
			LoaderManager.getInstance().getModualSwf("assets/victoryPanel.swf");
			LoaderManager.getInstance().getModualSwf("assets/defeatPanel.swf");
			LoaderManager.getInstance().getModualSwf("assets/buildingBase.swf");
			LoaderManager.getInstance().getModualSwf("assets/cannonBullet.swf");
			LoaderManager.getInstance().getModualSwf("assets/juqingBar.swf");
			LoaderManager.getInstance().getModualSwf("assets/playerInfo.swf");
			LoaderManager.getInstance().getModualSwf("assets/setthingBar.swf");
			LoaderManager.getInstance().getModualSwf("assets/settingBut.swf");
			LoaderManager.getInstance().getModualSwf("assets/lvUpPlane.swf");
			LoaderManager.getInstance().getModualSwf("assets/activated.swf");
			LoaderManager.getInstance().getModualSwf("assets/achievement.swf");
			LoaderManager.getInstance().getModualSwf("assets/libPlane.swf");
			LoaderManager.getInstance().getModualSwf("assets/battleMenu.swf");
			LoaderManager.getInstance().getModualSwf("assets/miniBattleMap.swf");
			LoaderManager.getInstance().getModualSwf("assets/miniBattleMap.swf");
			LoaderManager.getInstance().getModualSwf("assets/worldScene.swf");
			LoaderManager.getInstance().getModualSwf("assets/mainScene.swf");
			LoaderManager.getInstance().getModualSwf("assets/mapElement.swf",onLoadedComplete);
		}
		
		private function onLoadedComplete():void
		{
			LoaderManager.getInstance().removeEventListener(ProgressEvent.PROGRESS,onProgress);
			//			dispatchEvent(new Event(SceneChangeEvent.TO_LOGIN_SCENE));
			createRole();
			playBot.addEventListener(MouseEvent.CLICK,onPlay);
			
		}
		
		private function createRole():void
		{
			var role :MovieClip = ClassManager.createInstance("Default901") as MovieClip;
			roleBitmap = LoaderManager.getInstance().changeMcToBitmapMovie(role,true,"DEfault901");
			roleBitmap.scaleX = -1;
			addChild(roleBitmap);
			roleBitmap.x = 300;roleBitmap.y=350;
			roleBitmap.gotoAndPlay(1,true,1,23);
			
			TimerManager.getInstance().add(50,onFile);
		}
		
		private function onFile():void
		{
			roleBitmap.x -= 4;
			if(roleBitmap.x == 148)
			{
				SoundManager.getInstance().playEffectSound("sFire");
				TimerManager.getInstance().remove(onFile);
				roleBitmap.gotoAndPlay(24,false,24,70,onFileEnd);
			}
		}
		
		private function onFileEnd():void
		{
			SoundManager.getInstance().playEffectSound("dead5");
			loginBG.removeChild(_monster);
			playBot.visible = true;
		}
		
		private function onPlay(event:MouseEvent):void
		{
			trace("点击Play");
			SoundManager.getInstance().playEffectSound("mouseClick",1);   
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.TO_MIAN_SCENE));
			removeChild(loginBG);
		}
	}
}