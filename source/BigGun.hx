package;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;
import org.flixel.FlxObject;

class BigGun extends FlxSprite
{


public static var ColdDown:Float = 2.5;
public static var ShotTimer:Float = 0;

public function new(X:Float=0, Y:Float=0)
{
	super(X, Y, null);
	
	loadGraphic("assets/img/bigGun.png", true, true, 60, 40);
	addAnimation("idle", [0], 1, false);
	play("idle");
	
	immovable = true;
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	health = 5;
}

override public function update():Void
{
	if(this.onScreen())
	{
	ShotTimer += FlxG.elapsed;
	if(ShotTimer >= ColdDown)
	{
		var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
		bgb.reset(getMidpoint().x, getMidpoint().y);
		bgb.velocity = new FlxPoint(facing==FlxObject.LEFT?-200:200, 0);
		ShotTimer = 0;
	}
	}		
	super.update();
}

override public function hurt(val:Float):Void{
	super.hurt(val);
	flicker(0.1);
}
}