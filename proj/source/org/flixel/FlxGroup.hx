package org.flixel;

import org.flixel.system.layer.Atlas;

/**
 * 用于更新和绘制一组FlxBasic的组织类
 * 注意：虽然FlxGroup扩展了FlxBasic，它并不会自动将自己加入全局碰撞树，而是仅仅加入它的成员。
 * 
 * This is an organizational class that can update and render a bunch of <code>FlxBasic</code>s.
 * NOTE: Although <code>FlxGroup</code> extends <code>FlxBasic</code>, it will not automatically
 * add itself to the global collisions quad tree, it will only add its members.
 */
class FlxGroup extends FlxTypedGroup<FlxBasic>
{
	/**
	 * Constructor
	 */
	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);
	}
}