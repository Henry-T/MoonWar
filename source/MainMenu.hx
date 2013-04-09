package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class MainMenu extends GameScreen
{


public var bgImage:FlxSprite;
public var startBtn:FlxButton;
public var btnMap:FlxButton;
public var btnClearData:FlxButton;

public function new()
{
	super();
}

override public function create():Void
{
	super.create();
	bgImage = new FlxSprite(0, 0, "assets/img/mainmenu.png");
	this.add(bgImage);
	
	startBtn = new FlxButton(100,100,"START",onStart);
	startBtn.color =  0x729954;
	startBtn.label.color = 0xffd8eba2;
	add(startBtn);
	
	btnMap = new FlxButton(100, 140, "MAP", function():Void { FlxG.switchState(new GameMap()); } );
	add(btnMap);
	
	btnClearData = new FlxButton(100, 180, "CLEAR DATA", function() { GameStatic.ClearSavedData(); } );
	add(btnClearData);
	
	ResUtil.playTitle();
}

public function onStart() : Void
{
	FlxG.switchState(new IntroScreen());
}
}