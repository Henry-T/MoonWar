package;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;
import flash.display.Graphics;


class SpawnUp extends FlxSprite
{


public static var ColdDown:Float = 3.5;
public static var ShotTimer:Float = 0;
public var game:Level;

public function new(x:Float=0, y:Float=0)
{
	super(x, y, "assets/img/gpUp.png");
	this.immovable = true;
}

override public function update():Void
{
	super.update();
	if(health <=0)
	this.kill();
	
	ShotTimer += FlxG.elapsed;
	if(ShotTimer >= ColdDown)
	{
	var d:Duck;
	d = cast(game.ducks.recycle(Duck) , Duck);
	d.x = x; d.y=y;
	d.velocity = new FlxPoint(100 * Math.cos(30*Math.PI/180), -100 * Math.sin(30*Math.PI/180));
	d = cast(game.ducks.recycle(Duck) , Duck);
	d.x = x; d.y=y;
	d.velocity = new FlxPoint(100 * Math.cos(90*Math.PI/180), -100 * Math.sin(90*Math.PI/180));
	d = cast(game.ducks.recycle(Duck) , Duck);
	d.x = x; d.y=y;
	d.velocity = new FlxPoint(100 * Math.cos(150*Math.PI/180), -100 * Math.sin(150*Math.PI/180));
	
	ShotTimer = 0;
	}
}
}