package ;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;
import org.flixel.FlxObject;
import org.flixel.tmx.TmxObjectGroup;
import org.flixel.addons.FlxBackdrop;

class Level5 extends Level 
{
	public var botRighting:Bool;
	public var botPos1:FlxPoint;

	public var comRect:FlxRect;
	public var doorPos:FlxPoint;
	
	public var downing2:Bool;

	public function new()
	{
		super();
		tileXML = nme.Assets.getText("assets/dat/level5.tmx");
	}

	override public function create():Void 
	{
		super.create();
		
		GameStatic.CurLvl = 4;
		
		var os:TmxObjectGroup = tmx.getObjectGroup("misc");
		for ( to in os.objects)
		{
			if (to.name == "bPos1")
				botPos1 = new FlxPoint(to.x, to.y);
			else if (to.name == "comOut")
			{
				var c = cast(coms.recycle(Com), Com);
				c.make(to);
				c.SetOn(false);
				c.onTig = function(){ door2Down.Unlock(); };
			}
			else if (to.name == "door1")
			{
			}
			else if (to.name == "door2")
			{
				doorPos = new FlxPoint(to.x, to.y);
				door2Down = new LDoor(doorPos.x, doorPos.y, true);
				door2Up = new LDoor(doorPos.x, doorPos.y, false);
			}
		}
		
		bInLift2 = new FlxSprite(doorPos.x-10, doorPos.y-6, "assets/img/bInLift_l.png");
		
		bd1 = new FlxBackdrop("assets/img/metal.png", 0.2, 0.2, true, true);

		bot.x = start.x; bot.y = start.y;
		
		AddAll();
		
		// initial
		FlxG.flash(0xff000000, 2);
		FlxG.camera.follow(bot);
		ResUtil.playGame1();
		bot.facing = FlxObject.RIGHT;
		botRighting = true;
		ShowSceneName("5 - SPARE CHANNEL");
	}

	override public function update():Void 
	{
		super.update();
		if((confirm.visible&&confirm.isModel)
		 || FlxG.paused || endPause)	return;
		
		if (botRighting)
		{
			if (bot.x > botPos1.x)
			{
				botRighting = false;
				bot.velocity.x = 0;
				hpBar.visible = true;
			}
			else
				bot.velocity.x = 60;	
		}
		
		// End of Level
		if (FlxG.overlap(bot, door2Down) && door2Down.open && input.JustDown_Action && bot.On)
		{
			if((bot.x > door2Down.x + 5) && (bot.x + bot.width < door2Down.x + door2Down.width - 5)){
				door2Up.Colse(bot);
				bot.On = false;
			}
		}
		if (!downing2 && door2Up.locked)
		{
			downing2 = true;
			bInLift2.velocity.y = Level.liftSpeed;
			bot.active = false;
		}
		
		if (!isEnd && bInLift2.y > end.y){
			EndLevel(true);
		}
	}
}