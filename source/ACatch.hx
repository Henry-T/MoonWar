package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxU;
import org.flixel.FlxPoint;
import org.flixel.tmx.TmxObject;

class ACatch extends FlxSprite 
{

public var hang : String;
public static var ColdDown:Float = 1;
public static var ShotTimer:Float = 0;
public var gun : FlxSprite;

public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null) 
{
	super(X, Y, SimpleGraphic);
	gun = new FlxSprite(0, 0, "assets/img/acGun.png");
	gun.origin = new FlxPoint(5, 5);
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	health = 5;
}

public function make(o:TmxObject):Void
{
	reset(o.x, o.y);
	width = o.width;
	height = o.height;
	if (o.custom != null)
	{
	hang = o.custom.hang;
	if (hang == "up")
	{
		loadGraphic("assets/img/acBaseUp.png");
		gun.x = x + 15;
		gun.y = y + 15;	
		
	}
	else if (hang == "down")
	{
		loadGraphic("assets/img/acBaseDown.png");
		gun.x = x;
		gun.y = y + 15;	
	}
	else if (hang == "left")
	{
		loadGraphic("assets/img/acBaseLeft.png");
		gun.x = x + 15;
		gun.y = y + 15;	
	}
	else if (hang == "right")
	{
		loadGraphic("assets/img/acBaseRight.png");
		gun.x = x + 15;
		gun.y = y;	
	}
	}
	
}

override public function update():Void 
{
	var agl:Float = FlxU.getAngle(getMidpoint(), cast(FlxG.state , Level).bot.getMidpoint()) * Math.PI / 180 - Math.PI/2;
	if (onScreen())
	{
	ShotTimer += FlxG.elapsed;
	if(ShotTimer >= ColdDown)
	{
		var bgb:BigGunBul = cast(cast(FlxG.state , Level).bigGunBuls.recycle(BigGunBul) , BigGunBul);
		bgb.reset(getMidpoint().x, getMidpoint().y);
		bgb.velocity = new FlxPoint(Math.cos(agl) * 200, Math.sin(agl) * 200);
		ShotTimer = 0;
	}
	}
	
	// aim at bot
	
	// fix angle
	gun.angle = agl * 180 / Math.PI;
	
	super.update();
}

override public function hurt(Damage:Float):Void 
{
	super.hurt(Damage);
}

override public function kill():Void 
{
	super.kill();
}

override public function draw():Void 
{
	super.draw();
	
	gun.draw();
}

}