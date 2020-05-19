package gameObjects;

import com.gEngine.helper.Screen;
import com.gEngine.GEngine;
import GlobalGameData.GGD;
import com.framework.utils.Input;
import com.framework.utils.XboxJoystick;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.framework.utils.Entity;

class Player extends Entity {
	public static var PLAYER_Y = 0.80;
	static var PLAYER_SPEED = 400;

	var direction:FastVector2 = new FastVector2(0, 0);
	var display:Sprite;
	var levitationX:Float = 1;
	var levitationY:Float = 1;

	public var collision:CollisionBox;
	public var x(get, null):Float = 0;
	public var y(get, null):Float = 0;
	public var width(get, null):Float = 0;
	public var height(get, null):Float = 0;
	public var gun:Gun;

	public function new(X:Float = 0, Y:Float = 0, layer:Layer) {
		super();
		direction = new FastVector2(0, 1);
		display = new Sprite("ship");
		collision = new CollisionBox();
		gun = new Gun();
		setCollisions(X, Y);
		setDisplay();
		layer.addChild(display);
		addChild(gun);
	}

	override function update(dt:Float):Void {
		super.update(dt);
		collision.update(dt);
		levitation();
		if (collision.x > GEngine.i.width)
			collision.x = -collision.width;
		if (collision.x + collision.width < 0)
			collision.x = GEngine.i.width;
	}

	inline function levitation() {
		display.rotation += 0.002 * levitationX;
		collision.y += 0.12 * levitationY;
		if (display.rotation > 0.03 || display.rotation < -0.02) {
			levitationX *= -1;
		}
		if (collision.y > ((Screen.getHeight() * PLAYER_Y) + 3) || collision.y < ((Screen.getHeight() * PLAYER_Y) - 4)) {
			levitationY *= -1;
		}
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
	}

	public function get_x():Float {
		return collision.x + collision.width * 0.5;
	}

	public function get_y():Float {
		return collision.y + collision.height;
	}

	public function get_width():Float {
		return collision.width;
	}

	public function get_height():Float {
		return collision.height;
	}

	public function onButtonChange(id:Int, value:Float) {
		if (id == XboxJoystick.LEFT_DPAD) {
			if (value == 1) {
				collision.accelerationX = -PLAYER_SPEED * 4;
				display.scaleX = -Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX < 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.RIGHT_DPAD) {
			if (value == 1) {
				collision.accelerationX = PLAYER_SPEED * 4;
				display.scaleX = Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX > 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.A && !Input.i.isKeyCodeReleased(Space)) {
			gun.shoot(x - 3, y - 95, direction.x, -direction.y);
		}
	}

	public function onAxisChange(id:Int, value:Float) {}

	inline function setCollisions(X:Float, Y:Float) {
		collision.width = display.width() * 0.8;
		collision.height = display.height() * 0.8;
		collision.x = X;
		collision.y = Y;
		collision.maxVelocityX = 700;
		collision.dragX = 0.91;
		collision.userData = this;
	}

	inline function setDisplay() {
		display.offsetX = -38;
		display.offsetY = -10;
		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height();
	};
}
