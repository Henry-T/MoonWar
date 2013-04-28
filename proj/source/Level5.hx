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
		
		bInLift2 = new FlxSprite(doorPos.x-10, doorPos.y-6, "assets/img/bInLift.png");
		
		bot.x = start.x; bot.y = start.y;
		
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
		
		if (FlxG.overlap(bot, door2Down) && door2Down.open && FlxG.keys.justPressed(bot.actionKey))
		{
			door2Up.Colse(bot);
			bot.On = false;
		}
		if (door2Up.locked)
		{
			bInLift2.visible = true;
			bInLift2.velocity.y = 30;
			bot.active = false;
		}
		
		if (!isEnd && bInLift2.y > end.y){
			EndLevel(true);
		}
	}
}