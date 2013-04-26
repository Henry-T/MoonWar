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

	public var downing:Bool;
	public var botColOn:Bool;

	public var downing2:Bool;

	public function new()
	{
		super();
		tileXML = nme.Assets.getText("assets/dat/level6.tmx");

		lines1 = [
			new Line(0,"CubeBot, this is entrance to Inner Base."),
			new Line(0,"We lost connetion with the base during your way here."),
			new Line(1,"I can manage entering."),
		];
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
			else if (to.name == "door1")
			{
				bot.x = to.x+10; bot.y = to.y;
				door1Up = new LDoor(to.x, to.y, false);
			}
			else if (to.name == "door2")
			{
				door2Up = new LDoor(to.x, to.y, false);
				door2Down = new LDoor(to.x, to.y, true);
				bInLift2 = new FlxSprite(to.x - 10, to.y - 6, "assets/img/bInLift.png"); 
			}
			else if (to.type == "com")
			{
				var com:Com = cast(coms.recycle(Com), Com);
				com.make(to);
				if(to.name == "comOut")
					com.onTig = function() { door2Down.Unlock(); };
			}
		}
		
		bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift.png"); 
		
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
		
		// Start
		if (downing && bInLift.y > door1Up.y /*bot.velocity.y==0*/)
		{
			bInLift.velocity.y = 0;
			bot.EnableG(true);
			door1Up.Unlock();
		}
		if (door1Up.open && downing && !downing2)
		{
			downing = false;
			bot.On = true;
		}
		
		// End
		if (FlxG.overlap(door2Up, bot) && door2Down.open && FlxG.keys.justPressed(bot.actionKey))
		{
			door2Up.Colse(bot);
			bot.On = false;
		}
		if (!downing2 && door2Up.locked)
		{
			bInLift2.velocity.y = 30;
			downing2 = true;
		}
		if (bInLift2.y > end.y)
		{
			FlxG.fade(0xff000000, 1, function():Void {
				if (GameStatic.ProcLvl < 6) GameStatic.ProcLvl = 6;
			EndLevel(true);
			});
		}
	}
}