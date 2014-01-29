HelpView = Marionette.ItemView.extend(
    tagName: "div"
    template: "/templates/help"

    initialize: ->
        @bind "ok", @seen
        @bind "cancel", @seen

    seen: (modal) ->
        localStorage['dragndoc_helper_seen'] = 1;

    serializeData: ->
        "title": DragNDoc.request("options:helpText")
)

module.exports = HelpView
