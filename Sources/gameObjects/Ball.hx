package gameObjects;

import kha.audio1.Audio;
import kha.Assets;
import kha.Sound;
import kha.audio1.AudioChannel;
import js.lib.Math;
import com.gEngine.helper.Screen;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Ball extends Entity {
	private static inline var GROUND_LIMIT = 0.90;
	private static inline var GRAVITY:Float = 150;

	public var recentlyExploded:Bool = true;

	var display:Sprite;
	var collision:CollisionBox;
	var collisionGroup:CollisionGroup;
	var screenWidth:Int = 0;
	var screenHeight:Int = 0;
	var velocity:FastVector2;
	var reverseBall:Bool = true;
	var rotationMovement:Float = 1;
	var timer:Float = 0;
	var radio = 0;
	var animation:Sprite;
	var explosionChannel:AudioChannel;
	var explosionPlayers:Sound;

	public function new(layer:Layer, collisions:CollisionGroup, X:Float = 0, Y:Float = 0, i:Int = 0) {
		super();
		animation = new Sprite("explosion");
		screenHeight = Screen.getHeight();
		screenWidth = Screen.getWidth();
		velocity = new FastVector2(150, 150);
		collisionGroup = collisions;
		display = new Sprite("ball");
		collision = new CollisionBox();
		setExplosion(X, Y);
		layer.addChild(animation);
		layer.addChild(display);
		display.pivotX = display.width() / 2;
		display.pivotY = display.height() / 2;
		reverseBall = i == 1;
		createBall(X, Y);
	}

	override public function update(dt:Float):Void {
		super.update(dt);
		setRecentlyExplode(dt);
		display.rotation += 0.020 * rotationMovement;
		setBallDirection(dt);
		ballMovement(dt);
		bordersControl();
		collision.update(dt);
	}

	override function render() {
		super.render();
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
	}

	public function explode():Void {
		animation.x = display.x;
		animation.y = display.y;
		animation.timeline.playAnimation("explode", false);
		explosionChannel = Audio.play(Assets.sounds.explosionPlayers);
		collision.removeFromParent();
		collisionGroup.remove(collision);
		display.removeFromParent();
	}

	public function get_x():Float {
		return collision.x + collision.width * 0.5;
	}

	public function get_y():Float {
		return collision.y + collision.height * 0.5;
	}

	inline function ballMovement(dt:Float) {
		velocity.y += GRAVITY * dt;
		collision.y += velocity.y * dt;
	}

	inline function bordersControl() {
		if (collision.x < 0 || collision.x + radio > screenWidth) {
			velocity.x *= -1;
			rotationMovement *= -1;
		}

		if (collision.y + radio > (screenHeight * GROUND_LIMIT) || collision.y < 0) {
			velocity.y *= -1;
		}
	}

	inline function setRecentlyExplode(dt:Float) {
		timer += dt;
		if (timer > 0.1)
			recentlyExploded = false;
	}

	inline function setBallDirection(dt:Float) {
		if (reverseBall)
			collision.x += velocity.x * dt * -1;
		else
			collision.x += velocity.x * dt;
	}

	inline function createBall(X:Float, Y:Float) {
		if (X != 0 && Y != 0)
			createSubBall(X, Y);
		else
			createBigBall();
	}

	private inline function createBigBall() {
		collisionGroup.add(collision);
		radio = 120;
		display.scaleX = display.scaleY = 0.5;
		collision.x = (screenHeight) * Math.random();
		collision.y = 0;
		display.offsetX = -130;
		display.offsetY = -65;
		collision.width = (display.width() * 0.5) - 17;
		collision.height = (display.height() * 0.5) - 15;
		collision.userData = this;
	}

	private function createSubBall(X:Float, Y:Float) {
		collisionGroup.add(collision);
		radio = 60;
		display.scaleX = display.scaleY = 0.25;
		collision.x = X;
		collision.y = Y;
		display.offsetX = -129;
		display.offsetY = -95;
		collision.width = (display.width() * 0.25) - 12;
		collision.height = (display.height() * 0.25) - 10;
		collision.userData = this;
	}

	inline function setExplosion(X:Float, Y:Float) {
		if (X == 0 && Y == 0)
			animation.scaleX = animation.scaleY = 1.5;
		animation.offsetX = -30;
		animation.offsetY = 0;
		animation.timeline.playAnimation("sleep");
	}
}
