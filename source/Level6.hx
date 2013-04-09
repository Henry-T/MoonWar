package ;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;
import org.flixel.tmx.TmxObjectGroup;

class Level6 extends Level 
{


public var botRighting:Bool;
public var botPos1:FlxPoint;

public var comRect:FlxRect;

public var doorPos:FlxPoint;
public var doorPos2:FlxPoint;

public var downing:Bool;
public var botColOn:Bool;

public var downing2:Bool;

public function new()
{
	super();
	tileXML = nme.Assets.getText("assets/dat/level6.tmx");
}

public override function create():Void
{
	super.create();
	
	GameStatic.CurLvl = 6;
	
	var os:TmxObjectGroup = tmx.getObjectGroup("misc");
	for(to in os.objects)
	{
	if (to.name == "bPos1")
		botPos1 = new FlxPoint(to.x, to.y);
	else if (to.name == "com1")
		comRect = new FlxRect(to.x, to.y, to.width, to.height);
	else if (to.name == "door1")
	{
		doorPos = new FlxPoint(to.x, to.y);
		door1 = new LDoor(doorPos.x, doorPos.y, true);
	}
	else if (to.name == "door2")
	{
		doorPos2 = new FlxPoint(to.x, to.y);
		door2 = new LDoor(doorPos2.x, doorPos2.y, true);
		door3 = new LDoor(doorPos2.x, doorPos2.y, false);
	}
	}
	
	bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift.png"); 
	bInLift2 = new FlxSprite(doorPos2.x - 10, doorPos2.y - 6, "assets/img/bInLift.png"); 
	
	bot = new Bot(doorPos.x + 10,doorPos.y,bullets);
	
	AddAll();
	
	// initial scene
	FlxG.camera.follow(bot);
	tile.follow();
	//bot.EnableG(false);
	//bot.velocity.y = 30;
	bot.On = false;
	bInLift.velocity.y = 30;
	downing = true;
	botColOn = false;
	downing2 = false;
	FlxG.flash(0xff000000, 2);
	ResUtil.playGame2();
}

override public function update():Void 
{
	super.update();
	
	if (downing && bInLift.y > doorPos.y /*bot.velocity.y==0*/)
	{
	bInLift.velocity.y = 0;
	bot.EnableG(true);
	door1.Unlock();
	}

	if (door1.open && downing && !downing2)
	{
	downing = false;
	bot.On = true;
	}
	
	if (FlxG.overlap(com1, bot) && door2.locked && FlxG.keys.justPressed(bot.actionKey))
	{
	door2.Unlock();
	}
	
	if (FlxG.overlap(door2, bot) && door2.open && FlxG.keys.justPressed(bot.actionKey))
	{
	door3.Colse(bot);
	}
	
	if (!downing2 && door3.locked)
	{
	bot.On = false;
	bot.EnableG(false);
	bot.velocity.y = 30;
	bInLift2.velocity.y = 30;
	downing2 = true;
	}
	
	if (bot.y > end.y)
	{
	FlxG.fade(0xff000000, 1, function():Void {
		if (GameStatic.ProcLvl < 6) GameStatic.ProcLvl = 6;
		FlxG.switchState(new Level7());
	});
	}
}
}