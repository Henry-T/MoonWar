package;
import org.flixel.FlxG;
import org.flixel.FlxObject;

class Level1 extends Level
{
public function new()
{
	super();
	
	tileXML = nme.Assets.getText("assets/dat/level1.tmx");

	lines1 = [
		new Line(0, "CubeBot, it will be battle field soon outside the laboratory."),
		new Line(0, "We will have some test to ensure you are in good condition."),
		new Line(0, "Your tips are printed on screens, go for it now."),
		new Line(1, "OK.")
	];

	lines2 = [
		new Line(0, "Well, the war comes in advance."),
		new Line(1, "I can use them to warm up.")
	];
}

override public function create():Void
{
	super.create();
	
	GameStatic.CurLvl = 1;
	
	tile.follow();
	
	bot.x = 50; bot.y = 150;
	
	FlxG.camera.follow(bot);
	
	AddAll();
}

override public function update():Void
{
	super.update();
	FlxG.overlap(bot, end, function(b:FlxObject, e:FlxObject) { 
		FlxG.fade(0xff000000, 2, function() { 
			if (GameStatic.ProcLvl < 1) 
				GameStatic.ProcLvl = 1; 
			FlxG.switchState(new Win());
		});
	});
}

public function showTip(bot:Bot, tip:Tip1):Void
{
	tip.shown = true;
}
}