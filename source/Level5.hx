package ;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;
import org.flixel.tmx.TmxObjectGroup;

class Level5 extends Level 
{

public var botRighting:Bool;
public var botPos1:FlxPoint;

public var comRect:FlxRect;
public var doorPos:FlxPoint;

public function new()
{
	super();
	tileXML = nme.Assets.getText("assets/dat/level5.tmx");
}

override public function create():Void 
{
	super.create();
	
	GameStatic.CurLvl = 5;
	
	var os:TmxObjectGroup = tmx.getObjectGroup("misc");
	for ( to in os.objects)
	{
	if (to.name == "bPos1")
		botPos1 = new FlxPoint(to.x, to.y);
	else if (to.name == "com1")
	{
		com1 = new Com(to.x, to.y, to.width, to.height);
	}
	else if (to.name == "door1")
		doorPos = new FlxPoint(to.x, to.y);
	}
	
	bInLift = new FlxSprite(doorPos.x-10, doorPos.y-6, "assets/img/bInLift.png");
	door1 = new LDoor(doorPos.x, doorPos.y, true);
	door2 = new LDoor(doorPos.x, doorPos.y, false);
	
	bot = new Bot(start.x,start.y,bullets);
	
	AddAll();
	
	// initial
	FlxG.flash(0xff000000, 2);
	tile.follow();
	FlxG.camera.bounds.x += 80;
	FlxG.camera.bounds.width -= 80;
	FlxG.camera.follow(bot);
	//botRighting = true;
	ResUtil.playGame2();
}

override public function update():Void 
{
	super.update();
	
	if (botRighting)
	{
	if (bot.x > botPos1.x)
	{
		botRighting = false;
		bot.velocity.x = 0;
	}
	else
		bot.velocity.x = 60;	
	}
	
	if (FlxG.overlap(bot, com1))
	{
	if (FlxG.keys.justPressed(bot.actionKey))
	{
		door1.Unlock();
	}
	}
	
	if (FlxG.overlap(bot, door1) && door1.open && FlxG.keys.justPressed(bot.actionKey))
	{
	door2.Colse(bot);
	bot.On = false;
	}
	
	if (door2.locked)
	{
	bInLift.visible = true;
	bInLift.velocity.y = 30;
	bot.active = false;
	}
	
	if (bInLift.y > end.y)
	{
	FlxG.fade(0xff000000, 1, function():Void {
		if (GameStatic.ProcLvl < 5) GameStatic.ProcLvl = 5;
		FlxG.switchState(new Level6());
	});
	}
}
}