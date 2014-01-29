
AppLayout = Backbone.Marionette.Layout.extend(
  template: "/templates/app_layout"
  el: "div#dragndoc-wrapper"
  regions:
    pagePicker: "#source"
    pagePickerContent: "#source-content"
    composer: "#compose"
    composerContent: "#compose-content"
)

module.exports = AppLayout
