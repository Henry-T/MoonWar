package ;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import nme.display.BitmapData;


class GameMap extends GameScreen 
{
	public var lvlBtns:FlxGroup;
	public var btnIntro:FlxButton;
	public var btnLvl1:FlxButton;
	public var btnLvl2:FlxButton;
	public var btnLvl3:FlxButton;
	public var btnLvl4:FlxButton;
	public var btnLvl5:FlxButton;
	public var btnLvl6:FlxButton;
	public var btnLvl7:FlxButton;
	public var btnLvl8:FlxButton;
	public var btnEnd:FlxButton;
	public var btnMenu:FlxButton;
	public var btnStart:FlxButton;

	public var pic:FlxSprite;

	public var bg:FlxSprite;
	public var picBg:FlxSprite;

	public var missionTxt:FlxText;
	public var descTxt:FlxText;

	public var leftPnl:SliceShape;
	public var bottomPnl:SliceShape;
	public var picPnl:SliceShape;

	public var btnGLvlNormal:BitmapData;
	public var btnGLvlOver:BitmapData;
	public var btnGLvlDown:BitmapData;

	public var btnGBigNormal:BitmapData;
	public var btnGBigOver:BitmapData;
	public var selHighLight:BitmapData;

	#if !FLX_NO_KEYBOARD
	public var selector:FlxSprite;
	#end

	public function new() 
	{
		super();
	}

	override public function create():Void 
	{
		super.create();
		this.bgColor = 0xff000000;

		btnGLvlNormal = new SliceShape(0,0, 100, 18, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGLvlOver = new SliceShape(0,0, 100, 18, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone();
		selHighLight = new SliceShape(0, 0 ,102, 20, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2).pixels.clone(); 

		btnGBigNormal = new SliceShape(0,0, 100, 25, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGBigOver = new SliceShape(0,0, 100, 25, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone();

		bg = new FlxSprite(0,0,"assets/img/bgStar.png");

		leftPnl = new SliceShape(30, 0, 135, 400, "assets/img/ui_barv_b.png", SliceShape.MODE_VERTICLE, 1);
		bottomPnl = new SliceShape(0, FlxG.height - 50, FlxG.width, 40, "assets/img/ui_barh_y.png", SliceShape.MODE_HERT, 1);

		picBg = new FlxSprite(0,0,"assets/img/mapBg.png");
		picBg.x = FlxG.width * 0.66 - picBg.width / 2;
		picBg.y = FlxG.height * 0.43 - picBg.height / 2;

		picPnl = new SliceShape(Math.round(picBg.x), Math.round(picBg.y), Math.round(picBg.width), Math.round(picBg.height), "assets/img/ui_slice_b.png", SliceShape.MODE_BOX, 5);


		lvlBtns = new FlxGroup();
		btnIntro = new FlxButton(50, 10, "INTRO", function() { SwitchLevel(0); FlxG.play("sel1");}); lvlBtns.add(btnIntro);
		// btnIntro.label.setFormat(null, 8, 0xffffaa40);
		btnIntro.label.shadow = 2;//= new FlxText();
		
		btnLvl1 = new FlxButton(50, 10 + 35 * 1, "LEVEL1", function() { SwitchLevel(1); FlxG.play("sel1");} ); lvlBtns.add(btnLvl1);
		btnLvl2 = new FlxButton(50, 10 + 35 * 2, "LEVEL2", function() { SwitchLevel(2); FlxG.play("sel1");} ); lvlBtns.add(btnLvl2);
		btnLvl3 = new FlxButton(50, 10 + 35 * 3, "LEVEL3", function() { SwitchLevel(3); FlxG.play("sel1");} ); lvlBtns.add(btnLvl3);
		btnLvl4 = new FlxButton(50, 10 + 35 * 4, "LEVEL4", function() { SwitchLevel(4); FlxG.play("sel1");} ); lvlBtns.add(btnLvl4);
		btnLvl5 = new FlxButton(50, 10 + 35 * 5, "LEVEL5", function() { SwitchLevel(5); FlxG.play("sel1");} ); lvlBtns.add(btnLvl5);
		btnLvl6 = new FlxButton(50, 10 + 35 * 6, "LEVEL6", function() { SwitchLevel(6); FlxG.play("sel1");} ); lvlBtns.add(btnLvl6);
		btnLvl7 = new FlxButton(50, 10 + 35 * 7, "LEVEL7", function() { SwitchLevel(7); FlxG.play("sel1");} ); lvlBtns.add(btnLvl7);
		btnLvl8 = new FlxButton(50, 10 + 35 * 8, "LEVEL8", function() { SwitchLevel(8); FlxG.play("sel1");} ); lvlBtns.add(btnLvl8);
		btnEnd = new FlxButton(50, 10 + 35 * 9, "END", function() { SwitchLevel(9); FlxG.play("sel1");} ); lvlBtns.add(btnEnd);

		pic = new FlxSprite();

		#if !FLX_NO_KEYBOARD
		selector = new FlxSprite(selHighLight);
		#end

		btnMenu = new FlxButton(0, 0, "BACK", function() { FlxG.switchState(new MainMenu()); } );
		btnMenu.loadGraphic(btnGBigNormal);
		btnMenu.onOver = function(){btnMenu.loadGraphic(btnGBigOver);};
		btnMenu.onOut = function(){btnMenu.loadGraphic(btnGBigNormal);};
		btnMenu.x = FlxG.width * 0.66 - btnMenu.width - 50;
		btnMenu.y = FlxG.height * 0.90;
		btnMenu.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");

		btnStart = new FlxButton(0, 0, "START", function(){FlxG.switchState(GameStatic.GetCurLvlInst());});
		btnStart.loadGraphic(btnGBigNormal);
		btnStart.onOver = function(){btnStart.loadGraphic(btnGBigOver);};
		btnStart.onOut = function(){btnStart.loadGraphic(btnGBigNormal);};
		btnStart.x = FlxG.width * 0.66 + 50;
		btnStart.y = FlxG.height * 0.90;
		btnStart.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");


		missionTxt = new FlxText(0, 0, 400, "");
		missionTxt.setFormat("assets/fnt/pixelex.ttf", 24, 0xffffffff, "center");
		missionTxt.x = FlxG.width * 0.66 - 200;
		missionTxt.y = 10;
		//missionTxt.font = "assets/fnt/pixelex";

		descTxt = new FlxText(0, 0, 300, "");
		descTxt.setFormat("assets/fnt/pixelex.ttf", 12, 0xffffffff, "left");
		descTxt.x = FlxG.width * 0.66 - 150;
		descTxt.y = FlxG.height * 0.75;

		add(bg);
		add(leftPnl);
		add(bottomPnl);
		//add(picBg);
		add(picPnl);
		#if !FLX_NO_KEYBOARD
		add(selector);
		#end
		add(lvlBtns);
		add(btnMenu);
		add(pic);
		add(btnStart);
		add(missionTxt);
		add(descTxt);
		add(btnMute);

		// init
		ResUtil.playTitle();
		for (b in lvlBtns.members) {
			//cast(b, FlxButton).label.color = 0xff0041c8;
			cast(b, FlxButton).label.color = 0xffffffff;
		}
		SwitchLevel(0);
	}

	public override function update(){
		super.update();
		#if !FLX_NO_KEYBOARD
		if(FlxG.keys.justPressed("UP")){
			SwitchLevel(GameStatic.CurLvl-1);
			FlxG.play("sel1");
		}
		else if(FlxG.keys.justPressed("DOWN")){
			SwitchLevel(GameStatic.CurLvl+1);
			FlxG.play("sel1");
		}
		else if(FlxG.keys.justPressed("X")){
			StartLevel(GameStatic.CurLvl);
		}
		else if(FlxG.keys.justPressed("Z"))
			FlxG.switchState(new MainMenu());
		#end
	}

	public function SwitchLevel(id:Int)
	{
		while(id < 0) id+=GameStatic.AllLevelCnt;
		while(id >= GameStatic.AllLevelCnt) id -= GameStatic.AllLevelCnt;
		GameStatic.CurLvl = id;
		pic.loadGraphic("assets/img/map"+ id+".png");
		pic.x = FlxG.width * 0.66 - pic.width / 2;
		pic.y = FlxG.height * 0.43 - pic.height / 2;

		for (i in 0...lvlBtns.length) {
			if(i <= GameStatic.ProcLvl)
				//cast(lvlBtns.members[i],FlxButton).loadGraphic("assets/img/bLvlNot.png");
				cast(lvlBtns.members[i],FlxButton).loadGraphic(btnGLvlNormal);
			else
			{
				cast(lvlBtns.members[i],FlxButton).loadGraphic("assets/img/bLvlLock.png");
				cast(lvlBtns.members[i],FlxButton).label.text = "";
				cast(lvlBtns.members[i],FlxButton).onDown = null;
				cast(lvlBtns.members[i],FlxButton).onUp = null;
			}
		}

		cast(lvlBtns.members[id], FlxButton).loadGraphic(btnGLvlOver);
		//btnIntro.loadGraphic("assets/img/bLvlSel.png");

		// set text
		missionTxt.text = GameStatic.GetMissionName(id);
		descTxt.text = GameStatic.GetMissionDesc(id);

		// set selector
		#if !FLX_NO_KEYBOARD
		selector.x = cast(lvlBtns.members[id], FlxButton).x-1;
		selector.y = cast(lvlBtns.members[id], FlxButton).y-1;
		#end
	}

	#if !FLX_NO_KEYBOARD
	public function StartLevel(id:Int){
		FlxG.switchState(GameStatic.GetLvlInst(id));
	}
	#end
}