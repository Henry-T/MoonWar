package;
import org.flixel.FlxText;
import org.flixel.FlxRect;
import org.flixel.FlxG;
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
import nme.Assets;

class Level extends FlxState
{
// button for phone
public var btnUp:FlxSprite;
public var btnDown:FlxSprite;
public var btnLeft:FlxSprite;
public var btnRight:FlxSprite;
public var btnUpLeft:FlxSprite;
public var btnDownLeft:FlxSprite;
public var btnUpRight:FlxSprite;
public var btnDownRight:FlxSprite;
public var btnShoot:FlxSprite;
public var btnJump:FlxSprite;


// bg
public var bgStar:FlxSprite;
public var bgMetal:FlxSprite;
public var bg1:FlxSprite;
public var bg2:FlxSprite;

// Tiles
public var tileXML:String;	// Set this in Constructor to perform preload
public var tmx:TmxMap;
public var EmptyTile:FlxTilemap;
public var tileCover:FlxTilemap;	// cover everything
public var tileBreak:FlxTilemap;	// logic tile : can be break (logic)
public var tileUp:FlxTilemap;		// logic tile : can jump throuth
public var tile:FlxTilemap;			// tile for anything
public var tileEO:FlxTilemap;		// tile for enemy collide only
public var tilePO:FlxTilemap;		// tile for player only
public var tileJS:FlxTilemap;		// tiles can jump through
public var tileBg:FlxTilemap;		// justBg
public var tileBgFar:FlxTilemap;	// bg under all!
public var tileNail:FlxTilemap;		// nail trap for bot!
public var tileLand:FlxTilemap;		// breakable land1 for level4
public var tileLand2:FlxTilemap;	// breakable land2 for level4

// Dialog
public var lines1:Array<Line>;
public var lines2:Array<Line>;
public var lines3:Array<Line>;
public var lines4:Array<Line>;

// New Dialog
public var lineMgr:LineMgr;

// Data
public var rGameOver:Bool;
public var isWin:Bool;
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
public var boss2:Boss2;
public var boss3:Boss3;
public var sBase:FlxSprite;
public var cubes:FlxGroup;
public var zball:FlxSprite;		// zBall in level7
public var coms:FlxGroup;
public var gate:FlxSprite;

// Bullets
public var bullets:FlxGroup;	// Bullets of Bot
public var bigGunBuls:FlxGroup;	// Bullets of Bit Gun
public var fgBuls:FlxGroup;		// Bullets of Fixed Gun
public var missles:FlxGroup;	// Missle of Rocket Launcher & BossLvl4
public var bouncers:FlxGroup;	// Bounce Bullets by BossLvl4

// items
public var hps:FlxGroup;		// hp

// Particles
public var bombFlower:FlxGroup;	// Normal Explosion Sprite Group
public var breakEmt:FlxEmitter; 	// Intelligence Broken Tile Emitter
public var explo2s:FlxGroup;	// explosion type 2

// Effects
public var birthRay:FlxSprite;
public var smokeEmt1:FlxEmitter;
public var smokeEmt2:FlxEmitter;
public var eExplo:FlxSprite;

// Huds
public var tips:FlxGroup;
public var hud:FlxSprite;
public var bhBar:FlxSprite;
public var bhCover:FlxSprite;
public var hbL:FlxSprite;	// Boss Health
public var hbR:FlxSprite;
public var hbBg:FlxSprite;
public var hbH:FlxSprite;

// Utility
public var timer1:FlxTimer;
public var timer2:FlxTimer;
public var gvTimer:FlxTimer;	// Game Over Time
public var jsCntr:Int;		//

// doors
public var door1Up:LDoor;	// level entrance door
public var door2Down:LDoor;	// level exit door under bot
public var door2Up:LDoor;	// level exit door over bot


// misc
public var bInLift:FlxSprite;
public var bInLift2:FlxSprite;
public var energy:FlxSprite;
public var eStar:FlxSprite;

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

	btnUp = new FlxSprite(100, FlxG.height - 150); btnUp.makeGraphic(70, 40, 0x44ffffff); btnUp.scrollFactor.make(0,0);
	btnDown = new FlxSprite(100, FlxG.height - 50); btnDown.makeGraphic(70, 40, 0x44ffffff); btnDown.scrollFactor.make(0,0);
	btnLeft = new FlxSprite(10, FlxG.height - 100); btnLeft.makeGraphic(70, 40, 0x44ffffff); btnLeft.scrollFactor.make(0,0);
	btnRight = new FlxSprite(180, FlxG.height - 100); btnRight.makeGraphic(70, 40, 0x44ffffff); btnRight.scrollFactor.make(0,0);
	
	btnJump = new FlxSprite(FlxG.width - 100, FlxG.height - 120); btnJump.makeGraphic(60, 60, 0x44ffffff); btnJump.scrollFactor.make(0,0);
	btnShoot = new FlxSprite(FlxG.width - 200, FlxG.height - 120); btnShoot.makeGraphic(60, 60, 0x44ffffff); btnShoot.scrollFactor.make(0,0);

	EmptyTile = new FlxTilemap();
	var eD:Array<Int> = [0,0,0,0];
	EmptyTile.loadMap(FlxTilemap.arrayToCSV(eD, 2), "assets/img/defTile.png", 20, 20);	
	
	
	FlxG.mouse.hide();
	
	jsCntr = 0;
	
	rGameOver = false;
	isWin = false;
	
	timer1 = new FlxTimer();
	timer2 = new FlxTimer();
	gvTimer = new FlxTimer();
	
	// Preload Tile Data
	if (tileXML != null)
	tmx = new TmxMap(tileXML);
	
	// Bullets
	bullets = new FlxGroup();
	bigGunBuls = new FlxGroup();
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
	
	// Effects
	birthRay = new FlxSprite(-100,0);
	birthRay.loadGraphic("assets/img/birthRay.png", true, false, 30, 10);
	birthRay.scale = new FlxPoint(1, 42);
	birthRay.addAnimation("birth", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 5, false);
	
	// Huds
	tips = new FlxGroup();
	hud = new FlxSprite(0,0, "assets/img/hud.png");
	hud.scrollFactor = new FlxPoint(0,0);
	bhBar = new FlxSprite(49, 20, "assets/img/bhBar.png");
	bhBar.scrollFactor = new FlxPoint(0, 0); bhBar.origin = new FlxPoint(0, 0);
	bhCover = new FlxSprite(49, 20, "assets/img/bhCover.png");
	bhCover.scrollFactor = new FlxPoint(0, 0);
	
	hbL = new FlxSprite(100, 370, "assets/img/hbL.png"); hbL.scrollFactor = new FlxPoint(0, 0); hbL.visible = false;
	hbR = new FlxSprite(430, 370, "assets/img/hbR.png"); hbR.scrollFactor = new FlxPoint(0, 0); hbR.visible = false;
	hbBg = new FlxSprite(120, 370, "assets/img/hbBg.png"); hbBg.origin = new FlxPoint(0, 0); hbBg.scale = new FlxPoint(31, 1); hbBg.scrollFactor = new FlxPoint(0, 0); hbBg.visible = false;
	hbH = new FlxSprite(120, 370, "assets/img/hbH.png"); hbH.origin = new FlxPoint(0, 0);  hbH.scrollFactor = new FlxPoint(0, 0); hbH.visible = false;
	
	// Dialogs
	// try load tile layers
	tileBgFar = GetTile("bgFar", FlxObject.NONE);
	tileBg = GetTile("bg", FlxObject.NONE);
	tile = GetTile("tile", FlxObject.ANY);
	tileEO = GetTile("eo", FlxObject.ANY);
	tileJS = GetTile("js", FlxObject.UP);
	tilePO = GetTile("po", FlxObject.ANY);
	tileNail = GetTile("nail", FlxObject.ANY);
	tileCover = GetTile("cover", FlxObject.ANY);
	
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
			cube.reset(o.x, o.y);
		}
		else if (o.type == "com")
		{
			// do nothing.. com will be load by levels themself
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
		bWalk.reset(o.x, o.y);
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
}

public function AddAll():Void
{
	add(bgStar);
	add(bgMetal);
	add(bg1);
	add(bg2);
	
	add(tileBgFar);
	add(bInLift);
	add(bInLift2);
	add(tileBg);
	add(tile);
	add(tileEO);	tileEO.visible = false;
	add(tileUp);
	add(tileBreak);
	add(tileNail);
	add(tilePO);
	add(tileJS);
	add(tileLand);
	add(tileLand2);
	add(tips);
	add(lifts);
	add(tileJS);
	add(tileNail);
	
	add(door2Down);
	add(energy);
	add(eStar);
	add(sBase);
	add(coms);

	add(hps);
	
	add(breakEmt);
	add(bigGunBuls);
	add(missles);
	add(bouncers);
	
	add(cubes);
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
	add(boss2);
	add(boss3);
	add(Bees);
	add(mines);
	add(zball);
	add(gate);
	
	add(t);
	add(bullets);
	add(bot);
	
	add(tileCover);
	
	add(door2Up);
	add(door1Up);
	
	add(birthRay);
	add(explo2s);
	add(eExplo);
	add(smokeEmt1);
	add(smokeEmt2);
	add(bombFlower);
	
	add(hud);
	add(bhBar);
	add(bhCover);
	
	add(lineMgr);
	
	add(hbL);
	add(hbR);
	add(hbBg);
	add(hbH);

	#if android
	add(btnUp);
	add(btnDown);
	add(btnLeft);
	add(btnRight);
	add(btnJump);
	add(btnShoot);
	#end
}

override public function update():Void 
{
	// laser hurt bot
	FlxG.overlap(lasers, bot, function(l:FlxObject, b:FlxObject){if(cast(l, Laser).NowOn)b.hurt(20);});

	FlxG.collide(guards, tileJS);

	// hp repair for bot
	FlxG.overlap(hps, bot, function(h:FlxObject, b:FlxObject){bot.health += 10; h.kill();});

	// tile that collides enemy only
	FlxG.collide(tileEO,guards);

	// computer trigger
	FlxG.overlap(coms, bot, function(c:FlxObject, b:FlxObject) { 
		if (FlxG.keys.justPressed(bot.actionKey))
		{
			cast(c, Com).ToggleOn();
		}
	} );
	
	// zball hurt bot
	if(zball!=null)
		FlxG.overlap(zball, bot, function(z:FlxObject, bot:FlxObject) { bot.hurt(20); } );
	
	FlxG.overlap(bullets, cubes, function(b:FlxObject, c:FlxObject) { b.kill(); c.hurt(1); } );
	FlxG.collide(cubes, bot);
	FlxG.overlap(mines, bot, function(m:FlxObject, b:FlxObject) { m.kill(); bot.hurt(20); } );
	
	FlxG.collide(lifts, bot);
	
	//FlxG.overlap(tileNail, bot, function(t:FlxObject, b:Bot) { b.hurt(5); } );
	FlxG.collide(tileNail, bot, function(t:FlxObject, b:FlxObject) { b.hurt(5); b.velocity.y = -300; } );
	
	FlxG.overlap(bullets, bWalks, function(b:FlxObject, bw:FlxObject) { b.kill(); bw.hurt(1); } );
	FlxG.overlap(bullets, guards, function(b:FlxObject, g:FlxObject) { b.kill(); g.hurt(1); } );
	
	FlxG.collide(bWalks, tile);
	
	FlxG.overlap(bTriggers, bot, function(bt:FlxObject, b:FlxObject) { cast(bt,BTrigger).TryTrigger(); } );
	FlxG.overlap(bWalks, bot, function(bw:FlxObject, b:FlxObject) { bw.kill(); bot.hurt(30); } );
	FlxG.overlap(guards, bot, function(g:FlxObject, b:FlxObject) { g.kill(); bot.hurt(10); } );
	
	FlxG.overlap(bWalks, bWalks, function(b1:FlxObject, b2:FlxObject) { b1.kill(); b2.kill(); } );
	
	FlxG.collide(tilePO, bot);
	FlxG.collide(tile, guards);
	
	
	// BGB on bot
	FlxG.overlap(bot, bigGunBuls, function(bot:FlxObject, bgb:FlxObject):Void {bot.hurt(5);bgb.kill();});
	
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
	for (msl in missles.members) {
	if (!cast(msl,FlxSprite).onScreen())
		msl.kill(); }
	for (bcr in bouncers.members) {
	if (!cast(bcr,FlxSprite).onScreen())
		bcr.kill(); }
		
	FlxG.overlap(bot, ducks, function(bot:FlxObject, d:FlxObject) {bot.hurt(10);d.kill();});
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
	
	// update bot health bar
	if (bot!=null)
	{
	var bhs:Float = (bot.health / 100 > 0)?(bot.health/100):0;
	bhBar.scale = new FlxPoint(bhs, 1);
	}
	
	// update boss health bar
	
	
	super.update();
}

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

public function StartGV():Void
{
	gvTimer.start(2, 1, function(t:FlxTimer):Void {
	FlxG.fade(0xff000000, 2, function() { FlxG.switchState(new GameOver()); }, true);
	});
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
	b.reset(x, y);
}

}