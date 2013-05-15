package;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import nme.display.BitmapData;
import mochi.as3.MochiAd;
import mochi.as3.MochiServices;
import org.flixel.addons.FlxBackdrop;

class MainMenu extends MWState
{
	public var bdSky:FlxBackdrop;
	public var bgImage:FlxSprite;
	public var imgBoss:FlxSprite;
	public var imgMoon:FlxSprite;
	public var imgTitleTxt:FlxSprite;
	public var startBtn:MyButton;
	public var btnMap:MyButton;
	public var btnClearData:MyButton;

	public var txtCreator:MyText;

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

		bgImage = new FlxSprite(0, 0, "assets/img/title.png");
		bdSky = new FlxBackdrop("assets/img/bgSky.png", 0, 0, true, true);
		imgBoss = new FlxSprite();
		imgMoon = new FlxSprite();
		imgTitleTxt = new FlxSprite();
		if(GameStatic.screenDensity == GameStatic.Density_S){
			imgBoss.loadGraphic("assets/img/s_boss_S.png");
			imgMoon.loadGraphic("assets/img/s_moon_S.png");
			imgTitleTxt.loadGraphic("assets/img/s_ttxt_S.png");
		}
		else if(GameStatic.screenDensity == GameStatic.Density_M){
			imgBoss.loadGraphic("assets/img/s_boss_M.png");
			imgMoon.loadGraphic("assets/img/s_moon_M.png");
			imgTitleTxt.loadGraphic("assets/img/s_ttxt_M.png");
		}
		else if(GameStatic.screenDensity == GameStatic.Density_L){
			imgBoss.loadGraphic("assets/img/s_boss_L.png");
			imgMoon.loadGraphic("assets/img/s_moon_L.png");
			imgTitleTxt.loadGraphic("assets/img/s_ttxt_L.png");
		}
		imgBoss.x = FlxG.width * 0.5 - imgBoss.width * 0.5; imgBoss.y = 5;
		imgMoon.x = FlxG.width * 0.5 - imgMoon.width * 0.5; imgMoon.y = FlxG.height - imgMoon.height + 5;
		imgTitleTxt.x = FlxG.width * 0.5 - imgTitleTxt.width * 0.5; imgTitleTxt.y = 5;
		//add(bgImage);
		add(bdSky);
		add(imgBoss);
		add(imgMoon);
		add(imgTitleTxt);

		startBtn = new MyButton(0 ,0,"START",function(){FlxG.switchState(new IntroScreen());});
		startBtn.loadGraphic(ResUtil.bmpBtnBMainNormal);
		startBtn.x = GameStatic.widthH - startBtn.width*0.5;
		startBtn.y = GameStatic.heightH - startBtn.height*1.4;
		startBtn.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		startBtn.onOver = function() { startBtn.loadGraphic(ResUtil.bmpBtnBMainOver); FlxG.play("sel1"); };
		startBtn.onOut = function(){startBtn.loadGraphic(ResUtil.bmpBtnBMainNormal);};
		
		btnMap = new MyButton(0, 0, "LEVEL", function():Void { FlxG.switchState(new GameMap()); } );
		btnMap.loadGraphic(ResUtil.bmpBtnBMainNormal); btnMap.x = FlxG.width / 2 - btnMap.width / 2;
		btnMap.x = GameStatic.widthH - startBtn.width*0.5;
		btnMap.y = GameStatic.heightH;
		btnMap.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnMap.onOver = function(){btnMap.loadGraphic(ResUtil.bmpBtnBMainOver); FlxG.play("sel1");};
		btnMap.onOut = function(){btnMap.loadGraphic(ResUtil.bmpBtnBMainNormal);};
		
		btnClearData = new MyButton(0, 0, "HELP", function() { FlxG.switchState(new HelpScreen()); } );
		btnClearData.loadGraphic(ResUtil.bmpBtnBMainNormal); btnClearData.x = FlxG.width / 2 - btnClearData.width / 2;
		btnClearData.x = GameStatic.widthH - btnClearData.width*0.5;
		btnClearData.y = GameStatic.heightH + btnClearData.height*1.4;
		btnClearData.label.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffff, "center");
		btnClearData.onOver = function(){btnClearData.loadGraphic(ResUtil.bmpBtnBMainOver); FlxG.play("sel1");};
		btnClearData.onOut = function(){btnClearData.loadGraphic(ResUtil.bmpBtnBMainNormal);};

		#if !FLX_NO_KEYBOARD
		selector = new FlxSprite(ResUtil.bmpSelMain);
		#end

		txtCreator = new MyText(0, FlxG.height-15, FlxG.width, "Created By Lolofinil\t\tMusic By www.nosoapradio.us");
		txtCreator.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");
		txtCreator.scrollFactor.make(0, 0);
		txtCreator.y = FlxG.height - txtCreator.GetTextHeight() - 1;
		
		#if !FLX_NO_KEYBOARD
		add(selector);
		#end

		add(startBtn);
		add(btnMap);
		add(btnClearData);
		add(btnMute);
		add(txtCreator);
		add(confirm);

		// Initial
		ResUtil.playTitle();
		#if !FLX_NO_KEYBOARD
		selId = 0;
		ChangeSel(0);
		confirm.ShowConfirm(Confirm.Mode_TextOnly, false, "Keyboard Arrow UP/DOWN to Select, X to Start", "", "", false, null, null);
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
			selector.x = startBtn.x+GameStatic.offset_border; selector.y = startBtn.y+GameStatic.offset_border;
		case 1:
			selector.x = btnMap.x+GameStatic.offset_border; selector.y = btnMap.y+GameStatic.offset_border;
		case 2:
			selector.x = btnClearData.x+GameStatic.offset_border; selector.y = btnClearData.y+GameStatic.offset_border;
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