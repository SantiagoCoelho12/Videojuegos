package states;

import kha.input.KeyCode;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import GlobalGameData.GGD;
import format.swf.Data.Sound;
import com.loading.basicResources.JoinAtlas;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.framework.utils.Random;
import com.gEngine.helper.Screen;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;
import gameObjects.Player;

class GameState extends State {
	var screenWidth:Int;
	var screenHeight:Int;
	var background:Sprite;
	var ship:Player;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;

	override function load(resources:Resources) {
		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		atlas.add(new ImageLoader("background"));
		atlas.add(new ImageLoader("ship"));
		atlas.add(new ImageLoader("ball"));
		atlas.add(new ImageLoader("bullet"));
		resources.add(atlas);
	}

	override function init() {
		loadBackground();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		ship = new Player(1024 / 2, 570, simulationLayer);
		addChild(ship);

		GGD.player = ship;
		GGD.simulationLayer = simulationLayer;
		GGD.camera = stage.defaultCamera();

		createTouchJoystick();
	}

	override function update(dt:Float) {
		super.update(dt);
	}

	override function render() {
		super.render();
	}

	inline function loadBackground() {
		var backgraundLayer = new Layer();
        background = new Sprite("background");
		backgraundLayer.addChild(background);
		stage.addChild(backgraundLayer);
	}

	function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.notify(ship.onAxisChange, ship.onButtonChange);

		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(ship.onAxisChange, ship.onButtonChange);
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
