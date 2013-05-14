package ;
import org.flixel.system.FlxTile;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import flash.geom.Point;
import org.flixel.FlxTimer;
import org.flixel.FlxSprite;
import org.flixel.tmx.TmxObjectGroup;
import org.flixel.addons.FlxBackdrop;

class Level4 extends Level 
{
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

	public var breakShown:Bool;

	public var downing : Bool;
	public var downing2: Bool;

	public var coverOpen:Bool;
	
	public function new()
	{
		super();
		tileXML = nme.Assets.getText("assets/dat/level4.tmx");

		lines1 = [
			new Line(1,"Enemy spotted."),
			new Line(0,"RageMetal's force is dispersing in tunnel."),
			new Line(1,"Then I can handle them one by one."),
		];

		lines2 = [
			new Line(1,"The lift is broken."),
			new Line(0,"We can take the spare path, it is a little far throuth.")
		];

		//lines2 = [
		//	new Line(2,"Look, you don't have a lift anymore. See you!")
		//];

		//lines3 = [
		//	new Line(1,"It fled."),
		//	new Line(0,"We can take the spare path, it is a little far throuth.")
		///];
	}

	override public function create():Void 
	{
		super.create();
		
		GameStatic.CurLvl = 4;
		
		var os:TmxObjectGroup = tmx.getObjectGroup("misc");
		for (to in os.objects)
		{
			if (to.name == "door1")
			{
				bot.x = to.x+10; bot.y = to.y;
				door1Up = new LDoor(to.x, to.y, true);
			}
			else if (to.name == "door2")
			{
				door2Up = new LDoor(to.x, to.y, false);
				door2Down = new LDoor(to.x, to.y, true);
				bInLift2 = new FlxSprite(to.x - 10, to.y - 6, "assets/img/bInLift_r.png");
			}
			else if (to.name == "comOut")
			{
				var com:Com = cast(coms.recycle(Com), Com);
				com.make(to);
				com.onTig = function(){door2Down.Unlock();};
			}
			else if (to.name == "hmPos1")
				bossP1 = new FlxPoint(to.x, to.y);
			else if (to.name == "hmPos2")
				bossP2 = new FlxPoint(to.x, to.y);
			else if (to.name == "hmPos3")
				bossP3 = new FlxPoint(to.x, to.y);
		}
		
		bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift_r.png");

		bd1 = new FlxBackdrop("assets/img/metal.png", 0.2, 0.2, true, true);

		AddAll();
		
		// initial
		FlxG.camera.follow(bot);
		ResUtil.playGame1();
		breakShown = false;

		bot.On = false;
		bot.facing = FlxObject.RIGHT;

		bInLift.velocity.y = 30;
		downing = true;
		downing2 = false;
		FlxG.flash(0xff000000, 2);
		ShowSceneName("MAIN CHANNEL");
	}

	override public function update():Void
	{
		super.update();
		if(confirmReady || FlxG.paused || endPause)	return;

		if(!coverOpen)
			FlxG.collide(bot, tileCoverD);

		// Lift Broken Dialog
		if (FlxG.overlap(door2Up, bot) && door2Down.open && input.JustDown_Action && !breakShown && bot.On)
		{
			breakShown = true;
			bot.On = false;
			TimerPool.Get().start(2, 1, function(t:FlxTimer){
				lineMgr.Start(lines2, function(){
					coverOpen = true;
					tileCoverD.visible = false;
					bot.On = true;
				});
			});
		}

		// Start
		if (downing && bInLift.y > door1Up.y - 20)
		{
			bInLift.velocity.y = 0;
			door1Up.Unlock();
		}
		if (door1Up.open && downing)
		{
			downing = false;
			TimerPool.Get().start(1, 1, function(t:FlxTimer){
				lineMgr.Start(lines1, function(){
					bot.On = true;
					hpBar.visible = true;
				});
			});
		}
		
		// End of Level
		if(!isEnd && bot.x > end.x)
		{
			EndLevel(true);
		}
	}
}