package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;



class GPMid extends Enemy
{

public static var ColdDown:Float = 2.8;
public static var ShotTimer:Float = 0;

private static var shotOrg:FlxPoint = new FlxPoint(30, 30);
private var shotLen:Float = 30;
private var bulSpeed:Float = 200;

public function new(X:Int = 0, Y:Int = 0 ) 
{
	super(X, Y, "assets/img/gpMid.png");
	
	immovable = true;
	
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	health = 5;
}

override public function update():Void 
{
	super.update();
	
	ShotTimer += FlxG.elapsed;
	if(ShotTimer >= ColdDown)
	{
	for (i in 0...6) 
	{
		var agl:Float = -Math.PI / 2 + (i) * Math.PI / 3;
		var vecTgt:FlxPoint = new FlxPoint(Math.cos(agl), Math.sin(agl));
		var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
		bgb.reset(shotOrg.x + x + vecTgt.x * shotLen - bgb.width / 2, shotOrg.y + y + vecTgt.y * shotLen - bgb.width / 2);
		bgb.velocity.make(vecTgt.x * bulSpeed, vecTgt.y * bulSpeed);
	}
	ShotTimer = 0;
	}
	
}

override public function hurt(Damage:Float):Void 
{
	super.hurt(Damage);
	flicker(0.2);
}

override public function kill():Void 
{
	super.kill();
}
}