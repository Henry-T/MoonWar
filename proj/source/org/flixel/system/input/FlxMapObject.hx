package org.flixel.system.input;

/**
 * 输入映射
 * 
 * ...
 * @author Zaphod
 */

class FlxMapObject
{
	public var name:String;
	public var current:Int;
	public var last:Int;
	
	public function new(name:String, current:Int, last:Int)
	{
		this.name = name;
		this.current = current;
		this.last = last;
	}
}