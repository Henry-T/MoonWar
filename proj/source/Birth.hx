package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;



class Birth extends FlxObject 
{
public var span:Float;
public var gid:Int;
public var count:Int;
public var type:String;
public var timer1:FlxTimer;

public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
{
	super(X, Y, Width, Height);
	
	timer1 = TimerPool.Get();
	
}

public function Start():Void
{
	timer1.run(span, function(t:FlxTimer):Void {
		switch(type)
		{
			case "bWalk":
				var bWalk:BWalk = cast(cast(FlxG.state , Level).bWalks.recycle(BWalk) , BWalk);
				bWalk.reset(getMidpoint().x - bWalk.width/2, getMidpoint().y - bWalk.height/2);
				bWalk.inAction = true;
		}
	}, count);
}

}