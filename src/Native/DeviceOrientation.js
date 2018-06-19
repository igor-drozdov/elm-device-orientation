// import Native.Scheduler //

var _igor_drozdov$device_orientation$Native_DeviceOrientation = function() {

    function isSupported() {
        return typeof window.DeviceOrientationEvent === 'function'
    }

    function toOrientationProperties(target) {
        return {
            alpha: target.alpha,
            beta: target.beta,
            gamma: target.gamma,
            absolute: target.absolute
        }
    }

    function onEvent(eventName, toTask) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {

            function performTask(event) {
                _elm_lang$core$Native_Scheduler.rawSpawn(toTask(toOrientationProperties(event)));
            }

            window.addEventListener(eventName, performTask);

            return function() {
                window.removeEventListener(eventName, performTask);
            };
        });
    }

    function onDeviceOrientation(toTask) {
        return onEvent("deviceorientation", toTask);
    }

    return {
        onDeviceOrientation: onDeviceOrientation,
        isSupported: isSupported
    };

}();
