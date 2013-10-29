package ;

import org.flixel.util.FlxTimer;

// Make it easier to use FlxTimer
// 1. When in need of a FlxTimer, we will create a new instance manually.
// 2. When calling start() on one of existed timers, we have to check again not to interapt a working timer.
// Just cal Get() here, and you will get a neat and ready timer for your job!
// NOTE: Timers alloced will not get destoried until program closed
//		I presume you won't query for a lot of timers at a time and just left them there after then.
//		If this does happen, call Clear() to remove all idle timers.
// LIMIT: This is only useful on one time timer which you won't try to stop when started. 
//		If you need a muiti time timer or want to track it's status, more work is needed to clear up!
// WARN: Even timer seems no need to get tracked needs track sometime. Eg. a guy shoot bullets on schedule of a timer
// 		When it's dead, you have to stop the timer manually becase the timer is not part of the guy!
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