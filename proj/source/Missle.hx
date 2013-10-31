package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;


class Missle extends Enemy 
{
	public var tgt:FlxObject;
	public var angSpd:Float;
	public var speed:Float;
	public var curRad:Float;	// angle in radius
	public static var maxHealth:Float = 3;
	public static var lifeTime:Float = 7;
	public var liveTimer:Float = 0;

	public function new(x:Float=0, y:Float=0, tgt:FlxObject=null) 
	{
		super(x, y, "assets/img/missile.png");
		this.tgt = tgt;
		angSpd = 100;
		speed = 130;
		health = maxHealth;
		liveTimer = 0;
	}

	public override function reset(X:Float, Y:Float){
		super.reset(X, Y);
		health = maxHealth;
		liveTimer = 0;
	}

	override public function update():Void 
	{
		super.update();
		
		// set angle alone tangent
		angle = FlxAngle.getAngle(new FlxPoint(0, 0), velocity);
		
		// get angle to target
		//var ang:Float = FlxAngle.getAngle(new FlxPoint(x, y), new FlxPoint(tgt.x, tgt.y));
		
		// make a new angle near target angle
		var len:Float = FlxMath.getDistance(new FlxPoint(x, y), new FlxPoint(tgt.x, tgt.y));
		var ang:Float = Math.acos((tgt.x - x) / (len));
		if (tgt.y -y < 0)	ang = -ang;	// fix to -PI~PI
		curRad = ((ang - curRad > 0)?1: -1) * ((Math.abs(ang - curRad) < Math.PI)?1: -1) * angSpd * Math.PI / 180 * FlxG.elapsed + curRad;
		if (curRad > Math.PI) curRad -= 2 * Math.PI;
		if (curRad < -Math.PI) curRad += 2 * Math.PI;
		velocity.x = Math.cos(curRad) * speed;
		velocity.y = Math.sin(curRad) * speed;

		liveTimer += FlxG.elapsed;
		if(liveTimer > lifeTime)
			kill();
	}
}