package ;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxText;


class GameMap extends FlxState 
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
public var SelId:Int;

public var bg:FlxSprite;
public var picBg:FlxSprite;

public var missionTxt:FlxText;
public var descTxt:FlxText;

public function new() 
{
	super();
}

override public function create():Void 
{
	super.create();
	this.bgColor = 0xff000000;

	bg = new FlxSprite(0,0,"assets/img/bgStar.png");

	picBg = new FlxSprite(0,0,"assets/img/mapBg.png");
	picBg.x = FlxG.width * 0.66 - picBg.width / 2;
	picBg.y = FlxG.height * 0.43 - picBg.height / 2;

	lvlBtns = new FlxGroup();
	btnIntro = new FlxButton(50, 10, "INTRO", function() { SwitchLevel(0); } ); lvlBtns.add(btnIntro);
	btnLvl1 = new FlxButton(50, 10 + 35 * 1, "LEVEL1", function() { SwitchLevel(1);} ); lvlBtns.add(btnLvl1);
	btnLvl2 = new FlxButton(50, 10 + 35 * 2, "LEVEL2", function() { SwitchLevel(2);} ); lvlBtns.add(btnLvl2);
	btnLvl3 = new FlxButton(50, 10 + 35 * 3, "LEVEL3", function() { SwitchLevel(3);} ); lvlBtns.add(btnLvl3);
	btnLvl4 = new FlxButton(50, 10 + 35 * 4, "LEVEL4", function() { SwitchLevel(4);} ); lvlBtns.add(btnLvl4);
	btnLvl5 = new FlxButton(50, 10 + 35 * 5, "LEVEL5", function() { SwitchLevel(5);} ); lvlBtns.add(btnLvl5);
	btnLvl6 = new FlxButton(50, 10 + 35 * 6, "LEVEL6", function() { SwitchLevel(6);} ); lvlBtns.add(btnLvl6);
	btnLvl7 = new FlxButton(50, 10 + 35 * 7, "LEVEL7", function() { SwitchLevel(7);} ); lvlBtns.add(btnLvl7);
	btnLvl8 = new FlxButton(50, 10 + 35 * 8, "LEVEL8", function() { SwitchLevel(8);} ); lvlBtns.add(btnLvl8);
	btnEnd = new FlxButton(50, 10 + 35 * 9, "END", function() { SwitchLevel(9);} ); lvlBtns.add(btnEnd);

	pic = new FlxSprite();



	btnMenu = new FlxButton(0, 0, "", function() { FlxG.switchState(new MainMenu()); } );
	btnMenu.loadGraphic("assets/img/bLvlBack.png");
	btnMenu.onOver = function(){btnMenu.loadGraphic("assets/img/bLvlBackOver.png");};
	btnMenu.onOut = function(){btnMenu.loadGraphic("assets/img/bLvlBack.png");};
	btnMenu.x = FlxG.width * 0.66 - btnMenu.width - 50;
	btnMenu.y = FlxG.height * 0.90;

	btnStart = new FlxButton(0, 0, "", function(){FlxG.switchState(GameStatic.GetCurLvlInst());});
	btnStart.loadGraphic("assets/img/bLvlStart.png");
	btnStart.onOver = function(){btnStart.loadGraphic("assets/img/bLvlStartOver.png");};
	btnStart.onOut = function(){btnStart.loadGraphic("assets/img/bLvlStart.png");};
	btnStart.x = FlxG.width * 0.66 + 50;
	btnStart.y = FlxG.height * 0.90;


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
	add(picBg);
	add(lvlBtns);
	add(btnMenu);
	add(pic);
	add(btnStart);
	add(missionTxt);
	add(descTxt);


	

	// init
	for (b in lvlBtns.members) {
		//cast(b, FlxButton).label.color = 0xff0041c8;
		cast(b, FlxButton).label.color = 0xffffffff;
	}
	SwitchLevel(0);
}

public function SwitchLevel(id:Int)
{
	GameStatic.CurLvl = id;
	pic.loadGraphic("assets/img/map"+ id+".png");
	pic.x = FlxG.width * 0.66 - pic.width / 2;
	pic.y = FlxG.height * 0.43 - pic.height / 2;

	for (i in 0...lvlBtns.length) {
		if(i <= GameStatic.ProcLvl)
			cast(lvlBtns.members[i],FlxButton).loadGraphic("assets/img/bLvlNot.png");
		else
		{
			cast(lvlBtns.members[i],FlxButton).loadGraphic("assets/img/bLvlLock.png");
			cast(lvlBtns.members[i],FlxButton).label.text = "";
			cast(lvlBtns.members[i],FlxButton).onDown = null;
			cast(lvlBtns.members[i],FlxButton).onUp = null;
		}
	}

	cast(lvlBtns.members[id], FlxButton).loadGraphic("assets/img/bLvlSel.png");
	//btnIntro.loadGraphic("assets/img/bLvlSel.png");

	// set text
	missionTxt.text = GameStatic.GetMissionName(id);
	descTxt.text = GameStatic.GetMissionDesc(id);

}
}