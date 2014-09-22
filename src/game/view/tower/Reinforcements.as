package game.view.tower
{
	import flash.display.Sprite;
	
	import game.view.monster.IAnimator;
	import game.view.monster.Monster;
	
	import qmang2d.pool.interfaces.IPool;
	
	/**
	 * 天降援兵
	 * <p>及时从地下冒出出现在热点地区，抵抗敌兵。
	 * <p>不需要寻路算法
	 * <p>有生命周期
	 * @author panhao
	 * @date 2013-8-6
	 */	
	public class Reinforcements extends Sprite implements IAnimator
	{
		public var lifeTime :int=10;//计时器在外部做
		public var binMonster :Monster;
		
		public function Reinforcements($binMonster:Monster)
		{
			binMonster = $binMonster;
		}
		
		public function fight():void
		{
			
		}
		
		public function idel():void
		{
			
		}
		
		
		/**
		 * 在外部计算热点区域（出现）
		 * 
		 */			
		public function wakeUp():void
		{
			
		}
		
		
		/**
		 *sleep后还要还回对象池
		 * 
		 */
		public function sleep():void
		{
			
		}
		
	}
}