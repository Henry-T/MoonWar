package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import mochi.as3.MochiAd;
import mochi.as3.MochiServices;

class MainMenu extends GameScreen
{
	public var bgImage:FlxSprite;
	public var startBtn:FlxButton;
	public var btnMap:FlxButton;
	public var btnClearData:FlxButton;
	public var ss:SliceShape;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		this.bgColor = 0xffff00ff;

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

		// testing 
		ss = new SliceShape(0,0, 200, 200,"assets/img/slice1.png", SliceShape.MODE_BOX, 5);
		add(ss);
		//ss.setSize(100, 100);

		ss = new SliceShape(30, 80 ,100, 50, "assets/img/ui_boxact.png", SliceShape.MODE_BOX, 3);
		add(ss);

		ResUtil.playTitle();	
	}
}