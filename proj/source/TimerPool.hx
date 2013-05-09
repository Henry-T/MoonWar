package ;

import org.flixel.FlxTimer;

// Make it easier to use FlxTimer
// 1. When in need of a FlxTimer, we will create a new instance manually.
// 2. When calling start() on one of existed timers, we have to check again not to interapt a working timer.
// Just cal Get() here, and you will get a neat and ready timer for your job!
// NOTE: Timers alloced will not get destoried until program closed
//		I presume you won't query for a lot of timers at a time and just left them there after then.
//		If this does happen, call Clear() to remove all idle timers.
class TimerPool {
	private static var timers:Array<FlxTimer>;

	public static function Get():FlxTimer{
		if(timers == null)
			timers = new Array<FlxTimer>();

		// get a finished timer if there is one
		for (tmr in timers) {
			if(tmr.finished)
				return tmr;
		}

		// create a new one
		var timer:FlxTimer = new FlxTimer();
		timers.push(timer);

		return timer;
	}

	public static function Clear(){
		for (tmr in timers) {
			if(tmr.finished){
				tmr.destroy();
				timers.remove(tmr);
			}
		}
	}
}