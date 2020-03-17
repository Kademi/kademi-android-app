(function (g) {

    function config() {
        var _self = this;

        _self.APP_ID = 'flutterApi';
        _self.REPO_NAME = _self.APP_ID + '_repo';

        _self.RECORD_NAMES = {
            EXAMPLE: function (name) {
                return 'example_' + name;
            }
        };

        _self.RECORD_TYPES = {
            EXAMPLE: 'EXAMPLE'
        };

        _self.RECORD_TEMPLATES = {
            EXAMPLE: function () {
                return {};
            }
        };
    }

    g._config = new config();
})(this);