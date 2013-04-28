package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxText;

class IntroScreen extends GameScreen
{
	public var id:Int;
	public var imgAry:Array<FlxSprite>;
	public var lastBtn:FlxButton;
	public var nextBtn:FlxButton;
	public var text:FlxText;
	public var lines:Array<String>;
	public static var imgCnt:Int = 4;

	public function new()
	{
		super();

		lines = [
			"Human setup a science explore base on Moon for a short time",
			"One day a invader want to take control of the defencless moon",
			"That is RageMetal with it's army",
			"Dr.Cube arm his little bot with weapon to fight back"];
	}

	override public function create():Void
	{
		imgAry = new Array<FlxSprite>();
		for (i in 0...4) {
			var name = "assets/img/intro" + i + ".png";
			var img:FlxSprite = new FlxSprite();
			img.loadGraphic(name);
			imgAry.push(img);
			add(img);
		}

		lastBtn = new FlxButton(0, FlxG.height - 25, "Menu", onLast);
		nextBtn = new FlxButton(FlxG.width - 100, FlxG.height - 25, "Next", onNext);
		text = new FlxText(FlxG.width/2 - 250, 15, 500, lines[0], 10);
		text.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");

		add(lastBtn);
		add(nextBtn);
		add(text);

		// initial
		id = 0;
		refreshImg();
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
		if(id < imgCnt-1)
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
		for (i in 0...imgCnt) {
			if(i == id)
				imgAry[i].visible = true;
			else 
				imgAry[i].visible = false;
		}

		if(id == 0)
			lastBtn.label.text = "Menu";
		else
			lastBtn.label.text = "Last";
		
		if(id == imgCnt)
			nextBtn.label.text = "Start";
		else
			nextBtn.label.text = "Next";
	}
}