package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxU;
import org.flixel.FlxPoint;



class Missle extends FlxSprite 
{


public var tgt:FlxObject;
public var angSpd:Float;
public var speed:Float;
public var curRad:Float;	// angle in radius

public function new(x:Float=0, y:Float=0, tgt:FlxObject=null) 
{
	super(x, y, "assets/img/missile.png");
	this.tgt = tgt;
	angSpd = 60;
	speed = 130;
}

override public function update():Void 
{
	super.update();
	
	// set angle alone tangent
	angle = FlxU.getAngle(new FlxPoint(0, 0), velocity);
	
	// get angle to target
	//var ang:Float = FlxU.getAngle(new FlxPoint(x, y), new FlxPoint(tgt.x, tgt.y));
	
	// make a new angle near target angle
	var len:Float = FlxU.getDistance(new FlxPoint(x, y), new FlxPoint(tgt.x, tgt.y));
	var ang:Float = Math.acos((tgt.x - x) / (len));
	if (tgt.y -y < 0)	ang = -ang;	// fix to -PI~PI
	curRad = ((ang - curRad > 0)?1: -1) * ((Math.abs(ang - curRad) < Math.PI)?1: -1) * angSpd * Math.PI / 180 * FlxG.elapsed + curRad;
	if (curRad > Math.PI) curRad -= 2 * Math.PI;
	if (curRad < -Math.PI) curRad += 2 * Math.PI;
	velocity.x = Math.cos(curRad) * speed;
	velocity.y = Math.sin(curRad) * speed;
}
}