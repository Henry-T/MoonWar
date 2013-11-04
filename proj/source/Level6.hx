package ;
import flixel.util.FlxRect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxObject;
import org.flixel.tmx.TmxObjectGroup;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;

class Level6 extends Level 
{
	public var botRighting:Bool;
	public var botPos1:FlxPoint;

	public var downing:Bool;
	public var downing2:Bool;

	public var camFixOn:Bool;
	public var camFixPos:FlxPoint;

	public function new()
	{
		super();
		tileXML = openfl.Assets.getText("assets/dat/level6.tmx");

		lines1 = [
			new Line(0,"CubeBot, this is entrance to Inner Base."),
			new Line(0,"We lost connetion with the base during your way here."),
			new Line(1,"I can manage entering."),
		];
	}

	public override function create():Void
	{
		super.create();
		
		GameStatic.CurLvl = 5;
		
		var os:TmxObjectGroup = tmx.getObjectGroup("misc");
		for(to in os.objects)
		{
			if (to.name == "bPos1")
				botPos1 = new FlxPoint(to.x, to.y);
			else if (to.name == "door1")
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
			else if (to.type == "com")
			{
				var com:Com = cast(coms.recycle(Com), Com);
				com.make(to);
				if(to.name == "comOut")
					com.onTig = function() { door2Down.Unlock(); };
			}
			else if(to.name == "camFix"){
				camFixPos = new FlxPoint(to.x, to.y);
			}
		}
		
		bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift_l.png"); 
		
		bd1 = new FlxBackdrop("assets/img/metal.png", 0.2, 0.2, true, true);

		AddAll();
		
		// initial scene
		FlxG.camera.follow(bot);
		bot.On = false;
		bot.facing = FlxObject.LEFT;

		bInLift.velocity.y = Level.liftSpeed;
		downing = true;
		downing2 = false;

		FlxG.camera.flash(0xff000000, 2);
		ResUtil.playGame1();
		camFixOn = false;
		ShowSceneName("6 - LASER PATH");
	}

	override public function update():Void 
	{
		super.update();
		if((confirm.visible&&confirm.isModel)
		 || FlxG.paused || endPause)	return;

		if(bot.x < camFixPos.x)
			camFixOn = true;
		else 
			camFixOn = false;

		if(camFixOn){
			if(FlxG.camera.scroll.y < camFixPos.y)
				FlxG.camera.scroll.y = camFixPos.y;
		}
		
		// Start
		if (downing && bInLift.y > door1Up.y - 20 /*bot.velocity.y==0*/)
		{
			bInLift.velocity.y = 0;
			bot.EnableG(true);
			door1Up.Unlock();
		}
		if (door1Up.open && downing && !downing2)
		{
			downing = false;
			//bot.On = true;
			TimerPool.Get().run(0.5, function(t:FlxTimer){
				lineMgr.Start(lines1, function(){
					bot.On = true;
					hpBar.visible = true;
				});
			});
		}
		
		// End
		if (FlxG.overlap(door2Up, bot) && door2Down.open && input.JustDown_Action && bot.On)
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
		}
		if (!isEnd && bInLift2.y > end.y){
			EndLevel(true);
		}
	}
}