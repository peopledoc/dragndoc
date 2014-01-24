# Override default behavior with template: "#xxxx" we want to be
# able to use then hbs path directly such as template: "hbs template path"
Backbone.Marionette.Renderer.render = (templateName, data) ->
  if _.isFunction templateName
    template = templateName
  else
    template = require templateName

  return template data
