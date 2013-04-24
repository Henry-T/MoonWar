package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class IntroScreen extends GameScreen
{



public var id:Float;
public var maxId:Float;
public var img1:FlxSprite;
public var img2:FlxSprite;
public var lastBtn:FlxButton;
public var nextBtn:FlxButton;

public function new()
{
	super();
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
	
	add(img1);
	add(img2);
	add(lastBtn);
	add(nextBtn);
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
	FlxG.switchState(new Level2());
	}
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