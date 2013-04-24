package ;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;

import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.tmx.TmxObject;

class Lift extends FlxSprite 
{
public var w:Int;
public var top:Int;
public var down:Int;
public var left:Int;
public var right:Int;
public var mode:Int;	// 0-up~down 1-left~right
public var turned:Bool;	// 
public var speed:Float;

public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null) 
{
	super(X, Y, SimpleGraphic);
	immovable = true;
	allowCollisions = FlxObject.UP;
}

public function make(o:TmxObject)
{
	reset(o.x, o.y);
	w = Std.parseInt(o.custom.w);
	speed = Std.parseFloat(o.custom.speed);
	if (w == 2)
	loadGraphic("assets/img/lift2.png");
	else if (w == 3)
	loadGraphic("assets/img/lift3.png");
	else 
	loadGraphic("assets/img/lift4.png");
	
	width = w * 20;
	height = 20;
	offset = new FlxPoint(0, 3);
	
	top = o.y;
	down = o.y + o.height - 20;
	left = o.x;
	right = o.x + o.width - 20 * w;
	
	if (o.height > 20)
	{
	mode = 0;
	velocity.y = speed;
	}
	else 
	{
	mode = 1;
	velocity.x = speed;
	}
	
	var start:Int = Std.parseInt(o.custom.resolve("start"));
	if (start == 0)
	{
		// nothing
	}
	else if (start == 1)
	{
		if (mode == 0)
			y = down;
		else 
			x = right;
	}
}

override public function update():Void 
{
	if (mode == 1)
	{
	if (velocity.x >= 0 && x >= right)
		velocity.x = -speed;
	else if (velocity.x <= 0 && x <= left)
		velocity.x = speed;
	}
	else if (mode == 0)
	{
	if (velocity.y >= 0 && y >= down)
		velocity.y = -speed;
	else if (velocity.y <= 0 && y <= top)
		velocity.y = speed;
	}
	
	super.update();
}
}