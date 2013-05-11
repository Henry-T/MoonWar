package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import nme.display.BitmapData;
import mochi.as3.MochiAd;
import mochi.as3.MochiServices;
import org.flixel.addons.FlxBackdrop;

class MainMenu extends GameScreen
{
	public var bdSky:FlxBackdrop;
	public var bgImage:FlxSprite;
	public var imgBoss:FlxSprite;
	public var imgMoon:FlxSprite;
	public var imgTitleTxt:FlxSprite;
	public var startBtn:MyButton;
	public var btnMap:MyButton;
	public var btnClearData:MyButton;

	public var btnGNormal:BitmapData;
	public var btnGOver:BitmapData;
	public var selHighLight:BitmapData;

	public var txtCreator:FlxText;

	#if !FLX_NO_KEYBOARD
	public var selector:FlxSprite;
	public var selId:Int;
	#end

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		this.bgColor = 0xff000000;

		btnGNormal = new SliceShape(0, 0 ,GameStatic.button_mainWidth, GameStatic.button_mainHeight, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		btnGOver =  new SliceShape(0, 0 , GameStatic.button_mainWidth, GameStatic.button_mainHeight, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone(); 
		selHighLight = new SliceShape(0, 0 ,GameStatic.border_mainWidth, GameStatic.border_mainHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2).pixels.clone(); 

		bgImage = new FlxSprite(0, 0, "assets/img/title.png");
		bdSky = new FlxBackdrop("assets/img/bgSky.png", 0, 0, true, true);
		imgBoss = new FlxSprite(0, 0,"assets/img/titleBoss.png");
		imgBoss.x = FlxG.width * 0.5 - imgBoss.width * 0.5; imgBoss.y = 5;
		imgMoon = new FlxSprite(0, 0,"assets/img/titleMoon.png");
		imgMoon.x = FlxG.width * 0.5 - imgMoon.width * 0.5; imgMoon.y = FlxG.height - imgMoon.height + 5;
		imgTitleTxt = new FlxSprite(0, 0,"assets/img/titleText.png");
		imgTitleTxt.x = FlxG.width * 0.5 - imgTitleTxt.width * 0.5; imgTitleTxt.y = 5;
		//add(bgImage);
		add(bdSky);
		add(imgBoss);
		add(imgMoon);
		add(imgTitleTxt);

		startBtn = new MyButton(0 ,0,"START",function(){FlxG.switchState(new IntroScreen());});
		startBtn.loadGraphic(btnGNormal);
		startBtn.x = GameStatic.widthH - startBtn.width*0.5;
		startBtn.y = GameStatic.heightH - startBtn.height*1.4;
		startBtn.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		startBtn.onOver = function() { startBtn.loadGraphic(btnGOver); FlxG.play("sel1"); };
		startBtn.onOut = function(){startBtn.loadGraphic(btnGNormal);};
		
		btnMap = new MyButton(0, 0, "LEVEL", function():Void { FlxG.switchState(new GameMap()); } );
		btnMap.loadGraphic(btnGNormal); btnMap.x = FlxG.width / 2 - btnMap.width / 2;
		btnMap.x = GameStatic.widthH - startBtn.width*0.5;
		btnMap.y = GameStatic.heightH;
		btnMap.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnMap.onOver = function(){btnMap.loadGraphic(btnGOver); FlxG.play("sel1");};
		btnMap.onOut = function(){btnMap.loadGraphic(btnGNormal);};
		
		btnClearData = new MyButton(0, 0, "HELP", function() { FlxG.switchState(new HelpScreen()); } );
		btnClearData.loadGraphic(btnGNormal); btnClearData.x = FlxG.width / 2 - btnClearData.width / 2;
		btnClearData.x = GameStatic.widthH - btnClearData.width*0.5;
		btnClearData.y = GameStatic.heightH + btnClearData.height*1.4;
		btnClearData.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnClearData.onOver = function(){btnClearData.loadGraphic(btnGOver); FlxG.play("sel1");};
		btnClearData.onOut = function(){btnClearData.loadGraphic(btnGNormal);};

		#if !FLX_NO_KEYBOARD
		selector = new FlxSprite(selHighLight);
		#end

		txtCreator = new FlxText(0, FlxG.height-15, FlxG.width, "Created By Lolofinil\t\tMusic By www.nosoapradio.us");
		txtCreator.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");
		txtCreator.scrollFactor.make(0, 0);
		
		#if !FLX_NO_KEYBOARD
		add(selector);
		#end

		add(startBtn);
		add(btnMap);
		add(btnClearData);
		add(btnMute);
		add(txtCreator);

		ResUtil.playTitle();

		#if !FLX_NO_KEYBOARD
		selId = 0;
		ChangeSel(0);
		#end
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

		// Handle Keyboard Input
		#if !FLX_NO_KEYBOARD
		if(FlxG.keys.justPressed("UP")){
			ChangeSel(-1);
			FlxG.play("sel1");
		}
		else if(FlxG.keys.justPressed("DOWN")){
			ChangeSel(1);
			FlxG.play("sel1");
		}
		else if(FlxG.keys.justPressed("X")){
			SelAction(selId);
		}
		#end
	}

	#if !FLX_NO_KEYBOARD
	public function ChangeSel(delta:Int){
		selId += delta;
		while(selId < 0) selId+=3;
		while(selId >= 3) selId-=3;
		switch (selId) {
		case 0:
			selector.x = startBtn.x-2; selector.y = startBtn.y-2;
		case 1:
			selector.x = btnMap.x-2; selector.y = btnMap.y-2;
		case 2:
			selector.x = btnClearData.x-2; selector.y = btnClearData.y-2;
		}

	}

	public function SelAction(id:Int){
		switch (id) {
		case 0:
			FlxG.switchState(new IntroScreen());
		case 1:
			FlxG.switchState(new GameMap());
		case 2:
			FlxG.switchState(new HelpScreen());
		}
	}
	#end
}