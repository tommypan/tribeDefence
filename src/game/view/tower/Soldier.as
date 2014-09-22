package game.view.tower
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import game.event.BattleEvent;
	import game.model.vo.MonsterVo;
	import game.model.vo.PointVo;
	import game.view.monster.Monster;
	import game.view.monster.MonsterState;
	
	import qmang2d.loader.LoaderManager;
	import qmang2d.utils.ClassManager;
	
	/**
	 * 巡逻兵
	 * <p>随机对路点进行清理，由兵营生产
	 * <p>没有敌人直接走完，来回巡逻
	 * <p>被攻击死后，有一段复活时间
	 * <p>路点选择，每一关可以定死
	 * @author panhao
	 * @date 2013-8-6
	 */	
	public class Soldier extends Monster
	{
		//-------------与士兵攻击有关
		public var bindMonster :Monster;
		public var hitNum:int;
		
		public function Soldier()
		{
		}
		
		override public function init(lines_:Vector.<PointVo>,classForName:String,monsterVo_:MonsterVo=null,type_:String=""):void
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
			
			//addProgressBar();
			
			if(_type != "shield")
			{
			}else{
				_curIndex = _lines.length-1;
			}
			
			var p:Point=new Point(_lines[_curIndex].x,_lines[_curIndex].y);
			walk=[p];
			
		}
		
		public function initLine(lines_:Vector.<PointVo>):void
		{
			_lines = lines_;
			state = MonsterState.RUN;
			if(_type != "shield")
			{
			}else{
				_curIndex = _lines.length-1;
			}
			
			var p:Point=new Point(_lines[_curIndex].x,_lines[_curIndex].y);
			walk=[p];
		}
		
		override public function onRemoveIt():void
		{
			state = MonsterState.DIE;
			dispatchEvent(new BattleEvent(BattleEvent.DEAD_PALY_OVER));
		}	
		
		public function changeSkin(classForName :String,callBack:Function):void
		{
			removeChild(bitmapMovie);
			
			var sx :int = bitmapMovie.scaleX;
			
			bitmapMovie = LoaderManager.getInstance().changeMcToBitmapMovie(ClassManager.createDisplayObjectInstance(classForName) as MovieClip ,true,classForName);
			addChild(bitmapMovie);
			bitmapMovie.scaleX = sx;
			
			if(state == MonsterState.ATTACK)
			{
				fighting(callBack);
			}else if(state == MonsterState.RUN){
				run();
			}else if(state == MonsterState.DIE){
				state = MonsterState.DIE;
			}else{
				state = MonsterState.IDEL;
				bitmapMovie.gotoAndStop(1);
			}
		}
		
	}
}