(function (g) {
    /**
     * This method gets called whenever the app get's enabled.
     * 
     * @param {OrganisationRootFolder} orf
     * @param {WebsiteRootFolder} wrf
     * @param {Boolean} enabled
     */
    g._onAppEnabled = function (orf, wrf, enabled) {
    };


    g._checkRedirect = function (page, params) {
        var href = page.href;
        if (!href.endsWith('/')) {
            return views.redirectView(href + '/');
        }
    };
})(this);