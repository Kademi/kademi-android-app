(function (g) {
    controllerMappings
        .websiteController()
        .enabled(true)
        .isPublic(true)
        .pathSegmentName('_flutterApi')
        .defaultView(views.jsonView(false, 'Unknown Method'))
        .addMethod('GET', '_getProducts', 'products')
        .addMethod('GET', '_getCategories', 'categories')
        .addMethod('GET', '_getPoints', 'points')
        .build();
})(this);