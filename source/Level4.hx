package ;
import org.flixel.system.FlxTile;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import flash.geom.Point;
import org.flixel.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;

class Level4 extends Level 
{



public var liftPos:FlxPoint;


public static var camLefting:Bool = false;
public static var camLeftLen:Float = 8 * 20;
public var camLeftStart:Float;
public static var camDowning:Bool = false;
public static var camDownLen:Float = 23 * 20;
public var camDownStart:Float;
public static var camRighting:Bool = false;
public static var camRightLen:Float = 8 * 20;
public var camRightStart:Float;

public var bossP1:FlxPoint;
public var bossP2:FlxPoint;
public var bossP3:FlxPoint;
public var bossRighting:Bool;

public function new()
{
	super();
	tileXML = nme.Assets.getText("assets/dat/level4.tmx");
}

override public function create():Void 
{
	super.create();
	
	GameStatic.CurLvl = 4;
	
	var os:TmxObjectGroup = tmx.getObjectGroup("misc");
	for ( to in os.objects)
	{
	if (to.name == "lift1")
		liftPos = new FlxPoint(to.x, to.y);	
	else if (to.name == "com1")
	{
		com1 = new Com(to.x, to.y, to.width, to.height);
		com1.onTig = openDoor;
	}
	else if (to.name == "hmPos1")
		bossP1 = new FlxPoint(to.x, to.y);
	else if (to.name == "hmPos2")
		bossP2 = new FlxPoint(to.x, to.y);
	else if (to.name == "hmPos3")
		bossP3 = new FlxPoint(to.x, to.y);
	}
	
	tileLand = GetTile("land", FlxObject.ANY); 
	tileLand2 = GetTile("land2", FlxObject.ANY); 
	
	boss2 = new Boss2(100, 250);
	bot = new Bot(start.x,start.y,bullets);
	
	door1 = new LDoor(liftPos.x, liftPos.y, true);
	door2 = new LDoor(liftPos.x, liftPos.y, false);
	
	AddAll();
	
	// initial
	tile.follow();
	FlxG.camera.follow(bot);
	ResUtil.playGame2();
}

override public function update():Void
{
	FlxG.collide(bot, tileLand);
	
	if (camLefting)
	{
	FlxG.camera.scroll.x -= 60 * FlxG.elapsed;
	if (camLeftStart - FlxG.camera.scroll.x >= camLeftLen)
	{
		FlxG.camera.scroll.x = camLeftStart - camLeftLen;
		camLefting = false;
		
		boss2.x = bossP2.x;
		boss2.y = bossP2.y;
		boss2.play("walk");
		boss2.velocity.x = 40;
		boss2.acceleration.x = 20;
		bossRighting = true;
	}
	}
	
	if (bossRighting)
	{
	if (boss2.x >= bossP3.x)
	{
		bossRighting = false;
		boss2.velocity.make(0, 0);
		boss2.acceleration.make(0, 0);
		
		timer1.start(1, 1, function(t:FlxTimer):Void {
		for (t in tileLand._tileObjects)
		{
			t.mapIndex = 0;
			t.allowCollisions = FlxObject.NONE;
		}
		camDownStart = FlxG.camera.y;
		camDowning = true;
		boss2.acceleration.y = 100;
		});
	}
	}
	
	if (camDowning)
	{
	FlxG.camera.scroll.y += 70 * FlxG.elapsed;
	if (FlxG.camera.y - camDownStart > camDownLen)
	{
		camDowning = false;
		timer1.start(1, 1, function(t:FlxTimer):Void {
		for(t in tileLand2._tileObjects)
		{
			t.mapIndex = 0;
			t.allowCollisions = FlxObject.NONE;
			timer1.start(1, 1, function(t:FlxTimer):Void {
			camRighting = true;
			camRightStart = FlxG.camera.x;
			bot.velocity.x = 30;
			});
		}
		});
	}
	}
	
	if (camRighting)
	{
	FlxG.camera.scroll.x += 60 * FlxG.elapsed;
	if (camRightStart - FlxG.camera.x > camRightLen)
	{
		camRighting = false;	
	}
	}
	
	// lvl End
	if (bot.x >= end.x)
	{
	FlxG.fade(0xff888888, 2, function():Void {
		if (GameStatic.ProcLvl < 4) GameStatic.ProcLvl = 4;
		FlxG.switchState(new Level5());
	});
	}
	
	if (FlxG.overlap(bot, com1 ) && FlxG.keys.justPressed(bot.actionKey))
	{
		com1.onTig();
		FlxG.camera.shake(0.01, 2.0);
		bot.facing = FlxObject.LEFT;
		FlxG.camera.follow(null);
		camLeftStart = FlxG.camera.scroll.x;
		camLefting = true;
	}
	
	if (FlxG.overlap(bot, door1) && FlxG.keys.justPressed(bot.actionKey))
	{
	door2.Colse(bot);
	}
	super.update();
}

public function openDoor():Void
{
	door1.Unlock();
}
}