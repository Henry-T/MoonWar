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

	bgImage = new FlxSprite(0, 0, "assets/img/title.png");
	this.add(bgImage);
	
	startBtn = new FlxButton(100 ,190,"",function(){FlxG.switchState(new IntroScreen());});
	startBtn.loadGraphic("assets/img/bStart.png"); startBtn.x = FlxG.width / 2 - startBtn.width / 2;
	startBtn.onOver = function() { startBtn.loadGraphic("assets/img/bStartOver.png"); FlxG.play("assets/snd/sel1.mp3"); };
	startBtn.onOut = function(){startBtn.loadGraphic("assets/img/bStart.png");};
	
	btnMap = new FlxButton(100, 240, "", function():Void { FlxG.switchState(new GameMap()); } );
	btnMap.loadGraphic("assets/img/bLevel.png"); btnMap.x = FlxG.width / 2 - btnMap.width / 2;
	btnMap.onOver = function(){btnMap.loadGraphic("assets/img/bLevelOver.png"); FlxG.play("assets/snd/sel1.mp3");};
	btnMap.onOut = function(){btnMap.loadGraphic("assets/img/bLevel.png");};
	
	btnClearData = new FlxButton(100, 290, "", function() { GameStatic.ClearSavedData(); } );
	btnClearData.loadGraphic("assets/img/bClear.png"); btnClearData.x = FlxG.width / 2 - btnClearData.width / 2;
	btnClearData.onOver = function(){btnClearData.loadGraphic("assets/img/bClearOver.png"); FlxG.play("assets/snd/sel1.mp3");};
	btnClearData.onOut = function(){btnClearData.loadGraphic("assets/img/bClear.png");};
	
	add(startBtn);
	add(btnMap);
	add(btnClearData);

	ResUtil.playTitle();
}
}