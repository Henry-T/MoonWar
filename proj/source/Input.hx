package ;

import flixel.FlxG;
import flixel.ui.FlxAnalog;
import flixel.ui.FlxVirtualPad;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;


// Wrap up for all input situations and give a handy access to input for this game
class Input extends FlxGroup {
	#if !FLX_NO_TOUCH
	public var analog:MyAnalog;
	public var gamePad:MyGamePad;
	#end

	// access key down state
	public var Left:Bool;
	public var Right:Bool;
	public var Up:Bool;
	public var Down:Bool;
	public var Jump:Bool;
	public var Shoot:Bool;
	public var Action:Bool;
	public var Anykey:Bool;

	public var JustDown_Left:Bool;
	public var JustDown_Right:Bool;
	public var JustDown_Up:Bool;
	public var JustDown_Down:Bool;
	public var JustDown_Jump:Bool;
	public var JustDown_Shoot:Bool;
	public var JustDown_Action:Bool;
	public var JustDown_Anykey:Bool;

	public var JustUp_Left:Bool;
	public var JustUp_Right:Bool;
	public var JustUp_Up:Bool;
	public var JustUp_Down:Bool;
	public var JustUp_Jump:Bool;
	public var JustUp_Shoot:Bool;
	public var JustUp_Action:Bool;
	public var JustUp_Anykey:Bool;

	// Analog specific
	public var AnalogAngle:Float;
	public var AnalogPressed:Bool;
	public var AnalogJustPressed:Bool;
	public var AnalogJustReleased:Bool;

	public function new(){
		super();
		var anaX:Int=0;
		var anaY:Int=0;
		if(GameStatic.screenDensity==GameStatic.Density_S){
			anaX = 50;
			anaY = FlxG.height - 50;
		}
		else {
			anaX = 100;
			anaY = FlxG.height - 100;
		}
		#if !FLX_NO_TOUCH
		analog = new MyAnalog(anaX, anaY);
		add(analog);
		
		gamePad = new MyGamePad();
		add(gamePad);
		#end
	}

	public function showControl(isShow:Bool) {
		#if !FLX_NO_TOUCH
		analog.visible = isShow;
		gamePad.visible = isShow;
		#end
	}

	public override function update(){
		super.update();
		
		// Input from Analog Pad
		//if(On){
		    // var lvl:Level = cast(FlxG.state, Level);
		    // if(lvl.analog.pressed){
		    // 	var anaAgl:Float = lvl.analog.getAngle();
		    // 	trace(anaAgl);
		    // 	if(anaAgl > -90 && anaAgl < 90)
		    // 		inRIGHT = true;
		    // 	else 
		    // 		inLEFT = true;
		    // }
		//}

		// Clean Up Raw Input From Specific Input Hardware
		keyboardLeftDown = false;
		keyboardRightDown = false;
		keyboardUpDown = false;
		keyboardDownDown = false;
		keyboardXDown = false;
		keyboardCDown = false;
		keyboardSpaceDown = false;
		keyboardAnykeyDown = false;
		keyboardLeftJustDown = false;
		keyboardRightJustDown = false;
		keyboardUpJustDown = false;
		keyboardDownJustDown = false;
		keyboardXJustDown = false;
		keyboardCJustDown = false;
		keyboardSpaceJustDown = false;
		keyboardAnykeyJustDown = false;
		keyboardLeftJustUp = false;
		keyboardRightJustUp = false;
		keyboardUpJustUp = false;
		keyboardDownJustUp = false;
		keyboardXJustUp = false;
		keyboardCJustUp = false;
		keyboardSpaceJustUp = false;
		keyboardAnykeyJustUp = false;

		AnalogAngle = 0;
		AnalogPressed = false;
		AnalogJustPressed = false;
		AnalogJustReleased = false;

		// Data from Input Source
		#if !FLX_NO_TOUCH
		AnalogAngle = analog.getAngle();
		AnalogPressed = analog.pressed;
		AnalogJustPressed = analog.justPressed;
		AnalogJustReleased = analog.justReleased;
		#end

		#if !FLX_NO_KEYBOARD
		keyboardLeftDown = FlxG.keyboard.pressed("LEFT");
		keyboardRightDown = FlxG.keyboard.pressed("RIGHT");
		keyboardUpDown = FlxG.keyboard.pressed("UP");
		keyboardDownDown = FlxG.keyboard.pressed("DOWN");
		keyboardXDown = FlxG.keyboard.pressed("X");
		keyboardCDown = FlxG.keyboard.pressed("C");
		keyboardSpaceDown = FlxG.keyboard.pressed("SPACE");
		keyboardAnykeyDown = FlxG.keyboard.pressed.ANY;
		keyboardLeftJustDown = FlxG.keyboard.justPressed("LEFT");
		keyboardRightJustDown = FlxG.keyboard.justPressed("RIGHT");
		keyboardUpJustDown = FlxG.keyboard.justPressed("UP");
		keyboardDownJustDown = FlxG.keyboard.justPressed("DOWN");
		keyboardXJustDown = FlxG.keyboard.justPressed("X");
		keyboardCJustDown = FlxG.keyboard.justPressed("C");
		keyboardSpaceJustDown = FlxG.keyboard.justPressed("SPACE");
		keyboardAnykeyJustDown = FlxG.keyboard.pressed.ANY && !lastKeyboardAnykeyDown;
		keyboardLeftJustUp = FlxG.keyboard.justPressed("LEFT");
		keyboardRightJustUp = FlxG.keyboard.justPressed("RIGHT");
		keyboardUpJustUp = FlxG.keyboard.justPressed("UP");
		keyboardDownJustUp = FlxG.keyboard.justPressed("DOWN");
		keyboardXJustUp = FlxG.keyboard.justPressed("X");
		keyboardCJustUp = FlxG.keyboard.justPressed("C");
		keyboardSpaceJustUp = FlxG.keyboard.justPressed("SPACE");
		keyboardAnykeyJustUp = !FlxG.keyboard.pressed.ANY && lastKeyboardAnykeyDown;
		#end

		// Clean Up Before Roundup
		Left = false;
		Right = false;
		Up = false;
		Down = false;
		Shoot = false;
		Jump = false;
		Action = false;
		Anykey = false;

		JustDown_Left = false;
		JustDown_Right = false;
		JustDown_Up = false;
		JustDown_Down = false;
		JustDown_Shoot = false;
		JustDown_Jump = false;
		JustDown_Action = false;
		JustDown_Anykey = false;

		JustUp_Left = false;
		JustUp_Right = false;
		JustUp_Up = false;
		JustUp_Down = false;
		JustUp_Shoot = false;
		JustUp_Jump = false;
		JustUp_Action = false;
		JustUp_Anykey = false;

		// Roundup
		if(keyboardLeftDown || (AnalogPressed&&(AnalogAngle<-120||AnalogAngle>120)))
			Left = true;
		if(keyboardRightDown || (AnalogPressed&&(AnalogAngle<60&&AnalogAngle>-60)))
			Right = true;
		if(keyboardUpDown || (AnalogPressed&&(AnalogAngle<-30&&AnalogAngle>-150)))
			Up = true;
		if(keyboardDownDown || (AnalogPressed&&(AnalogAngle>30&&AnalogAngle<150)))
			Down = true;
		if (keyboardXDown 
			#if !FLX_NO_TOUCH
			|| gamePad.buttonB.status == FlxButton.PRESSED
			#end
			)
			Jump = true;
		if (keyboardCDown
			#if !FLX_NO_TOUCH
			|| gamePad.buttonA.status == FlxButton.PRESSED
			#end
			)
			Shoot = true;
		if (keyboardCDown
			#if !FLX_NO_TOUCH
			|| gamePad.buttonA.status == FlxButton.PRESSED
			#end
			)
			Action = true;
		if (keyboardAnykeyDown || AnalogPressed 
			#if !FLX_NO_TOUCH
			|| gamePad.buttonA.status == FlxButton.PRESSED || gamePad.buttonB.status == FlxButton.PRESSED
			#end
			)
			Anykey = true;

		if(keyboardLeftJustDown || (AnalogJustPressed&&(AnalogAngle<-120||AnalogAngle>120)))
			JustDown_Left = true;
		if(keyboardRightJustDown || (AnalogJustPressed&&(AnalogAngle<60&&AnalogAngle>-60)))
			JustDown_Right = true;
		if(keyboardUpJustDown || (AnalogJustPressed&&(AnalogAngle<-30&&AnalogAngle>-150)))
			JustDown_Up = true;
		if(keyboardDownJustDown || (AnalogJustPressed&&(AnalogAngle>30&&AnalogAngle<150)))
			JustDown_Down = true;
		if (keyboardXJustDown 
			#if !FLX_NO_TOUCH
			|| (gamePad.buttonB.status == FlxButton.PRESSED&&
				(lastBtnBStatus == FlxButton.NORMAL || lastBtnBStatus == FlxButton.HIGHLIGHT))
			#end
			)
			JustDown_Jump = true;
		if (keyboardCJustDown 
			#if !FLX_NO_TOUCH
			|| (gamePad.buttonA.status == FlxButton.PRESSED&&
			(lastBtnAStatus == FlxButton.NORMAL || lastBtnAStatus == FlxButton.HIGHLIGHT))
			#end
			)
			JustDown_Shoot = true;
		JustDown_Action = JustDown_Shoot;
		if (keyboardAnykeyJustDown || AnalogJustPressed
			#if !FLX_NO_TOUCH
			||((gamePad.buttonA.status == FlxButton.PRESSED&&(lastBtnAStatus==FlxButton.NORMAL||lastBtnAStatus==FlxButton.HIGHLIGHT)))||
			((gamePad.buttonB.status == FlxButton.PRESSED && (lastBtnBStatus == FlxButton.NORMAL || lastBtnBStatus == FlxButton.HIGHLIGHT)))
			#end
			)
			JustDown_Anykey = true;

		if(keyboardLeftJustUp || (AnalogJustReleased&&(lastAnalogAngle<-120||lastAnalogAngle>120)))
			JustUp_Left = true;
		if(keyboardRightJustUp || (AnalogJustReleased&&(lastAnalogAngle<60&&lastAnalogAngle>-60)))
			JustUp_Right = true;
		if(keyboardUpJustUp || (AnalogJustReleased&&(lastAnalogAngle<-30&&lastAnalogAngle>-150)))
			JustUp_Up = true;
		if(keyboardDownJustUp || (AnalogJustReleased&&(lastAnalogAngle>30&&lastAnalogAngle<150)))
			JustUp_Down = true;
		if (keyboardXJustUp 
			#if !FLX_NO_TOUCH
			||(lastBtnBStatus == FlxButton.PRESSED&&
			(gamePad.buttonB.status == FlxButton.NORMAL || gamePad.buttonB.status == FlxButton.HIGHLIGHT))
			#end
			)
			JustUp_Jump = true;
		if (keyboardCJustUp 
			#if !FLX_NO_TOUCH
			||(lastBtnAStatus == FlxButton.PRESSED&&
			(gamePad.buttonA.status == FlxButton.NORMAL || gamePad.buttonA.status == FlxButton.HIGHLIGHT))
			#end
			)
			JustUp_Shoot = true;
		JustUp_Action = JustUp_Shoot;
		if (keyboardAnykeyJustUp || AnalogJustReleased
			#if !FLX_NO_TOUCH
			||((lastBtnAStatus == FlxButton.PRESSED&&(gamePad.buttonA.status==FlxButton.NORMAL||gamePad.buttonA.status==FlxButton.HIGHLIGHT)))||
			((lastBtnBStatus == FlxButton.PRESSED && (gamePad.buttonB.status == FlxButton.NORMAL || gamePad.buttonB.status == FlxButton.HIGHLIGHT)))
			#end
			)
			JustUp_Anykey = true;

		// update other data for this class
		#if !FLX_NO_TOUCH
		lastBtnAStatus = gamePad.buttonA.status;
		lastBtnBStatus = gamePad.buttonB.status;
		#end
		#if !FLX_NO_KEYBOARD
		lastKeyboardAnykeyDown = FlxG.keyboard.pressed.ANY;
		#end
		lastAnalogAngle = AnalogAngle;

	    // var touches:Array<FlxTouch> = FlxG.touches.list;
	    // var touch:FlxTouch;
	 
	    // for(touch in touches)
	    // {
	    //     if (touch.pressed)
	    //     {
	    //         var px:Int = touch.screenX;
	    //         var py:Int = touch.screenY;
	    //         var worldX:Float = touch.getWorldPosition().x;
	    //         var worldY:Float = touch.getWorldPosition().y;

	    //         trace("screen: " + px + "-" + py);
	    //         trace(" world: " + Std.int(worldX) + "-" + Std.int(worldY));
	    //         var lvl:Level = cast(FlxG.state, Level);
	    //         var r:FlxRect = lvl.btnRight._rect;
	    //         if(r.left < px && px < r.right && r.top < px && px < r.bottom)
	    //        		inRIGHT = true;
	    //     }

	    //     if(touch.justPressed)
	    //     {

	    //     }
	    // }
	}

	private var lastBtnAStatus:Int;
	private var lastBtnBStatus:Int;

	private var lastKeyboardAnykeyDown:Bool;

	private var lastAnalogAngle:Float;

	private var keyboardLeftDown:Bool;
	private var keyboardRightDown:Bool;
	private var keyboardUpDown:Bool;
	private var keyboardDownDown:Bool;
	private var keyboardXDown:Bool;
	private var keyboardCDown:Bool;
	private var keyboardSpaceDown:Bool;
	private var keyboardAnykeyDown:Bool;

	private var keyboardLeftJustDown:Bool;
	private var keyboardRightJustDown:Bool;
	private var keyboardUpJustDown:Bool;
	private var keyboardDownJustDown:Bool;
	private var keyboardXJustDown:Bool;
	private var keyboardCJustDown:Bool;
	private var keyboardSpaceJustDown:Bool;
	private var keyboardAnykeyJustDown:Bool;

	private var keyboardLeftJustUp:Bool;
	private var keyboardRightJustUp:Bool;
	private var keyboardUpJustUp:Bool;
	private var keyboardDownJustUp:Bool;
	private var keyboardXJustUp:Bool;
	private var keyboardCJustUp:Bool;
	private var keyboardSpaceJustUp:Bool;
	private var keyboardAnykeyJustUp:Bool;
}