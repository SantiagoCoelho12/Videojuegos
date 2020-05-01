package gameObjects;

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
	var screenWidth:Int;
	var screenHeight:Int;
	var velocity:FastVector2;
	var reverseBall:Bool;

	public function new(layer:Layer, collisions:CollisionGroup, X:Float = 0, Y:Float = 0, i:Int = 0) {
		super();
		screenHeight = Screen.getHeight();
		screenWidth = Screen.getWidth();
		velocity = new FastVector2(130, 130);
		collisionGroup = collisions;
		display = new Sprite("ball");
		collision = new CollisionBox();
		layer.addChild(display);
		setCollisionsAnddisplay();
		if (i == 1)
			reverseBall = true;
		else
			reverseBall = false;
		if (X != 0 && Y != 0) {
			createSubBall(X, Y);
		} else {
			randomPos();
		}
	}

	override public function update(dt:Float):Void {
		super.update(dt);
		if (reverseBall) collision.x += velocity.x * dt * -1;
	 	else collision.x += velocity.x * dt;
	
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

	private inline function setCollisionsAnddisplay() {
		display.scaleX = display.scaleY = 0.5;
		display.offsetX = -65;
		display.offsetY = 0;
		collision.width = (display.width() * 0.5) - 3;
		collision.height = (display.height() * 0.5) - 3;
		collision.userData = this;
	}

	private function createSubBall(X:Float, Y:Float) {
		/*
			collisionGroup.add(collision);
			collision.x = X * side;
			collision.y = Y;
			display.scaleX = display.scaleY = 0.25;
			collision.width = (display.width() * 0.25) - 3;
			collision.height = (display.height() * 0.25) - 3;
		 */
		 
		collisionGroup.add(collision);
		collision.x = X;
		collision.y = Y;
		display.scaleX = display.scaleY = 0.25;
		collision.width = (display.width() * 0.25);
		collision.height = (display.height() * 0.25);
		display.offsetX = -33;
	}

	public function get_x():Float {
		return collision.x + collision.width * 0.5;
	}

	public function get_y():Float {
		return collision.y + collision.height * 0.5;
	}

	private function randomPos() {
		collisionGroup.add(collision);
		var target:Player = GGD.player;
		var dirX = 1 - Math.random() * 2;
		var dirY = 1 - Math.random() * 2;
		if (dirX == 0 && dirY == 0) {
			dirX += 1;
		}
		var length = Math.sqrt(dirX * dirX + dirY * dirY);
		collision.x = target.x + 500 * dirX / length;
		collision.y = 0;
	}
}
