exports.config =

  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^(bower_components|vendor)/
        'js/vendor_without_jquery.js': /^(bower_components[^/]jquery|vendor)/
        'test/javascripts/test.js': /^test/
      order:
        before: [
          'bower_components/jquery/jquery.js',
          'bower_components/underscore/underscore.js',
          'bower_components/backbone/backbone.js',
          'vendor/scripts/backbone.marionette-1.4.1.js',
          'vendor/scripts/console-polyfill.js',
        ]

    stylesheets:
      joinTo: 
        'css/app.css': /^(app)/
        'css/vendor.css': /^(bower_components|vendor|app)/

    templates:
      defaultExtension: 'hbs'
      joinTo: 'js/app.js'

  # CoffeeScript easy-debugging
  sourceMaps: true

  overrides:
      production:
        optimize: yes
        sourceMaps: no

  plugins:
    digest:
      # RegExp that matches files that contain DIGEST references.
      referenceFiles: /\.html$/
      # How many digits of the SHA1 to append to digested files.
      precision: 12

  modules:
    # We cant avoid require js wrapping since brunch modules use commonjs
    wrapper: "commonjs"
    definition: "commonjs"