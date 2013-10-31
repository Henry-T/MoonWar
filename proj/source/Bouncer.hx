package ;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Bouncer extends FlxSprite 
{
	public var timer:FlxTimer;
	public var bounceCount:Int;

	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y, "assets/img/bouncer.png");
		this.elasticity = 1;
		timer = TimerPool.Get();
	}

	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		bounceCount = 3;
		//timer.start(7, 1, function(t:FlxTimer) { kill();} );
	}

	override public function update():Void 
	{
		super.update();
		
		if (bounceCount <= 0)
		kill();
	}
}