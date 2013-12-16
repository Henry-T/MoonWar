package ;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.util.FlxRect;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import org.flixel.tmx.TmxObjectGroup;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.motion.LinearMotion;
import flixel.addons.display.FlxBackdrop;

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
	public var camPos1:FlxPoint;
	public var fightRect:FlxRect;

	public function new() 
	{
		super();
		tileXML = openfl.Assets.getText("assets/dat/level8.tmx");
		
		lines1 = [
			new Line(0,"Dr.Cube:It's too bad, RageMetal take control of the energy."), 
			new Line(2,"Finally, I will bring you ... doom!"), 
			new Line(1,"Then I have to bury you here now.")
		];

		lines2 = [
			new Line(1, "RageMetal is terminated.."),
			new Line(0, "Yes, that is a tough one."),
			new Line(0, "We are in peace now."),
			new Line(1, "Let's hope nothing like this happen again."),
		];
	}

	override public function create():Void 
	{
		super.create();
		
		GameStatic.CurLvl = 7;
		
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
				var gate:FlxSprite = new FlxSprite(o.x, o.y);
				gate.makeGraphic(o.width, o.height, 0xffaaaaaa);
				gate.immovable = true;
				gate.y -= 100;
				gates.add(gate);
			}
			else if(o.name == "cam1"){
				camPos1 = new FlxPoint(o.x + o.width * 0.5, o.y + o.height * 0.5);
			}
			else if(o.name == "fightArea"){
				fightRect = new FlxRect(o.x, o.y, o.width, o.height);
			}
		}
		
		bInLift = new FlxSprite(start.x - 10, start.y - 6, "assets/img/bInLift_r.png");
		tile.follow();
		
		bd1 = new FlxBackdrop("assets/img/metal.png", 0.2, 0.2, true, true);

		
		boss3 = new Boss3(bossPos.x, bossPos.y);
		
		// trigger path to Boss room
		trigger = new FlxSprite(triggerRect.x, triggerRect.y);
		trigger.makeGraphic(Std.int(triggerRect.width), Std.int(triggerRect.height), 0x33224488); 
		
		add(trigger);
		AddAll();
		
		// initial scene
		bot.On = false;
		bot.facing = FlxObject.RIGHT;
		bInLift.velocity.y = Level.liftSpeed;
		downing = true;
		righting = false;
		triggered = false;
		FlxG.camera.follow(bot);
		FlxG.camera.flash(0xff000000, 2);
		ResUtil.playGame1();
		endTalkHappened = false;
		ShowSceneName("8 - MOON CORE");
	}

	private var endTalkHappened:Bool;
	override public function update():Void 
	{
		super.update();
		if((confirm.visible&&confirm.isModel)
		 || FlxG.paused || endPause)	return;

		FlxG.overlap(missles, bullets, function(m:FlxObject, b:FlxObject){m.hurt(1); b.kill();});

		FlxG.overlap(boss3Buls, bot, function(bul:FlxObject, b:FlxObject){bul.kill(); b.hurt(15);});

		FlxG.overlap(boss3, bot, function(boss:FlxObject, bot:FlxObject){bot.hurt(20);});

		// gate
		FlxG.collide(bot, gates);
		FlxG.overlap(gates, missles, function(g:FlxObject, msl:FlxObject):Void { msl.kill(); } );
		FlxG.overlap(gates, bouncers, function(g:FlxObject, bcr:FlxObject):Void { cast(bcr,Bouncer).bounceCount--; } );
		FlxG.overlap(gates, bigGunBuls, function(g:FlxObject, bgb:FlxObject):Void { bgb.kill(); } );
		
		FlxG.collide(bouncers, tile, function(bcr:FlxObject, tile:FlxObject) { cast(bcr,Bouncer).bounceCount--; } );
		FlxG.collide(bigGunBuls, tile, function(bgb:FlxObject, tile:FlxObject) { bgb.kill(); } );
		FlxG.collide(missles, tile, function(msl:FlxObject, tile:FlxObject):Void {msl.kill();});
		
		FlxG.overlap(bot, missles, function(bot:FlxObject, msl:FlxObject):Void { msl.kill(); bot.hurt(30);} );
		FlxG.overlap(bot, bouncers, function(bot:FlxObject, bcr:FlxObject):Void { bcr.kill(); bot.hurt(20);} );
		FlxG.overlap(bot, bigGunBuls, function(bot:FlxObject, bgb:FlxObject):Void {bgb.kill(); bot.hurt(20);} );
		
		FlxG.collide(tile, boss3);		// Boss3 with Tile
		
		// bul on boss
		FlxG.overlap(bullets, boss3, function(bul:FlxObject, boss3:FlxObject):Void { 
			bul.kill();
			if(!cast(boss3, Boss3).immu)
				boss3.hurt(1);
		});
		
		// boss life gui
		var v:Float = boss3.health / Boss3.maxLife / 10 * 310;
		if(v<0)v = 0;
			hbH.scale = new FlxPoint(v, 1);
		
		// boss killed
		if (!isEnd && !boss3.alive && !endTalkHappened){
			endTalkHappened = true;
			FlxTimer.start(0.5, function(t:FlxTimer){
				lineMgr.Start(lines2, function(){
					EndLevel(true);
				});
			});
		}
		
		// Level Start
		if (downing && bInLift.y > door1Up.y - 20)
		{
			bInLift.velocity.y = 0;
			bot.EnableG(true);
			door1Up.Unlock();
		}
		
		if (door1Up.open && downing)
		{
			downing = false;
			bot.On = true;
			hpBar.visible = true;
		}
		
		// trigger
		if (!triggered && FlxG.overlap(bot, trigger))
		{
			triggered = true;
			righting = true;
			FlxG.camera.follow(null);
			TweenCamera(camPos1.x, camPos1.y, 3.5, false, function(){
				FlxG.camera.bounds.set(fightRect.x, fightRect.y, fightRect.width, fightRect.height);
			});

			var gate:FlxSprite = cast(gates.members[0], FlxSprite);
			FlxTween.linearMotion(gate, gate.x, gate.y, gate.x, gate.y+100, 2, true, {type:FlxTween.ONESHOT, ease:FlxEase.quadInOut});
		}
		if (righting)
		{
			bot.velocity.x = 100;
			bot.On = false;
			if (!FlxG.overlap(bot, trigger))
			{
				righting = false;
				bot.velocity.x = 0;
				FlxTimer.start(1, function(t:FlxTimer):Void {
					lineMgr.Start(lines1, function(){
						//cast(gates.members[0], FlxSprite).y  += 100;
						gates.members[0].visible = true;
						boss3.immu = false;
						boss3.ChangeState("launching");
						hbL.visible = true;
						hbR.visible = true;
						hbBg.visible = true;
						hbH.visible = true;
						ResUtil.playGame1();
						FlxG.camera.follow(bot, 0, null, 5);
						bot.On = true;
						FlxG.camera.follow(bot, FlxCamera.STYLE_LOCKON, 0.5);
					});
				});
			}
		}
	}
}