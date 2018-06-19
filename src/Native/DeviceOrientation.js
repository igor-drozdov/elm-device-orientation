// import Native.Scheduler //

var _igor_drozdov$device_orientation$Native_DeviceOrientation = function() {

    function isSupported() {
        return typeof window.DeviceOrientationEvent === 'function'
    }

    function toOrientationProperties(target) {
        return {
            alpha: target.alpha,
            beta: target.alpha,
            gamma: target.alpha,
            absolute: target.absolute
        }
    }

    function onEvent(eventName, toTask) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {

            function performTask(event) {
                _elm_lang$core$Native_Scheduler.rawSpawn(toTask(toOrientationProperties(event.target)));
            }

            document.addEventListener(eventName, performTask);

            return function() {
                document.removeEventListener(eventName, performTask);
            };
        });
    }

    function onDeviceOrientation(toTask) {
        return onEvent("ondeviceorientation", toTask);
    }

    function onDeviceMotion(toTask) {
        return onEvent("ondevicemotion", toTask);
    }

    return {
        onDeviceOrientation: onDeviceOrientation,
        onDeviceMotion: onDeviceMotion,
        isSupported: isSupported
    };

}();
