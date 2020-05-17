package gameObjects;

import js.lib.Math;
import com.gEngine.helper.Screen;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import GlobalGameData.GGD;

class Ball extends Entity {
	private static inline var RADIO = 120;
	private static inline var GROUND_LIMIT = 80;

	var display:Sprite;
	var collision:CollisionBox;
	var collisionGroup:CollisionGroup;
	var screenWidth:Int = 0;
	var screenHeight:Int = 0;
	var velocity:FastVector2;
	var reverseBall:Bool = true;

	public var recentlyExploted:Bool = true;

	var timer:Float = 0;

	private static inline var gravity:Float = 200;

	public function new(layer:Layer, collisions:CollisionGroup, X:Float = 0, Y:Float = 0, i:Int = 0) {
		super();
		screenHeight = Screen.getHeight();
		screenWidth = Screen.getWidth();
		velocity = new FastVector2(150, 150);
		collisionGroup = collisions;
		display = new Sprite("ball");
		collision = new CollisionBox();
		layer.addChild(display);
		display.pivotX = display.width() / 2;
		display.pivotY = display.height() / 2;
		if (i == 1)
			reverseBall = true;
		else
			reverseBall = false;
		if (X != 0 && Y != 0) {
			createSubBall(X, Y);
		} else {
			createBall();
		}
	}

	override public function update(dt:Float):Void {
		super.update(dt);
		timer += dt;
		if (timer > 0.1)
			recentlyExploted = false;
		display.rotation += 0.020;
		if (reverseBall)
			collision.x += velocity.x * dt * -1;
		else
			collision.x += velocity.x * dt;

		velocity.y += gravity * dt;
		collision.y += velocity.y * dt;
		if (collision.x < 0 || collision.x + RADIO > screenWidth) {
			velocity.x *= -1;
		}

		if (collision.y + RADIO > screenHeight - GROUND_LIMIT || collision.y < 0) {
			velocity.y *= -1;
		}

		collision.update(dt);
	}

	override function render() {
		super.render();
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
	}

	public function explode():Void {
		collision.removeFromParent();
		collisionGroup.remove(collision);
		display.removeFromParent();
	}

	private inline function createBall() {
		collisionGroup.add(collision);
		display.scaleX = display.scaleY = 0.5;
		collision.x = (screenHeight) * Math.random();
		collision.y = 0;
		display.offsetX = -130;
		display.offsetY = -65;
		collision.width = (display.width() * 0.5) - 3;
		collision.height = (display.height() * 0.5) - 3;
		collision.userData = this;
	}

	private function createSubBall(X:Float, Y:Float) {
		collisionGroup.add(collision);
		display.scaleX = display.scaleY = 0.25;
		collision.x = X;
		collision.y = Y;
		display.offsetX = -129;
		display.offsetY = -95;
		collision.width = (display.width() * 0.25);
		collision.height = (display.height() * 0.25);
		collision.userData = this;
	}

	public function get_x():Float {
		return collision.x + collision.width * 0.5;
	}

	public function get_y():Float {
		return collision.y + collision.height * 0.5;
	}
}
