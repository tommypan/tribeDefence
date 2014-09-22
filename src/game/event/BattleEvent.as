package game.event
{
	import flash.events.Event;

	public class BattleEvent extends GameEvent
	{
		public static const CHANGE_QUALITY:String = "CHANGE_QUALITY";
		public static const SOUND_EFFECT:String = "SOUND_EFFECT";
		public static const TIPS:String = "TIPS";
		public static const SOUND:String = "SOUND";
		public static const AUTO_PAUSE:String = "AUTO_PAUSE";
		public static const RESTART:String = "RESTART";
		public static const CLOSE_SET:String = "CLOSE_SET";
		public static const WIN_STARS:String = "win_stars";
		
		public static const ATTACK_SUCCESS:String = "attackSuccess";
		public static const DEAD_PALY_OVER:String = "deadPlayOver";
		
		public static const BATTLE_SUCCESS:String = "battleSuccess";
		public static const BATTLE_FAIL:String = "battleFail";
		public static const BATTLE_SPEED :String = "battleSpeed";
		public static const CHECK_BATTLE_OVER :String = "checkBattleOver";
		
		public function BattleEvent(type:String,data_:Object = null)
		{
			super(type,data_);
		}
	}
}