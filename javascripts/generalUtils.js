var generalUtil = (function () {
    var generalUtil = {};

    // Return an array of object without same key value.
    // If the element is primitive type, the element itself is the key.
    generalUtil.convertArrayToSet = function (key, array) {
        var dict = {};

        for (var i = 0; i < array.length; i++) {
            var elem = array[i];

            if (typeof elem === "object") {
                dict[elem[key]] = elem;
            } else {
                dict[elem] = elem;
            }
        }

        var set = [];

        for (var dictKey in dict) {
            set.push(dict[dictKey]);
        }

        return set;
    };

    /*
       Transform seconds into string with format "hh:MM:ss"
       Hours can be in any length, ex: getTimerString(123 * 3600 + 32 * 60 + 59) returns "123:32:59"
    */
    generalUtil.getTimerString = function (seconds) {
        var second = parseInt(seconds % 60);
        var minute = parseInt(seconds / 60) % 60;
        var hour = parseInt(seconds / 3600);

        var timerString = '';
        if (hour > 0) {
            timerString += hour + ':';
        }

        var strPadLeft = 1;

        if (minute >= 10) {
            timerString += minute + ':';
        } else if (hour == 0) {
            if (minute > 0) {
                timerString += minute + ':';
            }
        } else {
            timerString += generalUtil.pad(minute.toString(), 2, '0', strPadLeft) + ':';
        }
      
        if (timerString.length > 0 && second < 10) {
            timerString += generalUtil.pad(second.toString(), 2, '0', strPadLeft);
        } else {
            timerString += second;
        }

        return timerString;
    };

    generalUtil.pad = function (str, len, padStr, dir) {

        var strPadLeft = 1;
        var strPadRight = 2;
        var strPadBoth = 3;

        if (typeof (len) == "undefined") {
            len = 0;
        }
        if (typeof (padStr) == "undefined") {
            padStr = ' ';
        }
        if (typeof (dir) == "undefined") {
            dir = strPadRight;
        }

        if (len + 1 >= str.length) {
            switch (dir) {
                case strPadLeft:
                    str = Array(len + 1 - str.length).join(padStr) + str;
                    break;
                case strPadBoth:
                    var right = Math.ceil((padlen = len - str.length) / 2);
                    var left = padlen - right;
                    str = Array(left + 1).join(padStr) + str + Array(right + 1).join(padStr);
                    break;
                default:
                    str = str + Array(len + 1 - str.length).join(padStr);
                    break;
            }
        }
        return str;
    };

    return generalUtil;
})();