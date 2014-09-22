package game.view.tower
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import game.event.BattleEvent;
	import game.model.server.Calculator;
	import game.model.vo.TowerVo;
	import game.view.monster.Monster;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.Bezier;
	import qmang2d.utils.ClassManager;
	import qmang2d.utils.TimerManager;
	
	/**
	 *剑灵升级了之后，可能左右剑灵会同时攻击 
	 * @author panhao
	 * 
	 */	
	public class ArrowTower extends BaseTower
	{
		
		private var _leftShooter :BitmapMovie;
		private var _rightShooter :BitmapMovie;
		private var _arrowR :BitmapMovie;
		private var _arrowL:BitmapMovie;
		
		private var _bezierR:Bezier;
		private var _bezierL:Bezier;
		private var _stepsR:int;
		private var _stepsL:int;
		private var _curStpL:int;
		private var _curStpR:int;
		
		private var _controlPointR :Point;
		private var _startPointR :Point;
		private var _endPointR :Point;
		private var _controlPointL :Point;
		private var _startPointL :Point;
		private var _endPointL :Point;
		
		private var monsterX :Number;
		private var monsterY :Number;
		
		private var _isLReady :Boolean=true;
		private var _isRRready :Boolean=false;
		private var _lIdelIndex :int;
		private var _rIdelIndex :int;
		
		//--------辅助变量
		private var _lArrowDisa :Boolean;
		private var _rArrowDisa :Boolean;
		
		
		public function ArrowTower()
		{
			
			super();
			createArrowTower(_level);
			
			_arrowR = new BitmapMovie();
			LoaderManager.getInstance().getMovieClip("assets/arrow.swf",_arrowR);
			LayerCollection.effectLayer.addChild(_arrowR);
			_arrowR.visible = false;
			
			_arrowL = new BitmapMovie();
			LoaderManager.getInstance().getMovieClip("assets/arrow.swf",_arrowL);
			LayerCollection.effectLayer.addChild(_arrowL);
			_arrowL.visible = false;
			
		}
		
		private function createArrowTower(level_:int):void
		{
			var mc :MovieClip = ClassManager.createDisplayObjectInstance("arrow"+level_) as MovieClip;
			_tower = LoaderManager.getInstance().changeMcToBitmapMovie(mc,true,"arrow"+level_);
			addChild(_tower);
			
			_tower.y = -28;
			_tower.x = -5;
			var spriteMc :MovieClip = ClassManager.createDisplayObjectInstance("shooter"+level_) as MovieClip;
			_leftShooter = LoaderManager.getInstance().changeMcToBitmapMovie(spriteMc,true,"shooter"+level_);
			_rightShooter= LoaderManager.getInstance().changeMcToBitmapMovie(spriteMc,true,"shooter"+level_);
			_tower.addChild(_leftShooter);
			_tower.addChild(_rightShooter);
			_rightShooter.x = 50;
			_leftShooter.x = 35;
			_leftShooter.y = 7;
			_rightShooter.y = 7;
			_leftShooter.gotoAndStop(1);//idelDown
			_rightShooter.gotoAndStop(2);//idelUp
			
			_tower.mouseEnabled = true;
			_tower.buttonMode = true;
		}
		
		override public function upGradeTower():void
		{
			_level++;
			if(_level <= 4)
			{
				_tower.removeChild(_leftShooter);
				_tower.removeChild(_rightShooter);
				removeChild(_tower);
				_tower = null;
				
				createArrowTower(_level);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_tower.stop();
			_leftShooter.stop();
			_rightShooter.stop();
			_arrowR.stop();
			_arrowL.stop();
			
			removeChild(_tower);
			_tower.removeChild(_leftShooter);
			_tower.removeChild(_rightShooter);
			LayerCollection.effectLayer.removeChild(_arrowR);
			LayerCollection.effectLayer.removeChild(_arrowL);
			
			//			_tower = null;
			//			_leftShooter = null;
			//			_rightShooter = null;
			//			_arrowR = null;
			//			_arrowL = null;
		}
		
		
		/**
		 *初始化变量 
		 * 
		 */		
		override public function init():void
		{
			super.init();
			
			_bezierL = new Bezier();
			_bezierR = new Bezier();
			
		}
		
		override public function readyShoot(towerVo:TowerVo):void
		{
			super.readyShoot(towerVo);
			
			
			monsterX = _bindMonster.x;
			monsterY = _bindMonster.y;
			if(_isLReady)//左边准备好了
			{
				if(getAngleOfTM() >Math.PI/2)
				{
					_leftShooter.gotoAndPlay(3,false,3,10,shoot);//shootDown
					_lIdelIndex = 1;
					_leftShooter.scaleX=-1;
				}else if(getAngleOfTM() <= Math.PI/2 && getAngleOfTM()>0){
					_leftShooter.gotoAndPlay(3,false,3,10,shoot);//shootDown
					_lIdelIndex = 1;
					_leftShooter.scaleX=1;
				}else{
					_leftShooter.gotoAndPlay(10,false,10,16,shoot);//idelUp
					_lIdelIndex = 2;
				}
				_startPointL = new Point(10+_parentX,-30+_parentY);
				
			}
			if(_isRRready)
			{
				_startPointR = new Point(25+_parentX,-30+_parentY);
				if(getAngleOfTM() > Math.PI/2)
				{
					_rightShooter.gotoAndPlay(3,false,3,10,shoot);;//shootDown
					_rIdelIndex = 1;
					_rightShooter.scaleX=-1;
				}else if(getAngleOfTM() <= Math.PI/2 && getAngleOfTM()>0){
					_rightShooter.gotoAndPlay(3,false,3,10,shoot);//shootDown
					_rIdelIndex = 1;
					_rightShooter.scaleX=1;
				}else{
					_rightShooter.gotoAndPlay(10,false,10,16,shoot);//idelUp
					_rIdelIndex = 2;
				}
			}
		}
		
		
		//开始射击
		override protected function shoot():void
		{
			SoundManager.getInstance().playEffectSound("sFightArrow3");
			if(_bindMonster)
			{
				var controlX :Number = monsterX - (20+_parentX);
				var endPonit :Point;
				//			var _monsterDirection :String = _bindMonster1.direction;
				var controlPoint :Point;
				if(_isLReady)
				{
					_controlPointL = new Point(controlX/2+_parentX,-100+_parentY);
					//				if(_monsterDirection == "right")//todo 后期还可以优化。画路点的时候尽量平滑
					//				{
					//					_endPointL = new Point(monsterX+10,monsterY);
					//				}else if(_monsterDirection == "down"){
					//					_endPointL = new Point(monsterX,monsterY+10);
					//				}else if(_monsterDirection == "left"){
					//					_endPointL = new Point(monsterX-10,monsterY);
					//				}else{
					//				}
					_endPointL = new Point(monsterX,monsterY-5);
					if(_lIdelIndex == 1)
					{
						_leftShooter.gotoAndStop(1);//朝下
					}else{
						_leftShooter.gotoAndStop(2);
					}
					_arrowL.visible = true;
					_curStpL = 0;
					_stepsL  = _bezierL.init(_startPointL,_controlPointL,_endPointL,20);
					endPonit = _bindMonster.getNextPoint(_stepsL);
					controlPoint = new Point((endPonit.x -(20+_parentX))/2+_parentX,-100+_parentY);
					_stepsL  = _bezierL.init(_startPointL,controlPoint,endPonit,20);
				}
				
				if(_isRRready)
				{
					_controlPointR = new Point(controlX/2+_parentX,-100+_parentY);
					//				if(_monsterDirection == "right")//todo 后期还可以优化。画路点的时候尽量平滑
					//				{
					//					_endPointR = new Point(monsterX+10,monsterY);
					//				}else if(_monsterDirection == "down"){
					//					_endPointR = new Point(monsterX,monsterY+10);
					//				}else if(_monsterDirection == "left"){
					//					_endPointR = new Point(monsterX-10,monsterY);
					//				}else{
					//				}
					_endPointR = new Point(monsterX,monsterY-5);
					if(_rIdelIndex == 1)
					{
						_rightShooter.gotoAndStop(1);//朝下
					}else{
						_rightShooter.gotoAndStop(2);
					}
					_arrowR.visible = true;
					_curStpR = 0;
					_stepsR  = _bezierR.init(_startPointR,_controlPointR,_endPointR,20);
					endPonit = _bindMonster.getNextPoint(_stepsR);
					controlPoint =  new Point((endPonit.x -(20+_parentX))/2+_parentX,-100+_parentY);
					_stepsR  = _bezierR.init(_startPointR,controlPoint,endPonit,20);
				}
				
				
				super.shoot();
			}
		}
		
		override public function Render():void
		{
			var tmpArr:Array;
			
			if(_isLReady)
			{
				if(_bindMonster.hitTestObject(_arrowL))
				{
					SoundManager.getInstance().playEffectSound("hurt1");
					if(_lArrowDisa == false)
					{
						_lArrowDisa = true;
					}else{
						checkHit()
						startCool();
						return;
					}
				}
				
				
				if(_curStpL < _stepsL)
				{
					tmpArr = _bezierL.getAnchorPoint(_curStpL);
					_arrowL.x =  tmpArr[0];
					_arrowL.y =  tmpArr[1];
					_arrowL.rotation = tmpArr[2];
					_curStpL++;
				}else if(_curStpL == _stepsL){
					startCool();
					_curStpL++;
				}
				
				
			}
			
			
			if(_isRRready)
			{
				if(_bindMonster.hitTestObject(_arrowR))
				{
//					SoundManager.getInstance().playEffectSound("hurt2");
					if(_rArrowDisa == false)
					{
						_rArrowDisa = true;
					}else{
						checkHit()
						startCool();
						return;
					}
				}
				
				if(_curStpR < _stepsR)
				{
					tmpArr = _bezierR.getAnchorPoint(_curStpR);
					_arrowR.x =  tmpArr[0];
					_arrowR.y =  tmpArr[1];
					_arrowR.rotation = tmpArr[2];
					_curStpR++;
				}else if(_curStpR == _stepsR){
					startCool();
					_curStpR++;
				}
				
				
			}
			
			
		}
		
		/**
		 *打击完毕，开启冷却 
		 * 
		 */		
		override protected function startCool():void
		{
			super.startCool();
			if(_towerVo.bindMonster && _towerVo.bindMonster.monsterVo.blood <= 0)
			{
				_towerVo.bindMonster = null;
			}
		}
		
		/**
		 *冷却结束 
		 * 
		 */		
		override protected function coolOff():void
		{
			super.coolOff();
//			reset();
		}
		
		
		private function checkHit():void
		{
			if(_towerVo.bindMonster)
			{
				if(_towerVo.bindMonster.monsterVo.blood >0)
				{
					var temp:int = Calculator.hit(_towerVo.attackPowerMax,_towerVo.attackPowerMin);
					_towerVo.bindMonster.monsterVo.blood -= temp;
					_towerVo.bindMonster.updateBlood(_towerVo.bindMonster.monsterVo.blood);
					reset();
				}else{
					if(LayerCollection.playerLayer.contains(_towerVo.bindMonster))
					{
						reset();//不是射空枪----
					}
				}
			}
		}
		
		private function reset():void
		{
			state = TowerState.IDEL;
			if(_isLReady)
			{
				_arrowL.x = 20+_parentX;
				_arrowL.y = -70+_parentY;
				_arrowL.visible = false;
				_lArrowDisa = false;
				_leftShooter.gotoAndStop(_lIdelIndex);
				//dispatchEvent(new BattleEvent(BattleEvent.ATTACK_SUCCESS,_id));
			}
			
			if(_isRRready)
			{
				_arrowR.x = 20+_parentX;
				_arrowR.y = -70+_parentY;
				_arrowR.visible = false;
				_rArrowDisa = false;
				_rightShooter.gotoAndStop(_rIdelIndex);
				
				//dispatchEvent(new BattleEvent(BattleEvent.ATTACK_SUCCESS,_id));
			}
			
			_isLReady = !_isLReady;
			_isRRready = !_isRRready;
		}
	}
	
}