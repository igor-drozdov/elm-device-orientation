// import Native.Scheduler //

var _igor_drozdov$elm_device_orientation$Native_DeviceOrientation = function() {
    function toOrientationProperties(target) {
        return {
            alpha: target.alpha,
            beta: target.beta,
            gamma: target.gamma,
            absolute: target.absolute
        }
    }

    function toMotionProperties(target) {
        return {
            acceleration: target.acceleration,
            accelerationIncludingGravity: target.accelerationIncludingGravity,
            rotationRate: target.rotationRate,
            interval: target.interval
        }
    }

    function onEvent(eventName, toTask, serialize) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {

            function performTask(event) {
                _elm_lang$core$Native_Scheduler.rawSpawn(toTask(serialize(event)));
            }

            window.addEventListener(eventName, performTask);

            return function() {
                window.removeEventListener(eventName, performTask);
            };
        });
    }

    function onDeviceOrientation(toTask) {
        return onEvent("deviceorientation", toTask, toOrientationProperties);
    }

    function onDeviceMotion(toTask) {
        return onEvent("devicemotion", toTask, toMotionProperties);
    }

    return {
        onDeviceOrientation: onDeviceOrientation,
        onDeviceMotion: onDeviceMotion
    };
}();
