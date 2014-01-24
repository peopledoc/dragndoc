# Put your handlebars.js helpers here.
# Handlebars block helpers http://handlebarsjs.com/block_helpers.html
#
Handlebars.registerHelper 'pick', (context, options) ->
        return options.hash[context]