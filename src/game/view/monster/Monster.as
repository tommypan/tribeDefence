package  game.view.monster
{
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.event.BattleEvent;
	import game.model.vo.MonsterVo;
	import game.model.vo.PointVo;
	import game.view.scene.ui.battle.BloodProgressBar;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.pool.interfaces.IPool;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	
	/**
	 * 可按路径数组进行移动的基础对象 
	 * @author panhao
	 * 
	 */        
	public class Monster extends Sprite implements IPool
	{
		
		protected var _pathArr:Array;
		public  var _speed:int=2;
		protected var _tar_point:Point;
		public var bitmapMovie :BitmapMovie;
		protected var _isStop :Boolean;
		protected var _lines:Vector.<PointVo>;
		protected var _curIndex:int;
		public var state :String;
		
		protected var redBloodProgress:BloodProgressBar;
		protected var totoalHp :int;
		
		/**直接让view拥有vo属性(虽然做法不正规)，这样在进行AI计算时，省去了下标匹配带来大规模迭代，提升效率*/
		public var monsterVo :MonsterVo;
		
		protected var angle:Number;
		
		protected var _type :String;
		
		
		//------------与预先路点算法有关
		
		public function Monster()
		{
			
		}
		
		public function init(lines_:Vector.<PointVo>,classForName:String,monsterVo_:MonsterVo=null,type_:String=""):void
		{
			_lines = lines_;
			_type = type_;
			if(monsterVo_)
			{
				monsterVo = monsterVo_;
				_speed = monsterVo.speed;
			}
			//在外部进行统一加载
			bitmapMovie = LoaderManager.getInstance().changeMcToBitmapMovie(ClassManager.createDisplayObjectInstance(classForName) as MovieClip ,true,classForName);
			addChild(bitmapMovie);
			bitmapMovie.scaleX = -1;
			
			
			state = MonsterState.RUN;
			if(_type != "shield")
			{
			}else{
				_curIndex = _lines.length-1;
			}
			
			var p:Point=new Point(_lines[_curIndex].x,_lines[_curIndex].y);
			walk=[p];
			
			addEventListener(Event.ENTER_FRAME,onAddBloodBar);
		}
		
		protected function onAddBloodBar(event:Event):void
		{
			if(bitmapMovie.height != 0)
			{
				addProgressBar();
				removeEventListener(Event.ENTER_FRAME,onAddBloodBar);
			}
		}		
		
		/**
		 *适配器 
		 * @param isLoop_
		 * @param _startFrameLable_
		 * @param _endFrameLabel_
		 * @param $endFunction
		 * 
		 */		
		protected function gotoAndPlay(isLoop_:Boolean=true, _startFrameLable_:String=null, _endFrameLabel_:String=null, $endFunction:Function=null):void
		{
			
			var start:int,end:int,run :int, runEnd :int, fighting :int, fightingEnd :int, dead :int, deadEnd :int;
			
			for each (var i:FrameLabel in bitmapMovie.lables) 
			{
				
				("running" == i.name)     && (run = i.frame);
				("runningEnd" == i.name)  && (runEnd = i.frame);
				("fighting" == i.name)    && (fighting = i.frame);
				("fightingEnd" == i.name) && (fightingEnd = i.frame);
				("dead" == i.name)        && (dead = i.frame);
				("deadEnd" == i.name)     && (deadEnd = i.frame);
				
			}
			
			if(_startFrameLable_ == "running")
			{
				if(_endFrameLabel_ != "runningEnd") 
				{
					throw new IllegalOperationError("业务逻辑错误") 
				}else{
					start = run;end = runEnd;
				}
			} else if(_startFrameLable_ == "fighting"){
				if(_endFrameLabel_ != "fightingEnd") 
				{
					throw new IllegalOperationError("业务逻辑错误") 
				}else{
					start = fighting;end = fightingEnd;
				}
			} else if(_startFrameLable_ == "dead") {
				if(_endFrameLabel_ != "deadEnd") 
				{
					throw new IllegalOperationError("业务逻辑错误") 
				}else{
					start = dead;end = deadEnd;
				}
			}else{
				throw new IllegalOperationError("业务逻辑错误");
			}
			
			//trace("start,end",start,end);
			bitmapMovie.gotoAndPlay(start,isLoop_,start,end,$endFunction);
			
		}
		
		protected function addProgressBar():void
		{
			totoalHp = monsterVo.blood;
			redBloodProgress = new BloodProgressBar();
			redBloodProgress.y = -bitmapMovie.height+5;
			redBloodProgress.x = -redBloodProgress.width/2;
			addChild(redBloodProgress);
			
		}
		
		public function updateBlood(curHp:int):void
		{
			(curHp < 0) && (curHp = 0);
			redBloodProgress.update(curHp/totoalHp);
		}
		
		public function gotoAndStop(frameIndex:int):void
		{
			bitmapMovie.gotoAndStop(frameIndex);
		}
		
		
		
		
		public function fighting(callBack:Function=null):void
		{
			state = MonsterState.ATTACK;
			gotoAndPlay(true,"fighting","fightingEnd",callBack);//为了考究效率，直接传字符串了
		}
		
		public function run():void
		{
			state = MonsterState.RUN;
			gotoAndPlay(true,"running","runningEnd");
		}
		
		//正常死亡
		public function die():void
		{
			SoundManager.getInstance().playEffectSound("dead"+int((1+5*Math.random())));
			state = MonsterState.DIE;
			gotoAndPlay(false,"dead","deadEnd",onRemoveIt);
		}
		
		public function onRemoveIt():void
		{
			state = MonsterState.DIE;
			LayerCollection.playerLayer.removeChild(this);
			dispatchEvent(new BattleEvent(BattleEvent.DEAD_PALY_OVER));
			sleep();
		}		
		
		//非死亡状态移除
		public function sleep():void
		{
			_curIndex = 0;
			bitmapMovie.stop();
			removeChild(bitmapMovie);
			removeChild(redBloodProgress);
		}
		
		public function wakeUp():void
		{
			
		}
		
		public function moving():void
		{
			if(state == MonsterState.RUN)
			{
				
				if(_pathArr&&_pathArr.length>=0)
				{
					var point :Point = new Point(x,y);
					var distance :Number=Point.distance(_tar_point,point);
					if (distance < 10)
					{
						var p:Point;
						if(_type != "shield")
						{
							if(_curIndex<_lines.length-1)
							{
								_curIndex++;
								p =new Point(_lines[_curIndex].x,_lines[_curIndex].y);
								//var pVo :PointVo = new PointVo();
								//pVo.x = _lines[_curIndex].x;
								//pVo.y = _lines[_curIndex].y;
								walk=[p];
								
							}else{
								state = MonsterState.DIE
								this.dispatchEvent(new Event(Event.COMPLETE))
							}
						}else{
							if(_curIndex>0)
							{
								_curIndex--;
								p=new Point(_lines[_curIndex].x,_lines[_curIndex].y);
								walk=[p];
							}else{
								state = MonsterState.DIE
								this.dispatchEvent(new Event(Event.COMPLETE))
							}
						}
					}else{
						var dx :Number=_tar_point.x - this.x;
						var dy :Number=_tar_point.y - this.y;
						//计算角度
						angle=Math.atan2(dy, dx);
						//移动
						this.x+=_speed * Math.cos(angle);
						this.y+=_speed * Math.sin(angle);
						
						//修正方向
						if (angle >= -Math.PI / 2 && angle < Math.PI / 2)
						{
							bitmapMovie.scaleX=1;
						}else{
							bitmapMovie.scaleX=-1;
						}
						
					}
				}
			}
		}
		
		public function getNextPoint(step:uint):Point
		{
//			if(_li)
				var fx :Number=x,fy:Number=y;
				var nCurIndex:int = _curIndex;
				var nAngle:Number;
				var tarPoint :Point = new Point(_tar_point.x,_tar_point.y);
				for (var i:int = 0; i < step; i++) 
				{
					var point :Point = new Point(fx,fy);
					var distance :Number=Point.distance(tarPoint,point);
					if(distance < 10)
					{
						if(nCurIndex<_lines.length-1)
						{
							nCurIndex++;
							var p:Point=new Point(_lines[nCurIndex].x,_lines[nCurIndex].y);
							_pathArr=[p].slice();
							if(this._pathArr.length>0)
								tarPoint=this._pathArr.shift();
						}
					}else{
						var dx :Number=tarPoint.x - fx;
						var dy :Number=tarPoint.y - fy;
						//计算角度
						nAngle=Math.atan2(dy, dx);
						//移动
						fx+=_speed * Math.cos(nAngle);
						fy+=_speed * Math.sin(nAngle);
					}
				}
				
				return new Point(fx,fy);
		}
		
		
		//-------------------getter setter-----------------------------
		public function set walk(path:Array):void
		{
			//			_bitmapMovie.x = -_bitmapMovie.width/2;
			//			_bitmapMovie.y = -_bitmapMovie.height/2;
//			if(state == MonsterState.RUN)
//			{
				this._pathArr=path.slice();//如果不传递任何参数，则新数组是原始数组的副本（表浅克隆）。
				
				if(this._pathArr.length>0)
					_tar_point=this._pathArr.shift();
//			}
		}
		
		//进洞了的方法
		public function enterCave():void
		{
			
		}
		
		
		
	}
}