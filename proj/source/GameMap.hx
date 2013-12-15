package ;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flash.display.BitmapData;
import flixel.addons.display.FlxBackdrop;
import flash.geom.Matrix;


class GameMap extends MWState 
{
	public var lvlBtns:FlxGroup;
	public var btnLvl1:MyButton;
	public var btnLvl2:MyButton;
	public var btnLvl3:MyButton;
	public var btnLvl4:MyButton;
	public var btnLvl5:MyButton;
	public var btnLvl6:MyButton;
	public var btnLvl7:MyButton;
	public var btnLvl8:MyButton;
	public var btnMenu:MyButton;
	public var btnStart:MyButton;

	public var pic:FlxSprite;

	public var bgStar:FlxBackdrop;

	public var missionTxt:FlxText;
	public var descTxt:FlxText;

	public var leftPnl:SliceShape;
	public var bottomPnl:SliceShape;
	public var picPnl:SliceShape;

	public var btnGLvlNormal:BitmapData;
	public var btnGLvlOver:BitmapData;
	public var btnGLvlDown:BitmapData;
	public var bmpLock:BitmapData;
	public var btnGLvlLock:BitmapData;

	public var btnGBigNormal:BitmapData;
	public var btnGBigOver:BitmapData;
	public var selHighLight:BitmapData;

	#if !FLX_NO_KEYBOARD
	public var selector:FlxSprite;
	public var selectorMenu:SliceShape;
	#end

	public var curMenuSel:Int;

	public function new() 
	{
		super();
	}

	override public function create():Void 
	{
		super.create();
		this.bgColor = 0xff000000;

		btnGLvlNormal = new SliceShape(0,0, GameStatic.button_itemWidth, GameStatic.button_itemHeight, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGLvlOver = new SliceShape(0,0, GameStatic.button_itemWidth, GameStatic.button_itemHeight, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone();

		if(GameStatic.screenDensity == GameStatic.Density_S)
			bmpLock = FlxG.bitmap.add("assets/img/ui_lock_S.png").bitmap;
		else
			bmpLock = FlxG.bitmap.add("assets/img/ui_lock_M.png").bitmap;
		btnGLvlLock = btnGLvlNormal.clone();
		var mat:Matrix = new Matrix();
		mat.translate(btnGLvlLock.width * 0.5 - bmpLock.width * 0.5, btnGLvlLock.height * 0.5 - bmpLock.height * 0.5);
		btnGLvlLock.draw(bmpLock,mat);

		selHighLight = new SliceShape(0, 0 ,GameStatic.border_itemWidth, GameStatic.border_itemHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2).pixels.clone(); 

		btnGBigNormal = new SliceShape(0,0, GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGBigOver = new SliceShape(0,0, GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone();

		bgStar = new FlxBackdrop("assets/img/star2.png");

		var lvlBtnX : Int = Std.int(FlxG.width * 0.165  - btnGLvlNormal.width * 0.5);
		var lvlBtnYOffset : Int = Std.int((FlxG.height * 0.9 - GameStatic.AllLevelCnt)/GameStatic.AllLevelCnt);

		leftPnl = new SliceShape(lvlBtnX-3, 0, btnGLvlNormal.width + 6, FlxG.height, "assets/img/ui_barv_b.png", SliceShape.MODE_VERTICLE, 1);
		bottomPnl = new SliceShape(0, Std.int(FlxG.height * 0.905), FlxG.width, Std.int(FlxG.height * 0.09), "assets/img/ui_barh_y.png", SliceShape.MODE_HERT, 1);

		var picPnlWidth : Int = Std.int(FlxG.width * 0.6);
		var picPnlHeight: Int = Std.int(FlxG.height * 0.6);
		picPnl = new SliceShape(Math.round(FlxG.width * 0.36), Math.round(FlxG.height * 0.1), picPnlWidth, picPnlHeight, "assets/img/ui_slice_b.png", SliceShape.MODE_BOX, 5);

		lvlBtns = new FlxGroup();
		btnLvl1 = new MyButton(lvlBtnX, 5, "LEVEL1", function() { SwitchLevel(0); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl1);
		btnLvl2 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 1, "LEVEL2", function() { SwitchLevel(1); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl2);
		btnLvl3 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 2, "LEVEL3", function() { SwitchLevel(2); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl3);
		btnLvl4 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 3, "LEVEL4", function() { SwitchLevel(3); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl4);
		btnLvl5 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 4, "LEVEL5", function() { SwitchLevel(4); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl5);
		btnLvl6 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 5, "LEVEL6", function() { SwitchLevel(5); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl6);
		btnLvl7 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 6, "LEVEL7", function() { SwitchLevel(6); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl7);
		btnLvl8 = new MyButton(lvlBtnX, 5 + lvlBtnYOffset * 7, "LEVEL8", function() { SwitchLevel(7); FlxG.sound.play("sel1");} ); lvlBtns.add(btnLvl8);

		pic = new FlxSprite();

		#if !FLX_NO_KEYBOARD
		selector = new FlxSprite(selHighLight);
		selectorMenu = new SliceShape(0, 0, GameStatic.border_menuWidth, GameStatic.border_menuHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2);
		#end

		btnMenu = new MyButton(0, 0, "BACK", function() { FlxG.switchState(new MainMenu()); } );
		btnMenu.loadGraphic(btnGBigNormal);
		btnMenu.setOnOverCallback(function(){btnMenu.loadGraphic(btnGBigOver);});
		btnMenu.setOnOutCallback(function(){btnMenu.loadGraphic(btnGBigNormal);});
		btnMenu.x = FlxG.width * 0.66 - btnMenu.width - 50;
		btnMenu.y = FlxG.height * 0.95 - btnMenu.height * 0.5;
		btnMenu.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");

		btnStart = new MyButton(0, 0, "START", function(){FlxG.switchState(GameStatic.GetCurLvlInst());});
		btnStart.loadGraphic(btnGBigNormal);
		btnStart.setOnOverCallback(function(){btnStart.loadGraphic(btnGBigOver);});
		btnStart.setOnOutCallback(function(){btnStart.loadGraphic(btnGBigNormal);});
		btnStart.x = FlxG.width * 0.66 + 50;
		btnStart.y = FlxG.height * 0.95 - btnStart.height * 0.5;
		btnStart.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");


		missionTxt = new FlxText(0, 0, 400, "");
		missionTxt.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_mainButton, 0xffffff, "center");
		missionTxt.x = FlxG.width * 0.66 - 200;
		missionTxt.y = 5;
		//missionTxt.font = "assets/fnt/pixelex";

		descTxt = new FlxText(0, 0, Std.int(FlxG.width * 0.6), "");
		descTxt.setFormat(ResUtil.FNT_Amble, GameStatic.txtSize_desc, 0xffffff, "left");
		descTxt.x = FlxG.width * 0.36;
		descTxt.y = FlxG.height * 0.70 + 5;

		add(bgStar);
		add(leftPnl);
		add(bottomPnl);
		add(picPnl);
		#if !FLX_NO_KEYBOARD
		add(selector);
		//add(selectorMenu);
		#end
		add(lvlBtns);
		add(btnMenu);
		add(pic);
		add(btnStart);
		add(missionTxt);
		add(descTxt);
		add(btnMute);
		add(confirm);

		// init
		ResUtil.playTitle();
		for (b in lvlBtns.members) {
			cast(b, FlxButton).label.setFormat(ResUtil.FNT_Amble, GameStatic.txtSize_itemButton, 0xffffff, "center");
		}
		SwitchLevel(GameStatic.CurLvl<=GameStatic.ProcLvl?GameStatic.CurLvl:0);
		#if !FLX_NO_KEYBOARD
		curMenuSel = 0;
		SwitchMenu(curMenuSel);

		bottomPnl.visible = false;
		btnMenu.visible = false;
		btnStart.visible = false;
		selectorMenu.visible = false;

		confirm.ShowConfirm(Confirm.Mode_TextOnly, false, "C to Start Level, X for Back to Menu", "", "", false,null, null);
		#end
	}

	public override function update(){
		super.update();
		#if !FLX_NO_KEYBOARD
		if(FlxG.keyboard.justPressed("UP")){
			SwitchLevel(GameStatic.CurLvl-1);
			FlxG.sound.play("sel1");
		}
		else if(FlxG.keyboard.justPressed("DOWN")){
			SwitchLevel(GameStatic.CurLvl+1);
			FlxG.sound.play("sel1");
		}
		else if(FlxG.keyboard.justPressed("RIGHT")){
			SwitchMenu(1);
			FlxG.sound.play("sel1");
		}
		else if(FlxG.keyboard.justPressed("LEFT")){
			SwitchMenu(-1);
			FlxG.sound.play("sel1");
		}
		else if(FlxG.keyboard.justPressed("C")){
			//MenuAction(curMenuSel);
			FlxG.switchState(GameStatic.GetCurLvlInst());
		}
		else if(FlxG.keyboard.justPressed("X"))
			FlxG.switchState(new MainMenu());
		#end
	}

	public function SwitchLevel(id:Int)
	{
		while(id < 0) id+=GameStatic.ProcLvl+1;
		while(id >= GameStatic.ProcLvl+1) id -= GameStatic.ProcLvl+1;
		GameStatic.CurLvl = id;
		pic.loadGraphic("assets/img/map"+ id+".png");
		pic.x = FlxG.width * 0.66 - pic.width / 2;
		pic.y = FlxG.height * 0.43 - pic.height / 2;

		for (i in 0...lvlBtns.length) {
			if(i <= GameStatic.ProcLvl)
				cast(lvlBtns.members[i],FlxButton).loadGraphic(btnGLvlNormal);
			else
			{
				cast(lvlBtns.members[i],FlxButton).loadGraphic(btnGLvlLock);
				cast(lvlBtns.members[i],FlxButton).label.text = "";
				cast(lvlBtns.members[i],FlxButton).setOnDownCallback(null);
				cast(lvlBtns.members[i],FlxButton).setOnUpCallback(null);
			}
		}

		#if FLX_NO_KEYBOARD
		cast(lvlBtns.members[id], FlxButton).loadGraphic(btnGLvlOver);
		#else
		cast(lvlBtns.members[id], FlxButton).loadGraphic(btnGLvlNormal);
		#end
		//btnIntro.loadGraphic("assets/img/bLvlSel.png");

		// set text
		missionTxt.text = GameStatic.GetMissionName(id);
		descTxt.text = GameStatic.GetMissionDesc(id);

		// set selector
		#if !FLX_NO_KEYBOARD
		selector.x = cast(lvlBtns.members[id], FlxButton).x+GameStatic.offset_border;
		selector.y = cast(lvlBtns.members[id], FlxButton).y+GameStatic.offset_border;
		#end
	}

	#if !FLX_NO_KEYBOARD
	public function StartLevel(id:Int){
		FlxG.switchState(GameStatic.GetLvlInst(id));
	}

	public function SwitchMenu(id:Int){
		while(id < 0) id += 2;
		while(id >=2) id -= 2;
		curMenuSel = id;

		switch (id) {
			case 0:
				selectorMenu.x = btnStart.x + GameStatic.offset_border;
				selectorMenu.y = btnStart.y + GameStatic.offset_border;
			case 1:
				selectorMenu.x = btnMenu.x + GameStatic.offset_border;
				selectorMenu.y = btnMenu.y + GameStatic.offset_border;
		}
	}

	public function MenuAction(id:Int){
		switch (id) {
			case 0:
				FlxG.switchState(new MainMenu());
			case 1: 
				StartLevel(GameStatic.CurLvl);
		}
	}
	#end
}