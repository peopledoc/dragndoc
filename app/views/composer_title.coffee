ComposerTitleView = Marionette.ItemView.extend(
    template: "/templates/composer_title"
    events:
        "click #helptrigger": "showHelp"

    # Update drop zone design on dragover
    showHelp: (e) ->
        e.originalEvent.preventDefault()
        DragNDoc.execute "app:help"

)
module.exports = ComposerTitleView