package  game.view.tower
{
	import com.gs.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.media.Sound;
	
	import game.event.TowerEvent;
	import game.model.vo.TowerVo;
	import game.view.events.ViewBus;
	import game.view.events.ViewEvent;
	import game.view.scene.BattleScene;
	import game.view.scene.ui.battle.BuildingBase;
	import game.view.scene.ui.battle.CicleMenu;
	import game.view.scene.ui.battle.PlayerInfo;
	
	import qmang2d.pool.interfaces.IPool;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	
	
	/**
	 *塔防池
	 * <p>采用引擎对象池处理技术，提升效率 
	 * @author panhao
	 * 
	 */	
	public class Tower extends Sprite implements IPool
	{
		private var _towerPool :MovieClip;
		private var _glowFilter :GlowFilter;
		
		//-------------与初始圈圈相关
		private var _cicle:CicleMenu;
		private var _arrow :SimpleButton;
		private var _shield :SimpleButton;
		private var _magic :SimpleButton;
		private var _cannon :SimpleButton;
		
		//------------后面的升级圈圈
		private var _upgradeBtn:MovieClip;
		private var _sellBtn :MovieClip;
		
		
		private var _isClick :Boolean;
		
		public var towerType :String;
		
		
		//大炮，魔法，弓箭的状态
		public var newTower:BaseTower;
		public var towerVo :TowerVo;
		public var registerX :Number;
		public var registerY :Number;
		
		//预存下来，卖塔时有用
		private var _bootMoney1 :int;
		private var _bootMoney2 :int;
		private var _bootMoney3 :int;
		private var _bootMoney4 :int;
		
		public function Tower()
		{
			_towerPool = ClassManager.createDisplayObjectInstance("towerPool") as MovieClip;
			addChild(_towerPool);
			_towerPool.buttonMode = true;
			_towerPool.mouseChildren = false;
			
			
			_glowFilter = new GlowFilter();
			_glowFilter.color = 0xffff00;
			
			
			
			//初始化塔防圈圈 
			_cicle = new CicleMenu();
		}
		
		/**
		 *更新塔防 
		 * @param towerVo更新后的vo属性
		 * 
		 */		
		public function updateTower($towerVo:TowerVo):void
		{
			towerVo = new TowerVo();
			towerVo.attackPowerMax = $towerVo.attackPowerMax;
			towerVo.attackPowerMin = $towerVo.attackPowerMin;
			towerVo.attackRadius = $towerVo.attackRadius;
			towerVo.bindMonster = $towerVo.bindMonster;
			towerVo.bootMoney = $towerVo.bootMoney;
			towerVo.buildTime = $towerVo.buildTime;
			towerVo.coolTime = $towerVo.coolTime;
			towerVo.isAttackFlying = $towerVo.isAttackFlying;
			towerVo.soilderAttackRadius = $towerVo.soilderAttackRadius;
			towerVo.soilderDefencePower = $towerVo.soilderDefencePower;
			//towerVo = $towerVo;
		}
		
		
		/**
		 *stop the animation and remove all listeners
		 * <p>it did not kill the memory cause  we would use  pool to solve the problem
		 * 
		 */		
		public function sleep():void
		{
			
			_bootMoney1 = 0;
			_bootMoney2 = 0;
			_bootMoney3 = 0;
			_bootMoney4 = 0;
			
			
			contains(_towerPool) && removeChild(_towerPool);
			LayerCollection.uiLayer.contains(_cicle) 
				&& LayerCollection.uiLayer.removeChild(_cicle);
			
			if(newTower && contains(newTower)) 
			{
				newTower.dispose();
				removeChild(newTower);
				newTower = null;
			}
			
			_cicle.dispose();
			
			towerType = "";
			towerVo = null;
			registerX = 0;
			registerY = 0;
			
			_towerPool.removeEventListener(MouseEvent.CLICK, onClickTowerPool);
			_towerPool.removeEventListener(MouseEvent.MOUSE_OVER, onOverTowerPool);
			_towerPool.removeEventListener(MouseEvent.MOUSE_OUT, onOutTowerPool);
			
			_arrow.removeEventListener(MouseEvent.CLICK, onBuildTower);
			_shield.removeEventListener(MouseEvent.CLICK, onBuildTower);
			_magic.removeEventListener(MouseEvent.CLICK, onBuildTower);
			_cannon.removeEventListener(MouseEvent.CLICK, onBuildTower);
			ViewBus.instance.removeEventListener(ViewBus.HIDE_TOWER,hideCicle);
		}
		
		
		
		/**
		 * start the animation and add all listeners
		 * 
		 */		
		public function wakeUp():void
		{
			_cicle.initTower();
			_arrow = _cicle.arrow;
			_cannon = _cicle.cannon;
			_magic = _cicle.magic;
			_shield = _cicle.shield;
			_arrow.addEventListener(MouseEvent.CLICK, onBuildTower);
			_shield.addEventListener(MouseEvent.CLICK, onBuildTower);
			_magic.addEventListener(MouseEvent.CLICK, onBuildTower);
			_cannon.addEventListener(MouseEvent.CLICK, onBuildTower);
			
			
			addChild(_towerPool);
			_towerPool.addEventListener(MouseEvent.CLICK, onClickTowerPool);
			_towerPool.addEventListener(MouseEvent.MOUSE_OVER, onOverTowerPool);
			_towerPool.addEventListener(MouseEvent.MOUSE_OUT, onOutTowerPool);
			
			_arrow.addEventListener(MouseEvent.CLICK, onBuildTower);
			_shield.addEventListener(MouseEvent.CLICK, onBuildTower);
			_magic.addEventListener(MouseEvent.CLICK, onBuildTower);
			_cannon.addEventListener(MouseEvent.CLICK, onBuildTower);
			ViewBus.instance.addEventListener(ViewBus.HIDE_TOWER,hideCicle);
		}
		
		/**
		 * 
		 * 只是涉及到渲染表现问题，故vo属性还是保留在此对象
		 */		
		public function shoot(soilderIndex:int=0/*x_:Number,y_:Number*/):void
		{
			if(newTower) 
			{
				
				if(towerType != TowerType.SHIELD)
				{
					newTower.readyShoot(towerVo);
				}else{
					ShiledTower(newTower).fightting(soilderIndex);
				}
			}
			
		}
		
		
		/**
		 *颜色样式 ，请在初始化结束后进行设置
		 * @param colorForm若为1，则在绿色地图上使用；若为2，则在白色地图上使用；若为3，则在黑色地图上使用
		 * 
		 */			
		public function setColorForm(colorForm :int):void
		{
			_towerPool.gotoAndStop(colorForm);
		}
		
		/**
		 *建塔地基
		 * @param event
		 * 
		 */		
		private function onBuildTower(event:MouseEvent):void
		{
			var base :BuildingBase;
			SoundManager.getInstance().playEffectSound("sBuild");
			switch(event.target.name)
			{
				case "arrow":
				{
					BattleScene.money -= 70;
					_bootMoney1 = 70;
					base = new BuildingBase("arrowBase",1);
					addChild(base);
					base.addEventListener(Event.COMPLETE, onCompleteBuildTower);
					towerType = TowerType.ARROW;
					break;
				}
					
				case "cannon":
				{
					BattleScene.money -= 150;
					_bootMoney1 = 150;
					base  = new BuildingBase("cannonBase",1);
					addChild(base);
					base.addEventListener(Event.COMPLETE, onCompleteBuildTower);
					towerType = TowerType.CANNON;
					break;
				}
					
				case "shield":
				{
					BattleScene.money -= 70;
					_bootMoney1 = 70;
					base  = new BuildingBase("shiledBase",1);
					addChild(base);
					base.addEventListener(Event.COMPLETE, onCompleteBuildTower);
					towerType = TowerType.SHIELD;
					break;
				}
					
				case "magic":
				{
					BattleScene.money -= 100;
					_bootMoney1 = 100;
					base  = new BuildingBase("magicBase",1);
					addChild(base);
					base.addEventListener(Event.COMPLETE, onCompleteBuildTower);
					towerType = TowerType.MAGIC;
					break;
				}
			}
			
		}		
		
		/**
		 *初始化塔 
		 * @param event
		 * 
		 */		
		protected function onCompleteBuildTower(event:Event):void
		{
			//event.target.removeEventListener(Event.COMPLETE, onCompleteBuildTower);
			_towerPool.removeEventListener(MouseEvent.CLICK, onClickTowerPool);
			_towerPool.removeEventListener(MouseEvent.MOUSE_OVER, onOverTowerPool);
			_towerPool.removeEventListener(MouseEvent.MOUSE_OUT, onOutTowerPool);
			
			switch(towerType)
			{
				case TowerType.ARROW:
				{
					buildTowerSound(1);
					newTower = new ArrowTower();
					this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.ARROW1));
					break;
				}
					
				case TowerType.CANNON:
				{
					buildTowerSound(4);
					newTower = new CannonTower();
					this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.CANNON1));
					break;
				}
				case TowerType.SHIELD:
				{
					buildTowerSound(2);
					newTower = new ShiledTower();
					this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.SHIELD1));
					//shield.openDoor();
					break;
				}
				case TowerType.MAGIC:
				{
					buildTowerSound(3);
					newTower = new MagicTower();
					this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.MAGIC1));
					break;
				}
			}
			
			addChild(newTower);
			registerX = 30 + x;
			registerY = 12 + y;
			
			
			
			newTower.init();
			
			_cicle.initUpGrade();
			_sellBtn = _cicle.sellBtn;
			_upgradeBtn = _cicle.upgradeBtn;
			
			//			newTower.addEventListener(TowerEvent.UPDATE,onTowerUpdate);
			newTower.addEventListener(MouseEvent.CLICK, onClickNewTower);
			_sellBtn.addEventListener(MouseEvent.CLICK,onSellTower);
			_upgradeBtn.addEventListener(MouseEvent.CLICK,onUpGradeTower);
			
			
		}
		
		
		protected function onUpGradeTower(event:MouseEvent):void
		{
			
			//view
			newTower.upGradeTower();
			
			BattleScene.money -= towerVo.bootMoney;
			
			//model
			switch(towerType)
			{
				case TowerType.ARROW:
				{
					buildTowerSound(1);
					if(newTower.level==2)
					{
						_bootMoney2 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.ARROW2));
					}else if(newTower.level==3){
						_bootMoney3 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.ARROW3));
					}else if(newTower.level==4){
						_bootMoney4 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.ARROW4));
					}
					break;
				}
				case TowerType.CANNON:
				{
					buildTowerSound(4);
					if(newTower.level==2)
					{
						_bootMoney2 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.CANNON2));
					}else if(newTower.level==3){
						_bootMoney3 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.CANNON3));
					}else if(newTower.level==4){
						_bootMoney4 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.CANNON4));
					}
					break;
				}
				case TowerType.MAGIC:
				{
					buildTowerSound(3);
					if(newTower.level==2)
					{
						_bootMoney2 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.MAGIC2));
					}else if(newTower.level==3){
						_bootMoney3 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.MAGIC3));
					}else if(newTower.level==4){
						_bootMoney4 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.MAGIC4));
					}
					break;
				}
				case TowerType.SHIELD:
				{
					buildTowerSound(2);
					if(newTower.level==2)
					{
						_bootMoney2 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.SHIELD2));
					}else if(newTower.level==3){
						_bootMoney3 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.SHIELD3));
					}else if(newTower.level==4){
						_bootMoney4 = towerVo.bootMoney;
						this.dispatchEvent(new TowerEvent(TowerEvent.UPDATE,TowerEvent.SHIELD4));
					}
					break;
				}
			}
		}
		
		protected function onSellTower(event:MouseEvent):void
		{
			BattleScene.money += 0.6 * (_bootMoney1 + _bootMoney2 + _bootMoney3 + _bootMoney4);
			PlayerInfo.getInstance().updataMoney(BattleScene.money);
			
			_bootMoney1 = 0;
			_bootMoney2 = 0;
			_bootMoney3 = 0;
			_bootMoney4 = 0;
			
			removeChild(newTower);
			newTower.dispose();
			newTower = null;
			
			towerType = "";
			towerVo = null;
			registerX = 0;
			registerY = 0;
			
			_cicle.initTower();
			_towerPool.addEventListener(MouseEvent.CLICK, onClickTowerPool);
			_towerPool.addEventListener(MouseEvent.MOUSE_OVER, onOverTowerPool);
			_towerPool.addEventListener(MouseEvent.MOUSE_OUT, onOutTowerPool);
			_arrow = _cicle.arrow;
			_cannon = _cicle.cannon;
			_magic = _cicle.magic;
			_shield = _cicle.shield;
			_arrow.addEventListener(MouseEvent.CLICK, onBuildTower);
			_shield.addEventListener(MouseEvent.CLICK, onBuildTower);
			_magic.addEventListener(MouseEvent.CLICK, onBuildTower);
			_cannon.addEventListener(MouseEvent.CLICK, onBuildTower);
		}		
		
		
		private function onClickTowerPool(event:MouseEvent):void
		{
			
			SoundManager.getInstance().playEffectSound("mouseClick");
			_cicle.checkMoneyEnough(BattleScene.money);
			clickCommmom(event);
			
		}
		
		protected function onClickNewTower(event:MouseEvent):void
		{
			clickCommmom(event);
			if(newTower && newTower.level >= 4)
			{
				_cicle.fullGrade();
				_upgradeBtn.removeEventListener(MouseEvent.CLICK,onUpGradeTower);
				_cicle.setMoney(000);
			}else{
				_cicle.setMoney(towerVo.bootMoney);
				if(BattleScene.money < towerVo.bootMoney) 
				{
					_cicle.canNotGrade();
				}else{
					_cicle.canGrade();
				}
			}
			
			
		}
		
		private function clickCommmom(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_isClick ? hideCicle() : 
				showCicle();
			
			_cicle.x = this.x;_cicle.y = this.y;
		}
		
		
		private function hideCicle(e:ViewEvent = null):void
		{
			if(e == null && LayerCollection.uiLayer.contains(_cicle))
			{
				LayerCollection.uiLayer.removeChild(_cicle);
				_isClick = false;
			}
			
			if(e && e.DATA != this && LayerCollection.uiLayer.contains(_cicle))
			{
				LayerCollection.uiLayer.removeChild(_cicle);
				_isClick = false;
			}
			
		}
		
		private function showCicle():void
		{
			_isClick = true;
			LayerCollection.uiLayer.addChild(_cicle);
			_cicle.scaleX = _cicle.scaleY = 0.5;
			TweenLite.to(_cicle,.15,{scaleX:1,scaleY:1});
			ViewBus.instance.dispatchEvent(new ViewEvent(ViewBus.HIDE_TOWER,this));
		}
		
		
		private function onOutTowerPool(event:MouseEvent):void
		{
			_towerPool.filters = [];
		}
		
		private function onOverTowerPool(event:MouseEvent):void
		{
			_towerPool.filters = [_glowFilter];
		}
		private static var count:int=0;
		private function buildTowerSound(type:int):void
		{
			count++;
			if(count >=5) count = 1;
			
			var temp:String;
			if(type == 1){
				temp = "sArrow"+count;
			}else if(type == 2){
				temp = "sSoldier"+count;
			}else if(type == 3){
				temp = "sMagic"+count;
			}else if(type == 4){
				temp = "sCannon"+count;
			}
			SoundManager.getInstance().playEffectSound(temp);
		}
		
		
	}
}