package strobe;

import om.Browser;
import om.Browser.console;
import om.Browser.document;
import om.Browser.window;
import om.Json;
import js.html.Element;
import js.html.InputElement;
import om.Time;

class App {

	static inline var STORAGE_ID = "disktree.strobe";

	static var light : Element;
	static var controls : Element;
	
	static var enabled = true;

	static var colorBackground = '#000000';
    static var colorFlash = '#ffffff';
    static var flashInterval = 100;
	static var flashDuration = 33;

	static var flashing = false;
    static var timeStart : Float;
    static var lastTimeFlash : Float;

	static function update( time : Float ) {

        window.requestAnimationFrame( update );

		if( !enabled ) return;

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

		console.log( '%cSTROBE.DISKTREE', 'color:#fff;background:#000;' );

		var storage = Browser.localStorage;

		light = document.getElementById('light');
		controls = document.getElementById('controls');

		var backgroundColorElement : InputElement = cast controls.querySelector( 'input[name="background-color"]' );
		var flashColorElement : InputElement = cast controls.querySelector( 'input[name="flash-color"]' );
		var intervalElement : InputElement = cast controls.querySelector( 'input[name="interval"]' );
		var durationElement : InputElement = cast controls.querySelector( 'input[name="duration"]' );
		var transitionElement : InputElement = cast controls.querySelector( 'input[name="transition"]' );
		
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
			//trace(e.keyCode);
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

		window.onclick = e -> controls.classList.remove('hidden');
		document.onmouseleave = e -> controls.classList.add('hidden');

		window.onbeforeunload = function(e){
			//e.preventDefault();
			//e.returnValue = '';
			storage.setItem( STORAGE_ID, Json.stringify( {
				colorBackground: colorBackground,
				colorFlash: colorFlash,
				flashInterval: flashInterval,
				flashDuration: flashDuration
			} ) );
			return null;
		}

		var _settings = storage.getItem( STORAGE_ID );
		if( _settings != null ) {
			var settings = Json.parse( _settings );
			colorBackground = backgroundColorElement.value = settings.colorBackground;
			colorFlash = flashColorElement.value = settings.colorFlash;
			flashInterval = settings.flashInterval;
			intervalElement.value = Std.string( flashInterval );
			flashDuration = settings.flashDuration;
			durationElement.value = Std.string( flashDuration );
		}

		document.ondblclick = function(e){
			trace(e);
			if( document.fullscreen ) {
				document.exitFullscreen();
			} else {
				document.documentElement.requestFullscreen();
			}
		}

		window.onmessage = function(e){
			trace(e);
			//TODO
			//window.alert(e.data);
			switch e.data {
			case 'on': enabled = true;
			case 'off': enabled = false;
			}
		};

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
