package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import nme.display.BitmapData;
import mochi.as3.MochiAd;
import mochi.as3.MochiServices;

class MainMenu extends GameScreen
{
	public var bgImage:FlxSprite;
	public var startBtn:FlxButton;
	public var btnMap:FlxButton;
	public var btnClearData:FlxButton;
	public var ss:SliceShape;

	public var btnGNormal:BitmapData;
	public var btnGOver:BitmapData;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		this.bgColor = 0xffff00ff;

		btnGNormal = new SliceShape(0, 0 ,150, 30, "assets/img/ui_box.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		btnGOver =  new SliceShape(0, 0 , 150, 30, "assets/img/ui_boxact.png", SliceShape.MODE_BOX, 3).pixels.clone(); 

		bgImage = new FlxSprite(0, 0, "assets/img/title.png");
		this.add(bgImage);

		ss = new SliceShape(0,0, 550, 400,"assets/img/ui_center2.png", SliceShape.MODE_CENTER, 1);
		//add(ss);
		
		startBtn = new FlxButton(100 ,190,"START",function(){FlxG.switchState(new IntroScreen());});
		startBtn.loadGraphic(btnGNormal); startBtn.x = FlxG.width / 2 - startBtn.width / 2;
		startBtn.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		startBtn.onOver = function() { startBtn.loadGraphic(btnGOver); FlxG.play("assets/snd/sel1.mp3"); };
		startBtn.onOut = function(){startBtn.loadGraphic(btnGNormal);};
		
		btnMap = new FlxButton(100, 240, "LEVEL", function():Void { FlxG.switchState(new GameMap()); } );
		btnMap.loadGraphic(btnGNormal); btnMap.x = FlxG.width / 2 - btnMap.width / 2;
		btnMap.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnMap.onOver = function(){btnMap.loadGraphic(btnGOver); FlxG.play("assets/snd/sel1.mp3");};
		btnMap.onOut = function(){btnMap.loadGraphic(btnGNormal);};
		
		btnClearData = new FlxButton(100, 290, "ABOUT", function() { GameStatic.ClearSavedData(); } );
		btnClearData.loadGraphic(btnGNormal); btnClearData.x = FlxG.width / 2 - btnClearData.width / 2;
		btnClearData.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnClearData.onOver = function(){btnClearData.loadGraphic(btnGOver); FlxG.play("assets/snd/sel1.mp3");};
		btnClearData.onOut = function(){btnClearData.loadGraphic(btnGNormal);};
		
		add(startBtn);
		add(btnMap);
		add(btnClearData);

		// testing 
		ss = new SliceShape(0,0, 200, 200,"assets/img/slice1.png", SliceShape.MODE_BOX, 5);
		//add(ss);
		//ss.setSize(100, 100);

		ss = new SliceShape(30, 80 ,100, 50, "assets/img/ui_boxact.png", SliceShape.MODE_BOX, 3);
		//add(ss);

		ss = new SliceShape(0, 300, 550, 40, "assets/img/ui_barh.png", SliceShape.MODE_HERT, 1);
		//add(ss);

		ss = new SliceShape(500, 0, 30, 400, "assets/img/ui_barv.png", SliceShape.MODE_VERTICLE, 1);
		//add(ss);

		ResUtil.playTitle();	
	}
}