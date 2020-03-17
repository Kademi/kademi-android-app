(function (g) {
    controllerMappings
        .adminController()
        .enabled(true)
        .pathSegmentName('flutterApi')
        .defaultView(views.templateView('/theme/apps/flutterApi/flutterApiExample.html'))
        .build();
})(this);