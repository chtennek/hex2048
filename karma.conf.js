module.exports = function(config) {
  config.set({

    files: [
      'bower_components/angular/angular.js',
      'bower_components/angular-route/angular-route.js',
      'bower_components/angular-resource/angular-resource.js',
      'bower_components/angular-animate/angular-animate.js',
      'bower_components/angular-hotkeys/build/hotkeys.js',
      'bower_components/angular-mocks/angular-mocks.js',

      'app/javascripts/**/*.coffee',
      'test/unit/**/*.coffee'
    ],

    preprocessors: {
      '**/*.coffee': 'coffee'
    },

    autoWatch: true,

    frameworks: ['mocha', 'chai', 'sinon'],

    browsers: ['Chrome'],

    plugins: [
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-coffee-preprocessor',
            'karma-mocha',
            'karma-chai',
            'karma-sinon'
            ],

    junitReporter: {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }

  });
};
