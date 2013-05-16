package;
import org.flixel.FlxText;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.FlxTilemap;
import org.flixel.FlxEmitter;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxState;
import org.flixel.FlxObject;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;
import org.flixel.FlxButton;
import org.flixel.system.FlxTile;
import org.flixel.tmx.TmxMap;
import org.flixel.tmx.TmxLayer;
import org.flixel.tmx.TmxObjectGroup;
import org.flixel.tmx.TmxTileSet;
import org.flixel.tmx.TmxObject;
import nme.display.BitmapData;
import org.flixel.tweens.FlxTween;
import org.flixel.tweens.misc.VarTween;
import org.flixel.tweens.util.Ease;
import org.flixel.addons.FlxBackdrop;
import nme.Assets;
import nme.events.Event;
import nme.net.URLRequest;

class Level extends MWState
{
	// bg
	public var bgStar:FlxSprite;
	public var bgMetal:FlxSprite;
	public var bg1:FlxSprite;
	public var bg2:FlxSprite;
	public var bd1:FlxBackdrop;
	public var bd2:FlxBackdrop;
	public var bd3:FlxBackdrop;
	public var bd4:FlxBackdrop;

	// Tiles
	public var tileXML:String;	// Set this in Constructor to perform preload
	public var tmx:TmxMap;
	public var EmptyTile:FlxTilemap;
	public var tileCover:FlxTilemap;	// cover everything
	public var tileCoverD:FlxTilemap;	// used only in level4
	public var tileBreak:FlxTilemap;	// logic tile : can be break (logic)
	public var tileUp:FlxTilemap;		// logic tile : can jump throuth
	public var tile:FlxTilemap;			// tile for anything
	public var tileEO:FlxTilemap;		// tile for enemy collide only
	public var tilePO:FlxTilemap;		// tile for player only
	public var tileJS:FlxTilemap;		// tiles can jump through
	public var tileLight:FlxTilemap;	// light line
	public var tileBg:FlxTilemap;		// justBg
	public var tileBgFar:FlxTilemap;	// bg under all!
	public var tileNail:FlxTilemap;		// nail trap for bot!

	// Dialog
	public var lines1:Array<Line>;
	public var lines2:Array<Line>;
	public var lines3:Array<Line>;
	public var lines4:Array<Line>;

	// New Dialog
	public var lineMgr:LineMgr;

	// Data
	public var isEnd:Bool;
	public var isWin:Bool;
	public var endPause : Bool;
	public var birthPos:FlxPoint;
	public var start:FlxSprite;		// Normal Way to Start Level
	public var end:FlxSprite;		// Normal Way to End Level

	// Characters
	public var bot:Bot;
	public var t:Trans;
	public var ducks:FlxGroup;		// Bomb in Level2
	public var Bees:FlxGroup;		// Bee in Level3
	public var bigGuns:FlxGroup;	// Enemy in Level3-4
	public var gpUps:FlxGroup;		// Enemy in Level3~4
	public var gpMids:FlxGroup;
	public var gpDowns:FlxGroup;	
	public var spawnUps:FlxGroup;	// Enemy in Level3-4
	public var guards:FlxGroup;
	public var bWalks:FlxGroup;
	public var births:FlxGroup;
	public var bTriggers:FlxGroup;
	public var lasers:FlxGroup;
	public var aCatchs:FlxGroup;
	public var lifts:FlxGroup;
	public var mines:FlxGroup;
	public var boss1:Boss1;
	public var boss3:Boss3;
	public var sBase:FlxSprite;
	public var cubes:FlxGroup;
	public var zball:FlxSprite;		// zBall in level7
	public var coms:FlxGroup;
	public var gates:FlxGroup;

	// Bullets
	public var bullets:FlxGroup;	// Bullets of Bot
	public var bigGunBuls:FlxGroup;	// Bullets of Bit Gun
	public var boss3Buls:FlxGroup;	// Bullets of boss3 in level8
	public var fgBuls:FlxGroup;		// Bullets of Fixed Gun
	public var missles:FlxGroup;	// Missle of Rocket Launcher & BossLvl4
	public var bouncers:FlxGroup;	// Bounce Bullets by BossLvl4

	// items
	public var hps:FlxGroup;		// hp

	// Particles
	public var bombFlower:FlxGroup;	// Normal Explosion Sprite Group
	public var breakEmt:FlxEmitter; // Intelligence Broken Tile Emitter
	public var explo2s:FlxGroup;	// explosion type 2
	public var boomPar:BoomParticle;// explosion with particle

	// Effects
	public var birthRay:FlxSprite;
	public var smokeEmt1:FlxEmitter;
	public var smokeEmt2:FlxEmitter;
	public var eExplo:FlxSprite;
	public var hugeExplos:FlxGroup;

	// Huds
	public var tips:FlxGroup;
	public var hpBar:HPBar;
	public var hbL:FlxSprite;	// Boss Health
	public var hbR:FlxSprite;
	public var hbBg:FlxSprite;
	public var hbH:FlxSprite;
	public var baseHPBg:FlxSprite;
	public var baseHPBar:FlxSprite;

	// gui

	// gui - end panel
	public var endGroup : FlxGroup;
	public var endMask:FlxSprite;
	public var endBg:SliceShape;
	public var selector_End:FlxSprite;
	public var btnAgain:MyButton;
	public var btnMap:MyButton;
	public var btnNext:MyButton;
	public var btnHelp:MyButton;
	public var lbMission:FlxText;
	public var lbResult:FlxText;

	// gui - pause panel
	public var pauseGroup:FlxGroup;
	public var pauseMask:FlxSprite;
	public var pauseBg:SliceShape;
	public var selector_Pause:FlxSprite;
	public var btnResume_Pause:MyButton;
	public var btnAgain_Pause:MyButton;
	public var btnQuit_Pause:MyButton;
	public var lbPaused:FlxText;

	// gui - skip button
	public var toSkip:FlxSprite;
	public var skipFun:Void->Void;
	public var btnShowHelp:FlxButton;
	public var sceneName:FlxText;

	// gui - tip
	public var tipManager:TipManager;

	// Utility
	public var timer1:FlxTimer;
	public var timer2:FlxTimer;
	public var timer3:FlxTimer;
	public var timerSceneName:FlxTimer;
	public var gvTimer:FlxTimer;	// Game Over Time
	public var jsCntr:Int;			// 

	// doors
	public var door1Up:LDoor;	// level entrance door
	public var door2Down:LDoor;	// level exit door under bot
	public var door2Up:LDoor;	// level exit door over bot

	// misc
	public var bInLift:FlxSprite;
	public var bInLift2:FlxSprite;
	public var energy:FlxSprite;
	public var eStar:FlxSprite;

	// camera
	public var camScrollXTween : VarTween;
	public var camScrollYTween : VarTween;
	private var camXTweenDone:Bool;
	private var camYTweenDone:Bool;
	private var camTweening:Bool;
	private var onCamTweenDone:Void->Void;

	// misc
	public static var maxSelPause:Int = 3;
	public static var maxSelEnd:Int = 3;
	public var curSelPause:Int;
	public var curSelEnd:Int;
	public static var liftSpeed:Float = 45;

	public function new()
	{
		super();
		zball = null;
	}

	override public function create():Void
	{
		super.create();
		this.bgColor = 0xff000000;

		bgStar = new FlxSprite(0, 0, "assets/img/bgStar.png");	bgStar.scrollFactor = new FlxPoint(0, 0);
		bgMetal = new FlxSprite(0, 0, "assets/img/metal.png");	bgMetal.scrollFactor = new FlxPoint(0, 0);

		lineMgr = new LineMgr();

		EmptyTile = new FlxTilemap();
		var eD:Array<Int> = [0,0,0,0];
		EmptyTile.loadMap(FlxTilemap.arrayToCSV(eD, 2), "assets/img/defTile.png", 20, 20);	
		
		//FlxG.mouse.hide();
		
		jsCntr = 0;
		
		isEnd = false;
		isWin = false;
		
		timer1 = new FlxTimer();
		timer2 = new FlxTimer();
		timer3 = new FlxTimer();
		timerSceneName = new FlxTimer();
		gvTimer = new FlxTimer();
		
		// Preload Tile Data
		if (tileXML != null)
			tmx = new TmxMap(tileXML);
		
		// Bullets
		bullets = new FlxGroup();
		bigGunBuls = new FlxGroup();
		boss3Buls = new FlxGroup();
		bouncers = new FlxGroup();
		fgBuls = new FlxGroup();
		missles = new FlxGroup();
		
		// Characters
		bot = new Bot(0, 0, bullets);
		ducks = new FlxGroup();
		Bees = new FlxGroup();
		bigGuns = new FlxGroup();
		gpUps = new FlxGroup();
		gpMids = new FlxGroup();
		gpDowns = new FlxGroup();
		guards = new FlxGroup();
		bWalks = new FlxGroup();
		births = new FlxGroup();
		bTriggers = new FlxGroup();
		lasers = new FlxGroup();
		aCatchs = new FlxGroup();
		lifts = new FlxGroup();
		mines = new FlxGroup();
		cubes = new FlxGroup();
		coms = new FlxGroup();
		gates = new FlxGroup();

		// items
		hps = new FlxGroup();
		
		// Particles
		breakEmt = new FlxEmitter(100, 100);
		breakEmt.makeParticles("assets/img/mudParticle.png", 200, 0, true, 0);
		breakEmt.gravity = 400;
		breakEmt.setYSpeed(-200, 200);
		breakEmt.setXSpeed(-200, 200);
		bombFlower = new FlxGroup();
		explo2s = new FlxGroup();
		boomPar = new BoomParticle();
		
		// Effects
		birthRay = new FlxSprite(-100,0);
		birthRay.loadGraphic("assets/img/birthRay.png", true, false, 30, 10);
		birthRay.scale = new FlxPoint(1, 42);
		birthRay.addAnimation("birth", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 5, false);
		hugeExplos = new FlxGroup();
		
		// Huds
		tips = new FlxGroup();
		hpBar = new HPBar(); hpBar.visible = false;
		
		hbL = new FlxSprite(FlxG.width * 0.5 - 75, FlxG.height-30, "assets/img/hbL.png"); hbL.scrollFactor = new FlxPoint(0, 0); hbL.visible = false;
		hbR = new FlxSprite(FlxG.width * 0.5 + 155, FlxG.height-30, "assets/img/hbR.png"); hbR.scrollFactor = new FlxPoint(0, 0); hbR.visible = false;
		hbBg = new FlxSprite(FlxG.width * 0.5 - 155, FlxG.height-30, "assets/img/hbBg.png"); hbBg.origin = new FlxPoint(0, 0); hbBg.scale = new FlxPoint(31, 1); hbBg.scrollFactor = new FlxPoint(0, 0); hbBg.visible = false;
		hbH = new FlxSprite(FlxG.width * 0.5 -155, FlxG.height-30, "assets/img/hbH.png"); hbH.origin = new FlxPoint(0, 0);  hbH.scrollFactor = new FlxPoint(0, 0); hbH.visible = false;

		// gui
		btnShowHelp = new MyButton(FlxG.width - 44, 4, "", function() { FlxG.mute = !FlxG.mute; } );
		btnShowHelp.scrollFactor.make(0,0);
		btnShowHelp.onOver = function(){btnMute.loadGraphic("assets/img/showHelp_act.png");};
		btnShowHelp.onOut = function(){btnMute.loadGraphic("assets/img/showHelp.png");};

		// gui - end panel
		endGroup = new FlxGroup();
		endMask = new FlxSprite(0,0);
		endMask.makeGraphic(FlxG.width, FlxG.height, 0xff000000); endMask.scrollFactor.make(0,0);
		endMask.alpha = 0.0;
		endMask.visible = false;
		endBg = new SliceShape(Math.round(FlxG.width*0.5-150), Math.round(FlxG.height * 0.5-125), 300, 250,"assets/img/ui_slice_y.png", SliceShape.MODE_BOX, 5);
		endBg.scrollFactor.make(0,0);
		endBg.visible = false;

		selector_End = new FlxSprite(ResUtil.bmpSelMenu);
		selector_End.scrollFactor.make(0,0);
		selector_End.visible = false;

		btnAgain = new MyButton(0, 0, "Again", function() { FlxG.switchState(GameStatic.GetCurLvlInst()); } );
		btnAgain.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnAgain.x = FlxG.width/2 - btnAgain.width/2;
		btnAgain.y = FlxG.height/2 + 50;
		btnAgain.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnAgain.scrollFactor.make(0, 0);
		btnAgain.visible = false;

		btnMap = new MyButton(0, 0, "Levels", function() { FlxG.switchState(new GameMap()); } );
		btnMap.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnMap.x = FlxG.width/2 - btnAgain.width/2;
		btnMap.y = FlxG.height/2;
		btnMap.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnMap.scrollFactor.make(0, 0);
		btnMap.visible = false;

		btnNext = new MyButton(0, 0, "Next", function() { FlxG.switchState(GameStatic.GetNextInst()); } );
		btnNext.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnNext.x = FlxG.width/2 - btnAgain.width/2;
		btnNext.y = FlxG.height/2 - 50;
		btnNext.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnNext.scrollFactor.make(0, 0);
		btnNext.visible = false;

		btnHelp = new MyButton(275 + 80, 350, "Help", function(){nme.Lib.getURL(new URLRequest("www.youtube.com"));});
		btnHelp.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnHelp.x = FlxG.width/2 - btnAgain.width/2;
		btnHelp.y = FlxG.height/2 - 50;
		btnHelp.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnHelp.scrollFactor.make(0,0);
		btnHelp.visible = false;

		lbMission = new FlxText(0, 0, 200, "MISSION", 26);
		lbMission.setFormat(ResUtil.FNT_Pixelex, 26, 0xffffff, "center");
		lbMission.x = FlxG.width*0.5 - lbMission.width/2;
		lbMission.y = FlxG.height*0.5 - 120;
		lbMission.scrollFactor.make(0,0);
		lbMission.visible = false;

		lbResult = new FlxText(0, 0, 200, "ACCOMPLISHED", 18);
		lbResult.setFormat(ResUtil.FNT_Pixelex, 18, 0xffffff, "center");
		lbResult.x = FlxG.width*0.5 - lbMission.width/2;
		lbResult.y = FlxG.height*0.5 - 90;
		lbResult.scrollFactor.make(0,0);
		lbResult.visible = false;

		// gui - pause panel
		pauseGroup = new FlxGroup();

		pauseMask = new FlxSprite(0,0);
		pauseMask.makeGraphic(FlxG.width, FlxG.height, 0xff000000); pauseMask.scrollFactor.make(0,0);
		pauseMask.alpha = 0.5;

		pauseBg = new SliceShape(Math.round(FlxG.width*0.5-150), Math.round(FlxG.height * 0.5-125), 300, 250,"assets/img/ui_slice_b.png", SliceShape.MODE_BOX, 5);
		pauseBg.scrollFactor.make(0,0);

		selector_Pause = new FlxSprite(ResUtil.bmpSelMenu);
		selector_Pause.scrollFactor.make(0,0);

		btnResume_Pause = new MyButton(0, 0, "RESUME", function() { Pause(false); } );
		btnResume_Pause.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnResume_Pause.x = FlxG.width/2 - btnResume_Pause.width/2;
		btnResume_Pause.y = FlxG.height/2 - 50;
		btnResume_Pause.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnResume_Pause.scrollFactor.make(0, 0);

		btnAgain_Pause = new MyButton(0, 0, "AGAIN", function() { FlxG.switchState(GameStatic.GetCurLvlInst()); } );
		btnAgain_Pause.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnAgain_Pause.x = FlxG.width/2 - btnAgain_Pause.width/2;
		btnAgain_Pause.y = FlxG.height/2;
		btnAgain_Pause.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnAgain_Pause.scrollFactor.make(0, 0);

		btnQuit_Pause = new MyButton(275 - 80, 350, "QUIT", function() { FlxG.switchState(GameStatic.GetCurLvlInst()); } );
		btnQuit_Pause.loadGraphic(ResUtil.bmpBtnBMenuNormal);
		btnQuit_Pause.x = FlxG.width/2 - btnQuit_Pause.width/2;
		btnQuit_Pause.y = FlxG.height/2 + 50;
		btnQuit_Pause.label.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, 0xffffff, "center");
		btnQuit_Pause.scrollFactor.make(0, 0);

		lbPaused = new FlxText(0, 0, 200, "PAUSED", 26);
		lbPaused.setFormat(ResUtil.FNT_Pixelex, 26, 0xffffff, "center");
		lbPaused.x = FlxG.width*0.5 - lbPaused.width/2;
		lbPaused.y = FlxG.height*0.5 - 120;
		lbPaused.scrollFactor.make(0,0);

		// gui - skip button
		toSkip = new FlxSprite(0, 0, "assets/img/clickToSkip.png");
		toSkip.scrollFactor.make(0, 0);
		toSkip.visible = false;

		sceneName = new FlxText(0, 10, FlxG.width, "SceneName", 22);
		sceneName.setFormat("assets/fnt/pixelex.ttf", 22, 0xffffff, "center");
		sceneName.scrollFactor.make(0,0);
		sceneName.alpha = 0;

		// gui - tip
		tipManager = new TipManager();

		// Dialogs
		// try load tile layers
		tileBgFar = GetTile("bgFar", FlxObject.NONE);
		tileBg = GetTile("bg", FlxObject.NONE);
		tileLight = GetTile("light", FlxObject.NONE);
		tile = GetTile("tile", FlxObject.ANY);
		tileEO = GetTile("eo", FlxObject.ANY);
		tileJS = GetTile("js", FlxObject.UP);
		tilePO = GetTile("po", FlxObject.ANY);
		tileNail = GetTile("nail", FlxObject.ANY);
		tileCover = GetTile("cover", FlxObject.ANY);
		tileCoverD = GetTile("coverD", FlxObject.ANY);

		// camera
		camScrollXTween = new VarTween(function(){camXTweenDone=true;},0);
		camScrollYTween = new VarTween(function(){camYTweenDone=true;},0);
		addTween(camScrollXTween);
		addTween(camScrollYTween);
		
		// load misc
		var mG:TmxObjectGroup = tmx.getObjectGroup("misc");
		if (mG != null)
		{
			for (o in mG.objects)
			{
				if (o.name == "start")
				{
					start = new FlxSprite(o.x, o.y);
					start.width = o.width; start.height = o.height;
				}
				else if (o.name == "end")
				{
					end = new FlxSprite(o.x, o.y);
					end.width = o.width; end.height = o.height;
				}
				else if (o.type == "lift")
				{
					var lift:Lift = cast(lifts.recycle(Lift),Lift);
					lift.make(o);
				}
				else if (o.type == "sign")
				{
					var t:Tip1 =  cast(tips.recycle(Tip1),Tip1);
					t.make(o);
				}
				else if (o.type == "cube")
				{
					var cube:Cube = cast(cubes.recycle(Cube),Cube);
					cube.make(o);
				}
				else if (o.type == "com")
				{
					// load indiependent consoles
					// level related coms are defined with a name like "comIn" or "comOut"
					// level related coms(with a name) are likely to get override by subclasses!!
					var tipData:String = o.custom.resolve("tip");
					if(tipData != null && tipData != ""){
						var com:Com = cast(coms.recycle(Com), Com);
						com.reset(o.x, o.y);
						com.SetTip(Std.parseInt(tipData));
					}
				}
				else if(o.type =="border"){
					FlxG.camera.setBounds(o.x, o.y, o.width, o.height, true);

					//FlxG.camera.setBounds(200, 200, 100, 100);
					//FlxG.camera.bounds.make(o.x, o.y, o.width, o.height);
				}
				else if(o.type == "hp"){
					var hp:Repair = new Repair(o.x, o.y);
					hps.add(hp);
				}
			}
		}
		
		// load enemy!
		var eG:TmxObjectGroup = tmx.getObjectGroup("enemy");
		if (eG != null)
		{
			for (o in eG.objects)
			{
				if (o.type == "bg")
				{
					var bg:BigGun = cast(bigGuns.recycle(BigGun),BigGun);
					bg.reset(o.x, o.y);
					bg.facing = FlxObject.LEFT;
					if (o.custom!=null && o.custom.face != null)
					{
						if (o.custom.face == "right")
						bg.facing = FlxObject.RIGHT;
						else
						bg.facing = FlxObject.LEFT;
					}
				}
				else if (o.type == "gpMid")
				{
					var gpMid:GPMid = cast(gpMids.recycle(GPMid) , GPMid);
					gpMid.reset(o.x, o.y);
				}
				else if (o.type == "gpUp")
				{
					var gpUp:GPUp = cast(gpUps.recycle(GPUp) , GPUp); 
					gpUp.reset(o.x, o.y);
				}
				else if (o.type == "gpDown")
				{
					var gpDown:GPDown = cast(gpDowns.recycle(GPDown) , GPDown);
					gpDown.reset(o.x, o.y);
				}
				else if (o.type == "guard")
				{
					var guard:Guard = cast(guards.recycle(Guard) , Guard);
					guard.reset(o.x, o.y);
				}
				else if (o.type == "bWalk")
				{
					var bWalk:BWalk = cast(bWalks.recycle(BWalk) , BWalk);
					bWalk.make(o);
				}
				else if (o.type == "birth")
				{
					var birth:Birth = cast(births.recycle(Birth) , Birth);
					birth.reset(o.x, o.y);
					birth.width = o.width;
					birth.height = o.height;
					birth.count = Std.parseInt(o.custom.count);
					birth.gid = Std.parseInt(o.custom.gid);
					birth.span = Std.parseFloat(o.custom.span);
					birth.type = o.custom.type;
				}
				else if (o.type == "bTrigger")
				{
					var bt:BTrigger = cast(bTriggers.recycle(BTrigger) , BTrigger);
					bt.reset(o.x, o.y);
					bt.width = o.width;
					bt.height = o.height;
					bt.gid = Std.parseInt(o.custom.gid);
				}
				else if (o.type == "laser")
				{
					var l:Laser = cast(lasers.recycle(Laser) , Laser);
					l.make(o);
				}
				else if (o.type == "ac")
				{
					var a:ACatch = cast(aCatchs.recycle(ACatch) , ACatch);
					a.make(o);
				}
				else if (o.type == "mine")
				{
					var mine:Mine = cast(mines.recycle(Mine) , Mine);
					mine.make(o);
				}
			}
		}
		camXTweenDone = false;
		camYTweenDone = false;
		camTweening = false;

		// Initial
		ResUtil.playGame1();
		curSelPause = 0;
		curSelEnd = 0;
		#if !FLX_NO_KEYBOARD
		ChangeSelPause(0);
		ChangeSelEnd(0);
		#end
		ShowPause(false);
		FlxG.paused = false;
		endPause = false;
		tipManager.HideTip();
	}

	public function AddAll():Void
	{
		add(bgStar);
		add(bgMetal);
		add(bd1);
		add(bd2);
		add(bd3);
		add(bd4);
		add(bg1);
		add(bg2);
		
		add(tileBgFar);
		add(bInLift);
		add(bInLift2);
		add(tileBg);
		add(tileLight);

		add(tips);
		add(cubes);

		add(gates);
		
		add(tile);
		add(tileEO);	tileEO.visible = false;
		add(tileUp);
		add(tileBreak);
		add(tileNail);
		add(tilePO);
		add(tileJS);
		add(lifts);
		add(tileJS);
		add(tileNail);
		
		add(door2Down);
		add(energy);
		add(eStar);
		add(sBase);
		add(coms);

		add(t);
		add(hps);
		
		add(breakEmt);
		add(bigGunBuls);
		add(missles);
		add(bouncers);
		
		add(ducks);
		add(lasers);
		add(guards);
		add(bWalks);
		add(bigGuns);
		add(gpUps);
		add(gpMids);
		add(gpDowns);
		add(aCatchs);
		add(boss1);
		add(boss3);
		add(Bees);
		add(mines);
		add(zball);
		
		add(bullets);
		add(bot);
		
		add(boss3Buls);

		add(tileCover);
		add(tileCoverD);

		add(boomPar);
		
		add(door2Up);
		add(door1Up);
		
		add(birthRay);
		add(explo2s);
		add(eExplo);
		add(smokeEmt1);
		add(smokeEmt2);
		add(bombFlower);
		add(hugeExplos);
		
		add(hpBar);
		
		add(lineMgr);
		
		add(hbL);
		add(hbR);
		add(hbBg);
		add(hbH);

		add(baseHPBar);
		add(baseHPBg);

		endGroup.add(add(endMask));
		endGroup.add(add(endBg));
		#if !FLX_NO_KEYBOARD
		endGroup.add(add(selector_End));
		#end
		endGroup.add(add(btnNext));
		endGroup.add(add(btnHelp));
		endGroup.add(add(btnAgain));
		endGroup.add(add(btnMap));
		endGroup.add(add(lbMission));
		endGroup.add(add(lbResult));

		pauseGroup.add(add(pauseMask));
		pauseGroup.add(add(pauseBg));
		#if !FLX_NO_KEYBOARD
		pauseGroup.add(add(selector_Pause));
		#end
		pauseGroup.add(add(btnResume_Pause));
		pauseGroup.add(add(btnAgain_Pause));
		pauseGroup.add(add(btnQuit_Pause));
		pauseGroup.add(add(lbPaused));

		add(sceneName);

		add(tipManager);

		add(toSkip);

		add(btnMute);
		add(btnPause);
		add(input);
		add(confirm);
	}

	override public function update():Void 
	{
		// well this is too basic and have to get updated even game is paused
		input.update();

		// Block Prority #1 Confirm
		if(confirm.visible && confirm.isModel){
			confirm.update();
			return;
		}

		// Block Prority #2 Pause-Normal
		if(FlxG.paused && pauseBg.visible){
			pauseGroup.update();

			#if !FLX_NO_KEYBOARD
			if(pauseBg.visible == true){
				if(FlxG.keys.justPressed("UP"))
					ChangeSelPause(curSelPause-1);
				else if(FlxG.keys.justPressed("DOWN"))
					ChangeSelPause(curSelPause+1);
				else if(FlxG.keys.justPressed("X"))
					ActionPause(curSelPause);
				else if(FlxG.keys.justPressed("Z"))
					Pause(false);	// Do nothing by now
			}
			#end
			return;
		}

		// Block Prority #2 Tip Pause
		if(FlxG.paused && tipManager.visible){
			if(FlxG.keys.justPressed("X"))
				tipManager.HideTip();
			return;
		}

		// Block Prority #2 End Pause
		if(endPause){
			endGroup.update();

			#if !FLX_NO_KEYBOARD
			if(endBg.visible){
				if(FlxG.keys.justPressed("UP"))
					ChangeSelEnd(curSelEnd-1);
				else if(FlxG.keys.justPressed("DOWN"))
					ChangeSelEnd(curSelEnd+1);
				else if(FlxG.keys.justPressed("X"))
					ActionEnd(curSelEnd);
			}
			#end
			return;
		}

		// return above this line to pause default flixel game hehavior
		super.update();

		// Pause game by player
		#if !FLX_NO_KEYBOARD
		if(FlxG.keys.justPressed("P")){
			Pause(true);
		}
		#end

		// handle skip
		if(toSkip.visible){
			var toSkipTriggered = false;
			#if !FLX_NO_MOUSE
			toSkipTriggered = FlxG.mouse.justReleased() && toSkip.overlapsPoint(FlxG.mouse.getScreenPosition());
			#end
			if(toSkipTriggered)
			{
				toSkip.visible = false;
				if(skipFun != null)skipFun();
			}
		}

		if(tileCoverD != null && tileCoverD.visible)
			FlxG.collide(bullets, tileCoverD, function(b:FlxObject, t:FlxObject){b.kill();});

		// check camera tween
		if(camTweening && camXTweenDone && camYTweenDone){
			camTweening = false;
			if(onCamTweenDone!=null)
				onCamTweenDone();
		}

		// computer trigger
		FlxG.overlap(bot, coms, function(b:FlxObject, c:FlxObject){
			var com:Com = cast(c, Com);
			if(bot.On && lineMgr.isEnd && input.JustDown_Action && com.onTig!=null){
				com.ToggleOn();
			}
		});

		FlxG.collide(bigGuns, bot);
		FlxG.collide(aCatchs, bot);
		FlxG.collide(gpUps, bot);
		FlxG.collide(gpMids, bot);
		FlxG.collide(gpDowns, bot);

		// laser hurt bot
		FlxG.overlap(lasers, bot, function(l:FlxObject, b:FlxObject){if(cast(l, Laser).NowOn)b.hurt(20);});

		FlxG.collide(guards, tileJS);
		FlxG.collide(bWalks, tileJS);

		// hp repair for bot
		FlxG.overlap(hps, bot, function(h:FlxObject, b:FlxObject){if(!cast(h, Repair).waitOn){bot.health = Bot.maxHealth; h.kill();}});

		// tile that collides enemy only
		FlxG.collide(tileEO,guards);

		// zball hurt bot
		if(zball!=null)
			FlxG.overlap(zball, bot, function(z:FlxObject, bot:FlxObject) { bot.hurt(30); } );
		
		FlxG.overlap(bullets, cubes, function(b:FlxObject, c:FlxObject) { b.kill(); c.hurt(1); } );
		FlxG.collide(cubes, bot);
		FlxG.overlap(mines, bot, function(m:FlxObject, b:FlxObject) { m.kill(); bot.hurt(20); } );
		
		FlxG.collide(lifts, bot);
		
		FlxG.collide(tileNail, bot, function(t:FlxObject, b:FlxObject) { b.hurt(20); b.velocity.y = -300; } );
		
		FlxG.overlap(bullets, bWalks, function(b:FlxObject, bw:FlxObject) { b.kill(); bw.hurt(1); } );
		FlxG.overlap(bullets, guards, function(b:FlxObject, g:FlxObject) { b.kill(); g.hurt(1); } );
		
		FlxG.collide(bWalks, tile);
		
		FlxG.overlap(bTriggers, bot, function(bt:FlxObject, b:FlxObject) { cast(bt,BTrigger).TryTrigger(); } );
		FlxG.overlap(bWalks, bot, function(bw:FlxObject, b:FlxObject) { bw.kill(); bot.hurt(30); } );
		FlxG.overlap(guards, bot, function(g:FlxObject, b:FlxObject) { bot.hurt(20); } );
		
		FlxG.overlap(bWalks, bWalks, function(b1:FlxObject, b2:FlxObject) { b1.kill(); b2.kill(); } );
		
		FlxG.collide(tilePO, bot);
		FlxG.collide(tile, guards);
		
		
		// BGB on bot
		FlxG.overlap(bot, bigGunBuls, function(bot:FlxObject, bgb:FlxObject):Void {bot.hurt(20);bgb.kill();});
		
		// Bullet Killing!
		for(bul in bullets.members) {
		if (!cast(bul,FlxSprite).onScreen())
			bul.kill(); }
		for(bgb in bigGunBuls.members) {
		if (!cast(bgb,FlxSprite).onScreen())
			bgb.kill(); }
		for (fgb in fgBuls.members) {
		if (!cast(fgb,FlxSprite).onScreen())
			fgb.kill(); }
			
		FlxG.overlap(bot, ducks, function(bot:FlxObject, d:FlxObject) {bot.hurt(20);d.kill();});
		FlxG.overlap(bullets, ducks, function(bul:FlxObject, duck:FlxObject){bul.kill();duck.hurt(1);});
		
		if(jsCntr==0)
			FlxG.collide(tileJS, bot);
		else
			jsCntr--;
		
		// Bullet Hits
		FlxG.collide(bullets, tile, function(bul:FlxObject, tile:FlxObject){bul.kill();	});
		FlxG.collide(bigGunBuls, tile, function(bul:FlxObject, tile:FlxObject){bul.kill();});
		FlxG.overlap(bullets, Bees, function(bul:FlxObject, bee:FlxObject) {bul.kill();bee.hurt(1);});
		FlxG.overlap(bullets, bigGuns, function (bul:FlxObject, g:FlxObject){bul.kill();g.hurt(1);	});
		FlxG.overlap(bullets, gpUps, function (bul:FlxObject, gp:FlxObject) {bul.kill();gp.hurt(1);});
		FlxG.overlap(bullets, gpMids, function (bul:FlxObject, gp:FlxObject) {bul.kill();gp.hurt(1);});
		FlxG.overlap(bullets, gpDowns, function (bul:FlxObject, gp:FlxObject) { bul.kill(); gp.hurt(1); } );
		FlxG.overlap(bullets, aCatchs, function(b:FlxObject, ac:FlxObject){b.kill(); ac.hurt(1);});
		
		FlxG.collide(bot, tile);
		FlxG.collide(bot, tileCover);
		
		// active fixed enemy
		var camRectEx:FlxRect = new FlxRect(FlxG.camera.scroll.x - 50, FlxG.camera.scroll.y - 25, FlxG.width + 100, FlxG.height + 50);
		for (bg in bigGuns.members) 
		{
			var bgSpr:FlxSprite = cast(bg,FlxSprite);
			var r:FlxRect = new FlxRect(bgSpr.x, bgSpr.y, bgSpr.width, bgSpr.height);
			if (r.overlaps(camRectEx))
				bgSpr.active = true;
			else 
				bgSpr.active = false;
		}
		for (gpU in gpUps.members) 
		{
			var gpUSpr:FlxSprite = cast(gpU,FlxSprite);
			var r:FlxRect = new FlxRect(gpUSpr.x, gpUSpr.y, gpUSpr.width, gpUSpr.height);
			if (r.overlaps(camRectEx))
				gpUSpr.active = true;
			else 
				gpUSpr.active = false;
		}
		for (gpM in gpMids.members) 
		{
			var gpMSpr:FlxSprite = cast(gpM,FlxSprite);
			var r:FlxRect = new FlxRect(gpMSpr.x, gpMSpr.y, gpMSpr.width, gpMSpr.height);
			if (r.overlaps(camRectEx))
				gpMSpr.active = true;
			else 
				gpMSpr.active = false;
		}
		for (gpD in gpDowns.members) 
		{
			var gpDSpr:FlxSprite = cast(gpD,FlxSprite);
			var r:FlxRect = new FlxRect(gpDSpr.x, gpDSpr.y, gpDSpr.width, gpDSpr.height);
			if (r.overlaps(camRectEx))
				gpDSpr.active = true;
			else 
				gpDSpr.active = false;
		}
		
		// update boss health bar
	}

	#if !FLX_NO_KEYBOARD
	public function ChangeSelEnd(selId:Int){
		while(selId<0) selId += maxSelEnd;
		while(selId>=maxSelEnd) selId -= maxSelEnd;
		curSelEnd = selId;
		switch (curSelEnd) {
			case 0:
				selector_End.x = btnHelp.x + GameStatic.offset_border;
				selector_End.y = btnHelp.y + GameStatic.offset_border;
			case 1:
				selector_End.x = btnMap.x + GameStatic.offset_border;
				selector_End.y = btnMap.y + GameStatic.offset_border;
			case 2:
				selector_End.x = btnAgain.x + GameStatic.offset_border;
				selector_End.y = btnAgain.y + GameStatic.offset_border;
		}
	}

	public function ActionEnd(id:Int){
		switch (id) {
			case 0:
			if(isWin)
				FlxG.switchState(GameStatic.GetNextInst());
			else
				nme.Lib.getURL(new URLRequest(GameStatic.helpLink));	// TODO link to help page
			case 1:
			FlxG.switchState(new GameMap());
			case 2:
			// TODO show confirm
			FlxG.switchState(GameStatic.GetCurLvlInst());
		}
	}

	public function ChangeSelPause(selId:Int){
		while(selId<0) selId += maxSelPause;
		while(selId>=maxSelPause) selId -= maxSelPause;
		curSelPause = selId;
		switch (curSelPause) {
			case 0:
				selector_Pause.x = btnResume_Pause.x + GameStatic.offset_border;
				selector_Pause.y = btnResume_Pause.y + GameStatic.offset_border;
			case 1:
				selector_Pause.x = btnAgain_Pause.x + GameStatic.offset_border;
				selector_Pause.y = btnAgain_Pause.y + GameStatic.offset_border;
			case 2:
				selector_Pause.x = btnQuit_Pause.x + GameStatic.offset_border;
				selector_Pause.y = btnQuit_Pause.y + GameStatic.offset_border;
		}
	}

	public function ActionPause(id:Int){
		switch (id) {
			case 0:
			Pause(false);
			case 1:
			confirm.ShowConfirm(Confirm.Mode_YesNo, true, "Current Process Will Be Lost, Continue?", "Yes", "No", true,
				function(){FlxG.switchState(GameStatic.GetCurLvlInst());}, null);
			case 2:
			confirm.ShowConfirm(Confirm.Mode_YesNo, true, "Current Process Will Be Lost, Continue?", "Yes", "No", true,
				function(){FlxG.switchState(new GameMap());}, null);
		}
	}
	#end

	public function DisJS1Frame():Void
	{
		jsCntr = 10;
	}

	public function GetTile(name:String, collFlag:Int):FlxTilemap
	{
		var tMap:FlxTilemap = new FlxTilemap();
		tMap.allowCollisions = collFlag;
		var layer:TmxLayer = tmx.getLayer(name);
		if (layer == null)
		{
			return EmptyTile;
		}
		var ts:TmxTileSet = tmx.getTileSet('defTile');	// force tiled use the name defTile
		var mapCsv:String = layer.toCsv(ts);
		tMap.loadMap(mapCsv, "assets/img/defTile.png", 20, 20);
		return tMap;
	}

	public function ShowBossHP(show:Bool):Void
	{
		if (show)
		{
			hbL.visible = true;
			hbR.visible = true;
			hbBg.visible = true;
			hbH.visible = true;
		}
		else
		{		
			hbL.visible = false;
			hbR.visible = false;
			hbBg.visible = false;
			hbH.visible = false;
		}
	}

	public function AddExp(x:Float, y:Float):Void
	{
		var b:BombExplosion = cast(bombFlower.recycle(BombExplosion) , BombExplosion);
		b.make(x, y, 0, false);
	}

	public function AddHugeExplo(x:Float, y:Float){
		var h:FlxSprite = cast(hugeExplos.recycle(FlxSprite), FlxSprite);
		h.reset(x, y);
		h.loadGraphic("assets/img/hugeExplo.png", true, false, 128, 128);
		h.addAnimation("def",[0,1,2,3,4,5,6,7,8,9,10], 8, false);
		h.x = x - h.width/2; h.y = y - h.height/2;
		h.play("def");
	}

	public function EndLevel(win:Bool=true){
		this.isWin = win;
		this.isEnd = true;
		bot.On = false;

		if(isWin && GameStatic.ProcLvl < GameStatic.CurLvl)
			GameStatic.ProcLvl = GameStatic.CurLvl;

		endMask.visible = true;
		endMask.alpha = 0;
		TimerPool.Get().start(0.1, 20, function(t:FlxTimer){
			endMask.alpha += 0.03;
		});
		TimerPool.Get().start(2, 1, function(t:FlxTimer){
			endPause = true;
			endBg.visible = true;
			selector_End.visible = true;
			btnAgain.visible = true;
			btnMap.visible = true;
			lbMission.visible = true;
			lbResult.visible = true;
			if(isWin){
				btnNext.visible = true;
				lbResult.text = "ACCOPLISHED";
			}
			else{ 
				btnHelp.visible = true;
				lbResult.text = "FAILED";
			}
			#if !FLX_NO_MOUSE
			FlxG.mouse.show(); 
			#end
		});
	}

	public function ShowEnd(){
		// TODO
	}

	private function ShowPause(isShow:Bool){
		pauseBg.visible = isShow;
		pauseMask.visible = isShow;
		selector_Pause.visible = isShow;
		btnResume_Pause.visible = isShow;
		btnAgain_Pause.visible = isShow;
		btnQuit_Pause.visible = isShow;
		lbPaused.visible = isShow;
	}

	public function TweenCamera2(scrollX:Float, scrollY:Float, dur:Float, useEase:Bool, onDone:Void->Void){
		camScrollXTween.tween(FlxG.camera.scroll, "x", scrollX, dur, useEase?Ease.quartInOut:null);
		camScrollYTween.tween(FlxG.camera.scroll, "y", scrollY, dur, useEase?Ease.quartInOut:null);
		camXTweenDone = false;
		camYTweenDone = false;
		camTweening = true;
		onCamTweenDone = onDone;
	} 

	public function TweenCamera(focusX:Float, focusY:Float, dur:Float, useEase:Bool, onDone:Void->Void){
		TweenCamera2(focusX - FlxG.camera.width * 0.5, focusY - FlxG.camera.height * 0.5, dur, useEase, onDone);
	}

	public function ShowSkip(show:Bool, call:Void->Void=null){
		toSkip.visible = show;
		skipFun = call;
	}

	public function ShowHelp(show:Bool){


	}

	public function ShowSceneName(name:String){
		sceneName.text = name;
		var twn:VarTween = new VarTween(null, FlxTween.ONESHOT);
		twn.tween(sceneName, "alpha", 1, 2, Ease.quartOut);
		twn.complete = function(){
			TimerPool.Get().start(2, 1, function(t:FlxTimer){
				var twn2:VarTween = new VarTween(null, FlxTween.ONESHOT);
				twn2.tween(sceneName, "alpha", 0, 2, Ease.quartOut);
				addTween(twn2);
			});
		};
		addTween(twn);
	}

	public override function onFocus(){
		// Nothing to do here
	}

	public override function onFocusLost(){
		// there are situations there's no need to pause even focus lost
		if(!FlxG.paused && !isEnd && !(confirm.visible&&confirm.isModel))
			Pause(true);
	}

	public override function Pause(pause:Bool){
		if(pause && !(confirm.visible && confirm.isModel) && !isEnd){
			FlxG.paused = true;
			ShowPause(true);
		}
		if(!pause){
			FlxG.paused = false;
			ShowPause(false);
		}

		super.Pause(pause);	// just update pause button
	}
}