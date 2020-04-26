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
		setCollisions(X,Y);	
		setDisplay();
		layer.addChild(display);
		gun = new Gun();
		addChild(gun);
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
		if (id == XboxJoystick.A && !Input.i.isKeyCodeReleased(Space)) {
			gun.shoot(x+23 , y - 115, direction.x, -direction.y);
		}
	}

	public function onAxisChange(id:Int, value:Float) {}

	inline function setCollisions(X:Float,Y:Float) {
		collision.width =64;
		collision.height = 57;
		collision.x = X;
		collision.y = Y;
		collision.maxVelocityX = 500;
		collision.dragX = 0.9;
		collision.userData = this;
	}

	inline function setDisplay() {
		display.pivotX = display.width() * 0.5;
		display.offsetX = -38;
		display.offsetY =-10;
		display.scaleX = display.scaleY = 1;
	}
}
