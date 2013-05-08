package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import nme.display.BitmapData;
import mochi.as3.MochiAd;
import mochi.as3.MochiServices;

class MainMenu extends GameScreen
{
	public var bgImage:FlxSprite;
	public var imgBoss:FlxSprite;
	public var imgMoon:FlxSprite;
	public var imgTitleTxt:FlxSprite;
	public var startBtn:FlxButton;
	public var btnMap:FlxButton;
	public var btnClearData:FlxButton;
	public var ss:SliceShape;

	public var btnGNormal:BitmapData;
	public var btnGOver:BitmapData;

	public var txtCreator:FlxText;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		this.bgColor = 0xff000000;

		btnGNormal = new SliceShape(0, 0 ,150, 30, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		btnGOver =  new SliceShape(0, 0 , 150, 30, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 

		bgImage = new FlxSprite(0, 0, "assets/img/title.png");
		imgBoss = new FlxSprite(0, 0,"assets/img/titleBoss.png");
		imgBoss.x = FlxG.width * 0.5 - imgBoss.width * 0.5; imgBoss.y = 5;
		imgMoon = new FlxSprite(0, 0,"assets/img/titleMoon.png");
		imgMoon.x = FlxG.width * 0.5 - imgMoon.width * 0.5; imgMoon.y = FlxG.height - imgMoon.height + 5;
		imgTitleTxt = new FlxSprite(0, 0,"assets/img/titleText.png");
		imgTitleTxt.x = FlxG.width * 0.5 - imgTitleTxt.width * 0.5; imgTitleTxt.y = 5;
		//add(bgImage);
		add(imgBoss);
		add(imgMoon);
		add(imgTitleTxt);

		startBtn = new FlxButton(100 ,190,"START",function(){FlxG.switchState(new IntroScreen());});
		startBtn.loadGraphic(btnGNormal); startBtn.x = FlxG.width / 2 - startBtn.width / 2;
		startBtn.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		startBtn.onOver = function() { startBtn.loadGraphic(btnGOver); FlxG.play("sel1"); };
		startBtn.onOut = function(){startBtn.loadGraphic(btnGNormal);};
		
		btnMap = new FlxButton(100, 240, "LEVEL", function():Void { FlxG.switchState(new GameMap()); } );
		btnMap.loadGraphic(btnGNormal); btnMap.x = FlxG.width / 2 - btnMap.width / 2;
		btnMap.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnMap.onOver = function(){btnMap.loadGraphic(btnGOver); FlxG.play("sel1");};
		btnMap.onOut = function(){btnMap.loadGraphic(btnGNormal);};
		
		btnClearData = new FlxButton(100, 290, "HELP", function() { FlxG.switchState(new HelpScreen()); } );
		btnClearData.loadGraphic(btnGNormal); btnClearData.x = FlxG.width / 2 - btnClearData.width / 2;
		btnClearData.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnClearData.onOver = function(){btnClearData.loadGraphic(btnGOver); FlxG.play("sel1");};
		btnClearData.onOut = function(){btnClearData.loadGraphic(btnGNormal);};

		txtCreator = new FlxText(0, FlxG.height-15, FlxG.width, "Created By Lolofinil\t\tMusic By www.nosoapradio.us");
		txtCreator.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");
		txtCreator.scrollFactor.make(0, 0);
		
		add(startBtn);
		add(btnMap);
		add(btnClearData);
		add(btnMute);
		add(txtCreator);

		// testing 
		ss = new SliceShape(0,0, 200, 200,"assets/img/ui_slice_b.png", SliceShape.MODE_BOX, 5);
		//add(ss);
		//ss.setSize(100, 100);

		ss = new SliceShape(30, 80 ,100, 50, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3);
		//add(ss);

		ss = new SliceShape(0, 300, 550, 40, "assets/img/ui_barh_b.png", SliceShape.MODE_HERT, 1);
		//add(ss);

		ss = new SliceShape(500, 0, 30, 400, "assets/img/ui_barv_b.png", SliceShape.MODE_VERTICLE, 1);
		//add(ss);

		ResUtil.playTitle();	
	}

	public override function update(){
		super.update();
		#if debug 
		#if !FLX_NO_KEYBOARD
		if(FlxG.keys.T){
			FlxG.switchState(new LevelTest());
		}
		#end
		#end
	}
}