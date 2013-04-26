package ;
import org.flixel.FlxRect;
import org.flixel.FlxG;
import org.flixel.FlxTilemap;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;

class Level8 extends Level 
{

public var downing:Bool;
public var botColOn:Bool;

public var triggerRect:FlxRect;
public var trigger:FlxSprite;
public var triggered:Bool;
public var righting:Bool;

public var bossPos:FlxPoint;

public var testPos1:FlxPoint;

public function new() 
{
	super();
	tileXML = nme.Assets.getText("assets/dat/level8.tmx");
	
	lines1 = [
		new Line(0,"Dr.Cube:It's too bad, RageMetal take control of the energy."), 
		new Line(2,"Finally, I will bring you ... doom!"), 
		new Line(1,"Then I have to bury you here now.")
	];
}

override public function create():Void 
{
	super.create();
	
	GameStatic.CurLvl = 8;
	
	// load misc
	var mG:TmxObjectGroup = tmx.getObjectGroup("misc");
	for(o in mG.objects)
	{
		if (o.name == "door1")
		{
			door1Up = new LDoor(o.x, o.y, true);
			bot.x = o.x+10; bot.y = o.y;
		}
		else if (o.name == "testPos1")
			testPos1 = new FlxPoint(o.x, o.y);
		else if (o.name == "trigger")
			triggerRect = new FlxRect(o.x, o.y, o.width, o.height);
		else if (o.name == "energy")
		{
			energy = new FlxSprite(o.x, o.y, "assets/img/energy.png");	
			eStar = new FlxSprite(o.x + 7, o.y+4, "assets/img/eStar.png");
		}
		else if (o.name == "boss")
			bossPos = new FlxPoint(o.x, o.y);
		else if (o.name == "gate")
		{
			gate = new FlxSprite(o.x, o.y);
			gate.makeGraphic(o.width, o.height, 0xffaaaaaa);
			gate.immovable = true;
			gate.y -= 100;
		}
	}
	
	bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift.png");
	tile.follow();
	
	
	boss3 = new Boss3(bossPos.x, bossPos.y);
	
	// trigger path to Boss room
	trigger = new FlxSprite(triggerRect.x, triggerRect.y);
	trigger.makeGraphic(Std.int(triggerRect.width), Std.int(triggerRect.height), 0x33224488); 
	
	add(trigger);
	AddAll();
	
	// initial scene
	bot.On = false;
	bot.facing = FlxObject.RIGHT;
	bInLift.velocity.y = 30;
	downing = true;
	righting = false;
	triggered = false;
	FlxG.camera.follow(bot);
	FlxG.flash(0xff000000, 2);
	ResUtil.playGame2();
	gate.visible = false;
}

override public function update():Void 
{
	// gate
	FlxG.collide(bot, gate);
	FlxG.overlap(gate, missles, function(g:FlxObject, msl:FlxObject):Void { msl.kill(); } );
	FlxG.overlap(gate, bouncers, function(g:FlxObject, bcr:FlxObject):Void { cast(bcr,Bouncer).bounceCount--; } );
	FlxG.overlap(gate, bigGunBuls, function(g:FlxObject, bgb:FlxObject):Void { bgb.kill(); } );
	
	FlxG.collide(bouncers, tile, function(bcr:FlxObject, tile:FlxObject) { cast(bcr,Bouncer).bounceCount--; } );
	FlxG.collide(bigGunBuls, tile, function(bgb:FlxObject, tile:FlxObject) { bgb.kill(); } );
	FlxG.collide(missles, tile, function(msl:FlxObject, tile:FlxObject):Void {msl.kill();});
	
	FlxG.overlap(bot, missles, function(bot:FlxObject, msl:FlxObject):Void { msl.kill(); } );
	FlxG.overlap(bot, bouncers, function(bot:FlxObject, bcr:FlxObject):Void { bcr.kill();} );
	FlxG.overlap(bot, bigGunBuls, function(bot:FlxObject, bgb:FlxObject):Void {bgb.kill();} );
	
	FlxG.collide(tile, boss3);		// Boss3 with Tile
	
	// bul on boss
	FlxG.overlap(bullets, boss3, function(bul:FlxObject, boss3:FlxObject):Void { 
	bul.kill();
	boss3.hurt(100);
	});
	
	// boss life gui
	var v:Float = boss3.health / Boss3.maxLife / 10 * 310;
	if(v<0)v = 0;
	hbH.scale = new FlxPoint(v, 1);
	
	// boss killed
	if (!isEnd && !boss3.alive){
		if (GameStatic.ProcLvl < 9) GameStatic.ProcLvl = 9;	// increase to Ending
		EndLevel(true);
	}
	
	// lift
	if (downing && bInLift.y > door1Up.y)
	{
	bInLift.velocity.y = 0;
	bot.EnableG(true);
	bot.On = true;
	door1Up.Unlock();
	//tileCover.visible = false;
	}
	
	if (door1Up.open && downing)
	{
	downing = false;
	bot.On = true;
	}
	
	// trigger
	if (!triggered && FlxG.overlap(bot, trigger))
	{
	triggered = true;
	righting = true;
	}
	if (righting)
	{
	bot.velocity.x = 60;
	if (!FlxG.overlap(bot, trigger))
	{
		righting = false;
		bot.velocity.x = 0;
		timer1.start(1, 1, function(t:FlxTimer):Void {
			lineMgr.Start(lines1, function(){
				gate.y += 100;
				gate.visible = true;
				boss3.ChangeState("launching");
				hbL.visible = true;
				hbR.visible = true;
				hbBg.visible = true;
				hbH.visible = true;
				ResUtil.playGame1();
			});
			FlxG.camera.bounds.make(20*24, 20*1, 20*34, 20*21);
		});
	}
	}
	super.update();
}



}