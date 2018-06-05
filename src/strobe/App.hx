package strobe;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.Element;
import js.html.InputElement;
import om.Time;

class App {

    static var element : DivElement;
    static var controls : DivElement;

    static var backgroundColor : String;
    static var flashColor : String;
    static var flashInterval : Int;
    static var flashDuration : Int;

    static var flashing : Bool;
    static var timeStart : Float;
    static var lastTimeFlash : Float;

    static function update( time : Float ) {

        window.requestAnimationFrame( update );

        var timeElapsed = time - lastTimeFlash;

        if( flashing ) {
            if( timeElapsed > flashDuration ) {
                flashing = false;
                element.style.backgroundColor = backgroundColor;
            }
        } else {
            if( timeElapsed > flashInterval ) {
                flashing = true;
                lastTimeFlash = time;
                element.style.backgroundColor = flashColor;
            }
        }
    }

    static function main() {

        window.onload = function(e){

            flashing = false;
            timeStart = Time.now();
            lastTimeFlash = timeStart;

            element = cast document.querySelector( 'div.light' );
            controls = cast document.querySelector( 'div.controls' );

            var backgroundColorElement : InputElement = cast document.querySelector( 'input[name="background-color"]' );
            var intervalElement : InputElement = cast document.querySelector( 'input[name="interval"]' );
            var durationElement : InputElement = cast document.querySelector( 'input[name="duration"]' );
            var transitionElement : InputElement = cast document.querySelector( 'input[name="transition"]' );
            var flashColorElement : InputElement = cast document.querySelector( 'input[name="flash-color"]' );

            backgroundColorElement.oninput = e -> backgroundColor = e.target.value;
            flashColorElement.oninput = e -> flashColor = e.target.value;

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
                element.style.transition = 'background-color '+v+'s';
            }

            backgroundColor = backgroundColorElement.value;
            flashColor = flashColorElement.value;
            flashInterval = Std.parseInt( intervalElement.value );
            flashDuration = Std.parseInt( durationElement.value );

            //window.addEventListener( 'resize', handleWindowResize, false );
            //window.addEventListener( 'mousemove', handleMouseMove, false );
            //window.addEventListener( 'click', handleClick, false );

            window.requestAnimationFrame( update );

            window.onblur = e -> {
                //controls.classList.add('hidden');
            }
            window.onfocus = e -> {
                //controls.classList.remove('hidden');
            }
        }
    }

}
