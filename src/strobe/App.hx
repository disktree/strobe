package strobe;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.InputElement;
import js.html.Element;
import om.Time;

class App {

	static var light : Element;
	static var controls : Element;
	
	static var colorBackground = '#000';
    static var colorFlash = '#fff';
    static var flashInterval = 100;
	static var flashDuration = 33;

	static var flashing = false;
    static var timeStart : Float;
    static var lastTimeFlash : Float;

	static function update( time : Float ) {

        window.requestAnimationFrame( update );

		var elapsed = Std.int( time - lastTimeFlash );

		if( flashing ) {
			if( elapsed >= flashDuration ) {
				light.style.backgroundColor = colorBackground;
                flashing = false;
				lastTimeFlash = time;
            }
		} else {
			if( elapsed >= flashInterval ) {
				light.style.backgroundColor = colorFlash;
                flashing = true;
				lastTimeFlash = time;
            }
		}
	}

	static function main() {

		light = document.getElementById('light');
		controls = document.getElementById('controls');

		var backgroundColorElement : InputElement = cast controls.querySelector( 'input[name="background-color"]' );
		var intervalElement : InputElement = cast controls.querySelector( 'input[name="interval"]' );
		var durationElement : InputElement = cast controls.querySelector( 'input[name="duration"]' );
		var transitionElement : InputElement = cast controls.querySelector( 'input[name="transition"]' );
		var flashColorElement : InputElement = cast controls.querySelector( 'input[name="flash-color"]' );
		
		backgroundColorElement.oninput = e -> colorBackground = e.target.value;
		flashColorElement.oninput = e -> colorFlash = e.target.value;

		intervalElement.oninput = e -> {
			var v = Std.parseInt( e.target.value );
			durationElement.max = Std.string(v);
			flashInterval = v;
		}

		durationElement.oninput = e -> {
			var v = Std.parseInt( e.target.value );
			flashDuration = v;
		}
		
		transitionElement.oninput = e -> {
			var v = Std.parseInt( e.target.value ) / 1000;
			light.style.transition = 'background-color '+v+'s';
		}
		
		window.onkeydown = function(e) {
			trace(e.keyCode);
			switch e.keyCode {
				case 89: //y
					flashInterval = Std.int( Math.min( (flashInterval+10), 1000 ) );
				case 88: //x
					flashInterval = Std.int( Math.max( (flashInterval-10), 17 ) );
				case 78: //n
					flashDuration = Std.int( Math.max( (flashDuration-10), 17 ) );
				case 77: //m
					flashDuration = Std.int( Math.min( (flashDuration+10), 1000 ) );
				case 32: // space
					//
			}
		}
		
		timeStart = lastTimeFlash = Time.now();
		window.requestAnimationFrame( update );

		document.onmouseenter = e -> controls.classList.remove('hidden');
		document.onmouseleave = e -> controls.classList.add('hidden');

		/*
		window.onmousedown = function(e) {
			//trace(e);
		}
		window.onmousemove = function(e) {
			//trace(e);
		}
		window.onwheel = function(e) {
			trace(e);
		}
		*/

		/*
		om.audio.Microphone.get();
		untyped navigator.getUserMedia( { audio: true },
			function(e){
				trace(e);
			},
			function(e) {
				trace(e);
			}
		);
		*/
	}
}
