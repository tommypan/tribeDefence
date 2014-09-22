package game.model.server
{
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-7-29
	 */	
	public class Calculator
	{
		public function Calculator()
		{
		}
		
		/**
		 * 
		 * @param damageMax 攻击方的最大伤害值
		 * @param damageMin 攻击方的最小伤害值
		 * @param defence 被攻击方的防御值
		 * @return 被攻击对象的血量减少值
		 * 
		 */	
		public  static function hit(damageMax:int,damageMin:int):int
		{
			var duraion :int = damageMax - damageMin;
			
			return Math.random()*duraion + damageMin;
		}
		
	}
}