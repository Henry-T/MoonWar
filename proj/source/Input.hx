package ;

import org.flixel.FlxG;
import org.flixel.system.input.FlxAnalog;
import org.flixel.system.input.FlxGamePad;
import org.flixel.FlxGroup;
import org.flixel.FlxButton;


// Wrap up for all input situations and give a handy access to input for this game
class Input extends FlxGroup {
	public var analog:MyAnalog;
	public var gamePad:MyGamePad;

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
		analog = new MyAnalog(anaX, anaY);
		add(analog);
		
		gamePad = new MyGamePad();
		add(gamePad);

		gamePad.visible = false;
		analog.visible = false;
		#if !FLX_NO_MOUSE
		gamePad.visible = true;
		analog.visible = true;
		#end

		#if !FLX_NO_TOUCH
		gamePad.visible = true;
		analog.visible = true;
		#end
	}

	public function showControl(isShow:Bool){
		analog.visible = isShow;
		gamePad.visible = isShow;
	}

	public override function update(){
		super.update();
		
		// Input from Analog Pad
		//if(On){
		    // var lvl:Level = cast(FlxG.state, Level);
		    // if(lvl.analog.pressed()){
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
		keyboardZDown = false;
		keyboardXDown = false;
		keyboardSpaceDown = false;
		keyboardAnykeyDown = false;
		keyboardLeftJustDown = false;
		keyboardRightJustDown = false;
		keyboardUpJustDown = false;
		keyboardDownJustDown = false;
		keyboardZJustDown = false;
		keyboardXJustDown = false;
		keyboardSpaceJustDown = false;
		keyboardAnykeyJustDown = false;
		keyboardLeftJustUp = false;
		keyboardRightJustUp = false;
		keyboardUpJustUp = false;
		keyboardDownJustUp = false;
		keyboardZJustUp = false;
		keyboardXJustUp = false;
		keyboardSpaceJustUp = false;
		keyboardAnykeyJustUp = false;

		AnalogAngle = 0;
		AnalogPressed = false;
		AnalogJustPressed = false;
		AnalogJustReleased = false;

		// Data from Input Source
		AnalogAngle = analog.getAngle();
		AnalogPressed = analog.pressed();
		AnalogJustPressed = analog.justPressed();
		AnalogJustReleased = analog.justReleased();

		#if !FLX_NO_KEYBOARD
		keyboardLeftDown = FlxG.keys.LEFT;
		keyboardRightDown = FlxG.keys.RIGHT;
		keyboardUpDown = FlxG.keys.UP;
		keyboardDownDown = FlxG.keys.DOWN;
		keyboardZDown = FlxG.keys.Z;
		keyboardXDown = FlxG.keys.X;
		keyboardSpaceDown = FlxG.keys.SPACE;
		keyboardAnykeyDown = FlxG.keys.any();
		keyboardLeftJustDown = FlxG.keys.justPressed("LEFT");
		keyboardRightJustDown = FlxG.keys.justPressed("RIGHT");
		keyboardUpJustDown = FlxG.keys.justPressed("UP");
		keyboardDownJustDown = FlxG.keys.justPressed("DOWN");
		keyboardZJustDown = FlxG.keys.justPressed("Z");
		keyboardXJustDown = FlxG.keys.justPressed("X");
		keyboardSpaceJustDown = FlxG.keys.justPressed("SPACE");
		keyboardAnykeyJustDown = FlxG.keys.any() && !lastKeyboardAnykeyDown;
		keyboardLeftJustUp = FlxG.keys.justReleased("LEFT");
		keyboardRightJustUp = FlxG.keys.justReleased("RIGHT");
		keyboardUpJustUp = FlxG.keys.justReleased("UP");
		keyboardDownJustUp = FlxG.keys.justReleased("DOWN");
		keyboardZJustUp = FlxG.keys.justReleased("Z");
		keyboardXJustUp = FlxG.keys.justReleased("X");
		keyboardSpaceJustUp = FlxG.keys.justReleased("SPACE");
		keyboardAnykeyJustUp = !FlxG.keys.any() && lastKeyboardAnykeyDown;
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
		if(keyboardZDown || gamePad.buttonB.status == FlxButton.PRESSED)
			Jump = true;
		if(keyboardXDown || gamePad.buttonA.status == FlxButton.PRESSED)
			Shoot = true;
		if(keyboardXDown || gamePad.buttonA.status == FlxButton.PRESSED)
			Action = true;
		if(keyboardAnykeyDown || AnalogPressed || gamePad.buttonA.status==FlxButton.PRESSED || gamePad.buttonB.status==FlxButton.PRESSED)
			Anykey = true;

		if(keyboardLeftJustDown || (AnalogJustPressed&&(AnalogAngle<-120||AnalogAngle>120)))
			JustDown_Left = true;
		if(keyboardRightJustDown || (AnalogJustPressed&&(AnalogAngle<60&&AnalogAngle>-60)))
			JustDown_Right = true;
		if(keyboardUpJustDown || (AnalogJustPressed&&(AnalogAngle<-30&&AnalogAngle>-150)))
			JustDown_Up = true;
		if(keyboardDownJustDown || (AnalogJustPressed&&(AnalogAngle>30&&AnalogAngle<150)))
			JustDown_Down = true;
		if(keyboardZJustDown || 
			(gamePad.buttonB.status == FlxButton.PRESSED&&
				(lastBtnBStatus==FlxButton.NORMAL||lastBtnBStatus==FlxButton.HIGHLIGHT)))
			JustDown_Jump = true;
		if(keyboardXJustDown || 
			(gamePad.buttonA.status == FlxButton.PRESSED&&
			(lastBtnAStatus==FlxButton.NORMAL||lastBtnAStatus==FlxButton.HIGHLIGHT)))
			JustDown_Shoot = true;
		JustDown_Action = JustDown_Shoot;
		if(keyboardAnykeyJustDown||AnalogJustPressed||
			((gamePad.buttonA.status == FlxButton.PRESSED&&(lastBtnAStatus==FlxButton.NORMAL||lastBtnAStatus==FlxButton.HIGHLIGHT)))||
			((gamePad.buttonB.status == FlxButton.PRESSED&&(lastBtnBStatus==FlxButton.NORMAL||lastBtnBStatus==FlxButton.HIGHLIGHT))))
			JustDown_Anykey = true;

		if(keyboardLeftJustUp || (AnalogJustReleased&&(AnalogAngle<-120||AnalogAngle>120)))
			JustUp_Left = true;
		if(keyboardRightJustUp || (AnalogJustReleased&&(AnalogAngle<60&&AnalogAngle>-60)))
			JustUp_Right = true;
		if(keyboardUpJustUp || (AnalogJustReleased&&(AnalogAngle<-30&&AnalogAngle>-150)))
			JustUp_Up = true;
		if(keyboardDownJustUp || (AnalogJustReleased&&(AnalogAngle>30&&AnalogAngle<150)))
			JustUp_Down = true;
		if(keyboardZJustUp ||
			(lastBtnBStatus == FlxButton.PRESSED&&
			(gamePad.buttonB.status==FlxButton.NORMAL||gamePad.buttonB.status==FlxButton.HIGHLIGHT)))
			JustUp_Jump = true;
		if(keyboardXJustUp ||
			(lastBtnAStatus == FlxButton.PRESSED&&
			(gamePad.buttonA.status==FlxButton.NORMAL||gamePad.buttonA.status==FlxButton.HIGHLIGHT)))
			JustUp_Shoot = true;
		JustUp_Action = JustUp_Shoot;
		if(keyboardAnykeyJustUp||AnalogJustReleased||
			((lastBtnAStatus == FlxButton.PRESSED&&(gamePad.buttonA.status==FlxButton.NORMAL||gamePad.buttonA.status==FlxButton.HIGHLIGHT)))||
			((lastBtnBStatus == FlxButton.PRESSED&&(gamePad.buttonB.status==FlxButton.NORMAL||gamePad.buttonB.status==FlxButton.HIGHLIGHT))))
			JustUp_Anykey = true;

		// update other data for this class
		lastBtnAStatus = gamePad.buttonA.status;
		lastBtnBStatus = gamePad.buttonB.status;
		#if !FLX_NO_KEYBOARD
		lastKeyboardAnykeyDown = FlxG.keys.any();
		#end

	    // var touches:Array<FlxTouch> = FlxG.touchManager.touches;
	    // var touch:FlxTouch;
	 
	    // for(touch in touches)
	    // {
	    //     if (touch.pressed())
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

	    //     if(touch.justPressed())
	    //     {

	    //     }
	    // }
	}

	private var lastBtnAStatus:Int;
	private var lastBtnBStatus:Int;

	private var lastKeyboardAnykeyDown:Bool;

	private var keyboardLeftDown:Bool;
	private var keyboardRightDown:Bool;
	private var keyboardUpDown:Bool;
	private var keyboardDownDown:Bool;
	private var keyboardZDown:Bool;
	private var keyboardXDown:Bool;
	private var keyboardSpaceDown:Bool;
	private var keyboardAnykeyDown:Bool;

	private var keyboardLeftJustDown:Bool;
	private var keyboardRightJustDown:Bool;
	private var keyboardUpJustDown:Bool;
	private var keyboardDownJustDown:Bool;
	private var keyboardZJustDown:Bool;
	private var keyboardXJustDown:Bool;
	private var keyboardSpaceJustDown:Bool;
	private var keyboardAnykeyJustDown:Bool;

	private var keyboardLeftJustUp:Bool;
	private var keyboardRightJustUp:Bool;
	private var keyboardUpJustUp:Bool;
	private var keyboardDownJustUp:Bool;
	private var keyboardZJustUp:Bool;
	private var keyboardXJustUp:Bool;
	private var keyboardSpaceJustUp:Bool;
	private var keyboardAnykeyJustUp:Bool;
}