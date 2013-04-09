package ;
import org.flixel.system.FlxTile;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.system.FlxTile;
import org.flixel.tmx.TmxObjectGroup;

class Level7 extends Level 
{
public var doorPos:FlxPoint;
public var downing:Bool;
public var zBallCenter:FlxPoint;
public var zBallRadius:Float;
public var zBallAngle:Float;
public var zBallSpeed:Float;

public function new()
{
	super();
	tileXML = nme.Assets.getText("assets/dat/level7.tmx");
	zBallSpeed = 0.5;
	zBallAngle = 0;
}

public override function create():Void
{
	super.create();
	
	GameStatic.CurLvl = 7;
	
	var mG:TmxObjectGroup = tmx.getObjectGroup("misc");
	for (o in mG.objects) 
	{
		if (o.name == "door1")
			doorPos = new FlxPoint(o.x, o.y);
		else if (o.name == "zBallPath")
		{
			zBallRadius = o.width / 2;
			zBallCenter = new FlxPoint(o.x + zBallRadius, o.y + zBallRadius);
		}
		else if (o.name == "zBallSize")
		{
			zball = new FlxSprite(o.x, o.y);
			zball.makeGraphic(o.width, o.height, 0xff990000);
		}	
	}
	
		
	// tile
	bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift.png");
	tile.follow();
	
	bot = new Bot(doorPos.x + 10, doorPos.y,bullets);
	door3 = new LDoor(doorPos.x, doorPos.y, true); 
	
	AddAll();
	
	// initial scene
	bot.On = false;
	bot.facing = FlxObject.RIGHT;
	bInLift.velocity.y = 30;
	downing = true;
	FlxG.camera.follow(bot);
	FlxG.flash(0xff000000, 2);
	ResUtil.playGame2();
	
	// test
	//bot.x = testPos1.x; bot.y = testPos1.y;
	
	// test boss fight
	// FlxG.camera.bounds.make(20 * 59, 20 * 74, 20 * 34, 20 * 24);
}

override public function update():Void 
{
	super.update();
	
	if (downing && bInLift.y > doorPos.y)
	{
	bInLift.velocity.y = 0;
	bot.EnableG(true);
	bot.On = true;
	door3.Unlock();
	//tileCover.visible = false;
	}
	
	if (door3.open && downing)
	{
	downing = false;
	bot.On = true;
	}
	
	// update zball
	zBallAngle += FlxG.elapsed * zBallSpeed;
	var newZBPos = new FlxPoint(zBallCenter.x + Math.cos(zBallAngle) * zBallRadius, zBallCenter.y + Math.sin(zBallAngle) * zBallRadius);
	zball.x = newZBPos.x;// - zball.width;
	zball.y = newZBPos.y;// - zball.height;
}

}