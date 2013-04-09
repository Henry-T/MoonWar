package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.system.FlxDebugger;
import org.flixel.FlxPoint;
import org.flixel.system.FlxDebugger;
import org.flixel.tmx.TmxObject;

class Laser extends FlxSprite 
{




public var mode:Int;	// 0-ver 1-hor
public var liveTime:Float;	// total live tile
public var onTime:Float;
public var offTime:Float;
public var start:Float;
public var NowOn:Bool;
public var cirTime:Float;

public var side1:FlxSprite;
public var side2:FlxSprite;
public var laserH:FlxSprite;
public var laserV:FlxSprite;

public function new() 
{
	super();
	mode = 0;
	side1 = new FlxSprite( -100, -100, "assets/img/laserBase.png");
	side2 = new FlxSprite( -100, -100, "assets/img/laserBase.png");
	laserH = new FlxSprite( -100, -100, "assets/img/laserH.png"); laserH.origin = new FlxPoint(0, 0);
	laserV = new FlxSprite( -100, -100, "assets/img/laserV.png"); laserV.origin = new FlxPoint(0, 0);
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	liveTime = 0;
}

public function make(o:TmxObject):Void
{
	reset(o.x, o.y);
	width = o.width;
	height = o.height;
	onTime = Std.parseFloat(o.custom.onTime);
	offTime = Std.parseFloat(o.custom.offTime);
	start = Std.parseFloat(o.custom.start);
	liveTime = start;
	cirTime = onTime + offTime;
	
	if (width == 40)
	mode = 0;
	else 
	mode = 1;
	
	side1.x = x; side1.y = y;
	side2.x = x + width - 40; side2.y = y + height -40;
	if (mode == 0)
	{
	laserV.x = x;
	laserV.y = y + 40;
	laserV.scale.y = (height - 80)/laserV.height;
	}
	else 
	{
	laserH.x = x + 40;
	laserH.y = y;
	laserH.scale.x = (width - 80)/laserH.width;
	}
}

override public function update():Void 
{
	// update laser image
	liveTime += FlxG.elapsed;
	
	var fCircles:Int = Std.int( Std.int(liveTime * 100) / Std.int(cirTime * 100));
	var dT:Float = liveTime > 0? (liveTime - fCircles * cirTime):(liveTime + fCircles * cirTime);
	if (dT < 0)
	dT += cirTime;
	if (dT <= onTime)
	NowOn = true;
	else
	NowOn = false;
	
	super.update();
}

override public function draw():Void 
{
	super.draw();
	
	// draw two side box
	side1.draw();
	side2.draw();
	
	// draw laser
	if (NowOn)
	{
	if (mode == 0)
		laserV.draw();
	else 
		laserH.draw();
	}
}

}