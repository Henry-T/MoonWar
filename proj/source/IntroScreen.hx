package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxText;

class IntroScreen extends GameScreen
{
	public var id:Int;
	public var maxId:Float;
	public var img1:FlxSprite;
	public var img2:FlxSprite;
	public var lastBtn:FlxButton;
	public var nextBtn:FlxButton;
	public var text:FlxText;
	public var lines:Array<String>;

	public function new()
	{
		super();

		lines = [
			"Human setup a science explore base on Moon for a short time",
			"One day a invader want to take control of the defencless moon",
			"With a whole army",
			"Dr.Cube arm his little bot with weapon to fight back"];
	}

	override public function create():Void
	{
		id = 0;
		maxId = 1;
		img1 = new FlxSprite();
		img1.loadGraphic("assets/img/intro1.png");
		img2 = new FlxSprite();
		img2.loadGraphic("assets/img/intro2.png");
		img2.visible = false;
		lastBtn = new FlxButton(0, FlxG.height - 25, "Menu", onLast);
		nextBtn = new FlxButton(FlxG.width - 100, FlxG.height - 25, "Next", onNext);
		text = new FlxText(FlxG.width/2 - 250, 15, 500, lines[0], 10);
		text.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");

		add(img1);
		add(img2);
		add(lastBtn);
		add(nextBtn);
		add(text);
	}

	public function onLast():Void
	{
		if(id > 0)
		{
			id --;
			refreshImg();
		}
		else
		{
			FlxG.switchState(new MainMenu());
		}
		text.text = lines[id];
	}

	public function onNext():Void
	{
		if(id < maxId)
		{
			id++;
			refreshImg();
		}
		else
		{
			FlxG.switchState(new Level1());
		}
		text.text = lines[id];
	}

	public function refreshImg():Void
	{
		if(id == 0)
		{
			img1.visible = true;
			img2.visible = false;
		}
		else if(id == 1)
		{
			img1.visible = false;
			img2.visible = true;
		}
		
		if(id == 0)
			lastBtn.label.text = "Menu";
		else
			lastBtn.label.text = "Last";
		
		if(id == maxId)
			nextBtn.label.text = "Start";
		else
			nextBtn.label.text = "Next";
	}
}