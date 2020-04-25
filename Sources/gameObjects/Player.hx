package gameObjects;

import com.framework.utils.Input;
import kha.input.KeyCode;
import com.framework.utils.XboxJoystick;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.framework.utils.Entity;

class Player extends Entity {
	var maxSpeed = 200;

	public var gun:Gun;

	var direction:FastVector2;
	var display:Sprite;

	public var collision:CollisionBox;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var width(get, null):Float;
	public var height(get, null):Float;

	public function new(X:Float = 0, Y:Float = 0, layer:Layer) {
		super();
		direction = new FastVector2(0, 1);
		display = new Sprite("ship");
		collision = new CollisionBox();
		display.offsetX = -15;
		display.offsetY = -10;
		display.scaleX = display.scaleY = 1;

		collision.width = 10;
		collision.height = 30;
		collision.x = X;
		collision.y = Y;
		collision.maxVelocityX = 500;
		collision.dragX = 0.9;

		layer.addChild(display);

		gun = new Gun();
		addChild(gun);

		display.smooth = false;

		/*
				collision.width = display.width();
			collision.height = display.height() * 0.5;
			display.pivotX = display.width() * 0.5;
			display.offsetY = -display.height() * 0.5;

		 */
	}

	override function update(dt:Float):Void {
		super.update(dt);
		collision.update(dt);
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
				collision.accelerationX = -maxSpeed * 4;
				display.scaleX = -Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX < 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.RIGHT_DPAD) {
			if (value == 1) {
				collision.accelerationX = maxSpeed * 4;
				display.scaleX = Math.abs(display.scaleX);
			} else {
				if (collision.accelerationX > 0) {
					collision.accelerationX = 0;
				}
			}
		}
		if (id == XboxJoystick.A) {
			gun.shoot(x , y - height * 0.75, direction.x, -direction.y);
		}
	}

	public function onAxisChange(id:Int, value:Float) {}
}
