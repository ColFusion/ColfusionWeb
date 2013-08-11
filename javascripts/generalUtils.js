var generalUtil = (function() {
    var generalUtil = {};

    // Return an array of object without same key value.
    // If the element is primitive type, the element itself is the key.
    generalUtil.convertArrayToSet = function(key, array) {
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

    return generalUtil;
})();