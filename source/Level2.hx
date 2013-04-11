package;
import org.flixel.FlxText;
import org.flixel.FlxG;
import org.flixel.FlxEmitter;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import org.flixel.FlxPoint;
import org.flixel.system.FlxTile;
import org.flixel.FlxTimer;

class Level2 extends Level
{
public static var STpreDash 	: Int = 0;
public static var STpreTalk 	: Int = 1;
public static var STfight		: Int = 2;
public static var STpostTalk	: Int = 3;

public var lvlState : Int;	// 0-preDash 1-preTalk 2-fight 3-postTalk

public var preDashFocus : FlxPoint;
public static var xExtend:Float = 550 * 0.1;

// Boss Tile Breaker Group
public var breakers:FlxGroup; 	// for collision use
// boss collision rect
public var brGP:FlxSprite;	// define individually to track offset
public var brBody:FlxSprite;
public var brHandR:FlxSprite;
public var brLeg:FlxSprite;
public var brHandL:FlxSprite;

// Boss Fighting Constant
public static var bossX:Float = 464 - 77;
public static var bossY:Float = 360 - 95 - 8;//304 - 77;
public static var bossBury:Float = 200;
public static var bossPreDashSpeed :Float = 5;

// Camera Constant
public static var camFinalPoint:FlxPoint = new FlxPoint(550/2, 400/2);
public static var camMoveTime:Float = 1*75;
public var camMoveXUnit:Float;
public var camMoveYUnit:Float;

// Exping & Debug
public var picker:FlxText;

// Surface Base
public var sbLife:Float;
public var tSBHeal:FlxText;

public function new()
{
	super();
	
	tileXML = nme.Assets.getText("assets/dat/level2.tmx");
	
	lines1 = [
	"Whoa! MetalAnger! such a BIG guy!", 
	"glade to see you ready, cube bot.", 
	"as you see the MetalAnger is invading the core of moon base",
	"you have to do your best to brevent him",
	"lucky, the guy have no way to come up here",
	"remenber to make use of his own canon.",
	];
	
	lines2 = [
	"He is moving to the sub-base", 
	"prepare your self, bot!"
	];
}

override public function create():Void
{
	super.create();
	
	GameStatic.CurLvl = 2;
	
	lvlState = 0;
	
	preDashFocus = new FlxPoint(xExtend, 200+100-10);
	
	bossBury = 300;
	
	// BG for Game and PreDash
	bg1 = new FlxSprite(0,0, "assets/img/mSurf2.png");
	bg1.x = xExtend; bg1.y = 0; 
	bg2 = new FlxSprite(0,0, "assets/img/mSurf2.png");
	bg2.x = xExtend-FlxG.width; bg2.y = 0; 
	
	// Load Tiles
	tileScene 	= GetTile("scene", FlxObject.NONE); 
	tileUp 	= GetTile("tileUp", FlxObject.UP); 
	tileBreak 	= GetTile("break", FlxObject.ANY); 
	tileBreak.setTileProperties(0, FlxObject.ANY , onBreak, null, tileBreak._tileObjects.length);	// set all breakable to handle collision
	
	sBase = new FlxSprite(13 * 20, 20 * 5 + 10, "assets/img/sBase.png");
	sBase.offset = new FlxPoint(121, 42);
	sBase.width = 60; sBase.height = 75;
	sBase.health = 100;
	
	boss1 = new Boss1(bossX + xExtend, bossY/* + bossBury*/, this); 	// final pos 10, 230
	tileCover = GetTile( "cover", FlxObject.NONE); 
	
	smokeEmt1 = new FlxEmitter(550, 375);
	smokeEmt1.x = xExtend - 100;			// x pos for preDash;
	smokeEmt1.y = 265 + 100;
	smokeEmt1.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
	smokeEmt1.start(false, 0.5, 0.03, 0);
	smokeEmt1.setXSpeed(0, 50);
	smokeEmt1.setYSpeed(80, -180);
	
	smokeEmt2 = new FlxEmitter(-100, 0);
	smokeEmt2.width = 65; smokeEmt2.height = 10;
	smokeEmt2.makeParticles("assets/img/smoke.png", 10, 5, true, 0);
	smokeEmt2.setXSpeed(-50, 50);
	smokeEmt2.setYSpeed(-30, -10);
	
	breakers = new FlxGroup();
	brGP = new FlxSprite();
	brGP.makeGraphic(72,26, 0x00ffffff);
	breakers.add(brGP);
	brBody = new FlxSprite();
	brBody.makeGraphic(72,37, 0x00ffffff);
	breakers.add(brBody);
	brHandR = new FlxSprite();
	brHandR.makeGraphic(33,14, 0x00ffffff);
	breakers.add(brHandR);
	brHandL = new FlxSprite();
	brHandL.makeGraphic(34,16, 0x00ffffff);
	breakers.add(brHandL);
	brLeg = new FlxSprite();
	brLeg.makeGraphic(78,47, 0x00ffffff);
	breakers.add(brLeg);
	
	picker = new FlxText(5, 380, 100);
	picker.scrollFactor = new FlxPoint(0,0);
	
	FlxG.camera.follow(boss1);
	
	// Exping
	eExplo = new FlxSprite(-100,0);
	eExplo.loadGraphic("assets/img/elecExplo.png", true, false, 25, 25);
	eExplo.addAnimation("expl", [10,0,1,2,3,4,5,6,7,8,9,10], 10, true);
	eExplo.scale = new FlxPoint(1.5, 1.5);
	//eExplo.play("expl");
	
	tSBHeal = new FlxText(10, 100, 100);
	
	// Addings
	add(breakers);
	AddAll();
	add(tSBHeal);
	
	// initial
	drHead.visible = true;
	line.visible = true;
	lineBg.visible = true;
	bot.On = false;
	ResUtil.playGame1();
}

override public function update():Void
{
	smokeEmt2.x = boss1.x;
	smokeEmt2.y = 360 - 5;
	
	eExplo.x = boss1.x + 30;
	eExplo.y = boss1.y + 30;
	
	tSBHeal.text = Std.string(sBase.health);
	
	switch(lvlState)
	{
	case STpreDash:
		preDashFocus.x -= bossPreDashSpeed;
		preDashFocus.y -= bossPreDashSpeed / xExtend * 100;
		
		smokeEmt1.x -= bossPreDashSpeed;
		//smokeEmt.y -= preDashSpeed.0 / xExtend * 100;
		boss1.x -= bossPreDashSpeed;
		//boss.y -= bossPreDashSpeed / xExtend * bossBury;
		if(smokeEmt1.x < 0)
		smokeEmt1.x = FlxG.width;
		if(boss1.x <= 460)
		{
		preDashFocus.x = FlxG.width/2;
		switchState(1);
		smokeEmt1.on = false;
		}
		//FlxG.camera.focusOn(preDashFocus);
		
	case STpreTalk:
		if(Math.abs(FlxG.camera.scroll.x + FlxG.width * 0.5 - camFinalPoint.x) > 3)
		{
			FlxG.camera.scroll.x += camMoveXUnit;
			FlxG.camera.scroll.y += camMoveYUnit;
		}
		else
		{
		FlxG.camera.focusOn(camFinalPoint);
		}
		
		if(FlxG.keys.justPressed("SPACE"))
		{
		lineId1++;
		if(lineId1 >=lines1.length)
		{
			lineBg.visible =false;
			line.visible = false;
			drHead.visible = false;
			bot.On = true;
			boss1.switchState(1);
			ShowBossHP(true);
		}
		else
		{
			line.text = lines1[lineId1];
		}
		}
		
	case STfight:
		
	case STpostTalk:
		if(FlxG.keys.justPressed("SPACE"))
		{
		lineId2++;
		if(lineId2 >=lines2.length)
		{
			lineBg.visible =false;
			line.visible = false;
			drHead.visible = false;
			boss1.switchState(8);
			lvlState = 4;
		}
		else
		{
			line.text = lines2[lineId2];
		}
		}
		
	}
	
	if(!bg1.onScreen())
	bg1.x -= 2*FlxG.width;
	if(!bg2.onScreen())
	bg2.x -= 2*FlxG.width;
	
	//FlxG.camera.follow(boss);
	
	//tileBreak.overlapsWithCallback(boss, onBreak);
	//tileBreak.overlaps(boss);
	
	brGP.x = boss1.x + 40;
	brGP.y = boss1.y + 26;
	brBody.x = boss1.x + 41;
	brBody.y = boss1.y + 54;
	brHandR.x = boss1.x + 6;
	brHandR.y = boss1.y + 80;
	brHandL.x = boss1.x + 118;
	brHandL.y = boss1.y + 83;
	brLeg.x = boss1.x + 38;
	brLeg.y = boss1.y + 97;
	
	//for(var i:Int=0;i<breakers.countLiving();i++)
	//{
	//cast(breakers.members[i] , FlxSprite).offset = new FlxPoint(50,50);	
	//cast(breakers.members[i] , FlxSprite).x = boss.x;
	//cast(breakers.members[i] , FlxSprite).y = boss.y;		
	//}
	
	picker.text = Math.round(FlxG.mouse.x) + "," + Math.round(FlxG.mouse.y);
	
	var v:Float = boss1.health / Boss1.maxLife / 10 * 310;
	if(v<0)v = 0;
	hbH.scale = new FlxPoint(v,1);
	
	FlxG.collide(tileUp,bot);
	tileBreak.overlaps(breakers);
	
	FlxG.overlap(boss1, bullets, function(b:FlxObject, bul:FlxObject){b.hurt(1);bul.kill();});	// bullet
	FlxG.collide(tile, ducks, duckHitTile);							// duck
	FlxG.collide(tileUp, ducks, function(t:FlxObject, d:FlxObject) { if (d.velocity.x < (FlxG.camera.scroll.x + FlxG.width/2)) d.velocity.x = 80; else if (d.velocity.x > (FlxG.camera.x + FlxG.width/2)) d.velocity.x = -80; } );
	FlxG.overlap(sBase, ducks, function(b:FlxObject, d:FlxObject) {
		b.hurt(10);
		d.kill(); 
	});
	
	super.update();	
}

private function duckHitTile(tile:FlxObject, duck:FlxObject):Void
{
	duck.velocity.x = -duck.velocity.x;
	if(Math.abs(duck.velocity.x) < 80)
	duck.velocity.x = 80;
}

public function switchState(state:Int):Void
{
	lvlState = state;
	
	switch(lvlState)
	{
	case STpreDash:	// pre dash
		
	case STpreTalk:	// pre talk
		FlxG.camera.follow(null);
		var curCamPos:FlxPoint = new FlxPoint(FlxG.camera.scroll.x + FlxG.width * 0.5, FlxG.camera.scroll.y + FlxG.height * 0.5);
		camMoveXUnit = (camFinalPoint.x - curCamPos.x) / camMoveTime;
		camMoveYUnit = (camFinalPoint.y - curCamPos.y) / camMoveTime;
		birthRay.x = 150;
		birthRay.play("birth");
		bot.x = 152;
		bot.y = 130;
		//FlxG.camera.focusOn(camFinalPoint);
		
	case STfight:	// fight
		
	case STpostTalk:	// post talk
		ShowBossHP(false);
		bot.On = false;
		lineBg.visible = true;
		line.visible = true;
		drHead.visible = true;
		line.text = lines2[0];
		
	case 5:
		if (GameStatic.ProcLvl < 2) GameStatic.ProcLvl = 2;
		timer1.start(1, 1, function(t:FlxTimer) { FlxG.switchState(new Win());} );
		
	}
}

public function onBreak(t:FlxObject, b:FlxObject):Void
{
	var tile:FlxTile = cast(t, FlxTile);
	if(tile.mapIndex!=0 && tileBreak.getTileByIndex(tile.mapIndex) != 0)
	{
	tileBreak.setTileByIndex(tile.mapIndex, 0);
	
	breakEmt.x = tile.x;
	breakEmt.y = tile.y;
	for(i in 0...4)
	{
		breakEmt.emitParticle();
	}
	}
}
}