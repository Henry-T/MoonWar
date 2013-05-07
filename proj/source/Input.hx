package ;

import org.flixel.FlxG;
import org.flixel.system.input.FlxAnalog;
import org.flixel.system.input.FlxGamePad;
import org.flixel.FlxGroup;
import org.flixel.FlxButton;

class Input extends FlxGroup {
	public var analog:FlxAnalog;
	public var gamePad:FlxGamePad;

	// access key down state
	public var Left:Bool;
	public var Right:Bool;
	public var Up:Bool;
	public var Down:Bool;
	public var Jump:Bool;
	public var Shoot:Bool;
	public var Action:Bool;

	public var JustDown_Left:Bool;
	public var JustDown_Right:Bool;
	public var JustDown_Up:Bool;
	public var JustDown_Down:Bool;
	public var JustDown_Jump:Bool;
	public var JustDown_Shoot:Bool;
	public var JustDown_Action:Bool;

	public var JustUp_Left:Bool;
	public var JustUp_Right:Bool;
	public var JustUp_Up:Bool;
	public var JustUp_Down:Bool;
	public var JustUp_Jump:Bool;
	public var JustUp_Shoot:Bool;
	public var JustUp_Action:Bool;

	public var AnalogAngle:Float;
	public var AnalogPressed:Bool;
	public var AnalogJustPressed:Bool;
	public var AnalogJustReleased:Bool;

	public function new(){
		super();
		analog = new FlxAnalog(50, FlxG.height - 50);
		gamePad = new FlxGamePad(FlxGamePad.NONE, FlxGamePad.A_B);
		analog.visible = true;
		analog.visible = true;

		add(analog);
		add(gamePad);
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

		// Data from Input Source
		AnalogAngle = analog.getAngle();
		AnalogPressed = analog.pressed();
		AnalogJustPressed = analog.justPressed();
		AnalogJustReleased = analog.justReleased();

		// Clean Up Before Roundup
		Left = false;
		Right = false;
		Up = false;
		Down = false;
		Shoot = false;
		Jump = false;
		Action = false;

		JustDown_Left = false;
		JustDown_Right = false;
		JustDown_Up = false;
		JustDown_Down = false;
		JustDown_Shoot = false;
		JustDown_Jump = false;
		JustDown_Action = false;

		JustUp_Left = false;
		JustUp_Right = false;
		JustUp_Up = false;
		JustUp_Down = false;
		JustUp_Shoot = false;
		JustUp_Jump = false;
		JustUp_Action = false;

		// Roundup
		if(FlxG.keys.LEFT || (AnalogPressed&&(AnalogAngle<-120||AnalogAngle>120)))
			Left = true;
		if(FlxG.keys.RIGHT || (AnalogPressed&&(AnalogAngle<60&&AnalogAngle>-60)))
			Right = true;
		if(FlxG.keys.UP || (AnalogPressed&&(AnalogAngle<-30&&AnalogAngle>-120)))
			Up = true;
		if(FlxG.keys.DOWN || (AnalogPressed&&(AnalogAngle>30&&AnalogAngle<120)))
			Down = true;
		if(FlxG.keys.Z || gamePad.buttonB.status == FlxButton.PRESSED)
			Jump = true;	// NOTE FlxButton.PRESSED meas just pressed
		if(FlxG.keys.X || gamePad.buttonA.status == FlxButton.PRESSED)
			Shoot = true;
		if(FlxG.keys.SPACE || gamePad.buttonA.status == FlxButton.PRESSED)
			Action = true;

		if(FlxG.keys.justPressed("LEFT") || (AnalogJustPressed&&(AnalogAngle<-120||AnalogAngle>120)))
			JustDown_Left = true;
		if(FlxG.keys.justPressed("RIGHT") || (AnalogJustPressed&&(AnalogAngle<60&&AnalogAngle>-60)))
			JustDown_Right = true;
		if(FlxG.keys.justPressed("UP") || (AnalogJustPressed&&(AnalogAngle<-30&&AnalogAngle>-120)))
			JustDown_Up = true;
		if(FlxG.keys.justPressed("DOWN") || (AnalogJustPressed&&(AnalogAngle>30&&AnalogAngle<120)))
			JustDown_Down = true;
		if(FlxG.keys.justPressed("Z") || 
			(gamePad.buttonB.status == FlxButton.PRESSED&&
				(lastBtnBStatus==FlxButton.NORMAL||lastBtnBStatus==FlxButton.HIGHLIGHT)))
			JustDown_Jump = true;
		if(FlxG.keys.justPressed("X") || 
			(gamePad.buttonA.status == FlxButton.PRESSED&&
			(lastBtnAStatus==FlxButton.NORMAL||lastBtnAStatus==FlxButton.HIGHLIGHT)))
			JustDown_Shoot = true;
		if(FlxG.keys.justPressed("SPACE") || 
			(gamePad.buttonA.status == FlxButton.PRESSED&&
			(lastBtnAStatus==FlxButton.NORMAL||lastBtnAStatus==FlxButton.HIGHLIGHT)))
			JustDown_Action = true;


		if(FlxG.keys.justReleased("LEFT") || (AnalogJustReleased&&(AnalogAngle<-120||AnalogAngle>120)))
			JustUp_Left = true;
		if(FlxG.keys.justReleased("RIGHT") || (AnalogJustReleased&&(AnalogAngle<60&&AnalogAngle>-60)))
			JustUp_Right = true;
		if(FlxG.keys.justReleased("UP") || (AnalogJustReleased&&(AnalogAngle<-30&&AnalogAngle>-120)))
			JustUp_Up = true;
		if(FlxG.keys.justReleased("DOWN") || (AnalogJustReleased&&(AnalogAngle>30&&AnalogAngle<120)))
			JustUp_Down = true;
		if(FlxG.keys.justPressed("Z") ||
			(lastBtnBStatus == FlxButton.PRESSED&&
			(gamePad.buttonA.status==FlxButton.NORMAL||gamePad.buttonA.status==FlxButton.HIGHLIGHT)))
			JustUp_Jump = true;
		if(FlxG.keys.justPressed("X") ||
			(lastBtnAStatus == FlxButton.PRESSED&&
			(gamePad.buttonA.status==FlxButton.NORMAL||gamePad.buttonA.status==FlxButton.HIGHLIGHT)))
			JustUp_Shoot = true;
		if(FlxG.keys.justPressed("SPACE") ||
			(lastBtnAStatus == FlxButton.PRESSED&&
			(gamePad.buttonA.status==FlxButton.NORMAL||gamePad.buttonA.status==FlxButton.HIGHLIGHT)))
			JustUp_Action = true;

		// update other data for this class
		lastBtnAStatus = gamePad.buttonA.status;
		lastBtnBStatus = gamePad.buttonB.status;

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
}