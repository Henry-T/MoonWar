package;
import org.flixel.FlxSprite;
import nme.display.BitmapData;
import org.flixel.FlxButton;
import org.flixel.FlxText;
import org.flixel.FlxG;

class AboutScreen extends GameScreen
{
	public var bg:FlxSprite;

	public var mainPnl:SliceShape;
	public var bottomPnl:SliceShape;
	public var btnGBigNormal:BitmapData;
	public var btnGBigOver:BitmapData;
	public var btnBack:FlxButton;

	public var txtMusic:FlxText;
	public var txtMusicBy:FlxText;
	public var txtCreated:FlxText;
	public var txtCreatedBy:FlxText;

	public function new(){
		super();
	}

	override public function create():Void 
	{
		super.create();

		bg = new FlxSprite("assets/img/bgStar.png");
		mainPnl = new SliceShape(0,0, 350, 300, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3);
		mainPnl.x = FlxG.width*0.5 - mainPnl.width*0.5;
		mainPnl.y = FlxG.height*0.5 - mainPnl.height*0.5;

		bottomPnl = new SliceShape(0, 350, 560, 40, "assets/img/ui_barh_y.png", SliceShape.MODE_HERT, 1);
		btnGBigNormal = new SliceShape(0,0, 100, 25, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGBigOver = new SliceShape(0,0, 100, 25, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnBack = new FlxButton(0, 0, "BACK", function() { FlxG.switchState(new MainMenu()); } );
		btnBack.loadGraphic(btnGBigNormal);
		btnBack.onOver = function(){btnBack.loadGraphic(btnGBigOver);};
		btnBack.onOut = function(){btnBack.loadGraphic(btnGBigNormal);};
		btnBack.x = FlxG.width * 0.5 - btnBack.width/2;
		btnBack.y = FlxG.height * 0.90;
		btnBack.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");

		txtCreated = new FlxText(0,0,120, "Created By");
		txtCreated.setFormat("assets/fnt/pixelex.ttf", 10, 0xffdddddd, "right");
		txtCreated.x = FlxG.width * 0.5 - txtCreated.width - 10;
		txtCreated.y = FlxG.height * 0.5 - 50;

		txtCreatedBy = new FlxText(0,0,120, "Lolofinil");
		txtCreatedBy.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "left");
		txtCreatedBy.x = FlxG.width * 0.5 + 10;
		txtCreatedBy.y = FlxG.height * 0.5 - 50;

		txtMusic = new FlxText(0,0,120, "Music By");
		txtMusic.setFormat("assets/fnt/pixelex.ttf", 10, 0xffdddddd, "right");
		txtMusic.x = FlxG.width * 0.5 - txtMusic.width - 10;
		txtMusic.y = FlxG.height * 0.5 + 50;

		txtMusicBy = new FlxText(0,0, 150, "www.nosoapradio.us");
		txtMusicBy.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "left");
		txtMusicBy.x = FlxG.width * 0.5 + 10;
		txtMusicBy.y = FlxG.height * 0.5 + 50;

		add(bg);
		add(mainPnl);
		add(txtCreated);
		add(txtCreatedBy);
		add(txtMusic);
		add(txtMusicBy);
		add(bottomPnl);
		add(btnBack);
	}
}