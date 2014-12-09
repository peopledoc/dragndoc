ComposerCompositeView = Marionette.CompositeView.extend(
    tagName: "div"
    template: "/templates/composer"
    itemView: require("views/document")
    itemViewContainer: "#docs"

    ui:
        "dropzone": "div#dropzone"
        "doccount": "#docs-count"
        "submitButton": "#submit-docs"

    events:
        "dragover div#dropzone": "dragoverDropZone"
        "dragleave div#dropzone": "dragleaveDropZone"
        "drop div#dropzone": "newdocument"
        "click button": "submit"

    serializeData: ->
        "callbackText": DragNDoc.request("options:callbackText")

    submit: (e) ->
        @trigger("docs:export")
  
    # This would have been native in Marionette 2.0
    # Remove if updated at some point
    appendHtml: (collectionView, itemView, index) ->
        childrenContainer = $(collectionView.childrenContainer || collectionView.itemViewContainer || collectionView.el);
        children = childrenContainer.children()
        if (children.size() == index)
          childrenContainer.append(itemView.el)
        else
          childrenContainer.children().eq(index).before(itemView.el)

    # Update drop zone design on dragover
    dragoverDropZone: (e) ->
        e.originalEvent.preventDefault()
        @ui.dropzone.addClass('buzz-out hovered')

    dragleaveDropZone: (e) ->
        e.originalEvent.preventDefault()
        @ui.dropzone.removeClass('buzz-out hovered')

    # A drop event has been received we must create a new document instance
    # and update the composer interface 
    newdocument: (e) ->
        e.originalEvent.preventDefault()
        @ui.dropzone.removeClass('buzz-out hovered')
        @trigger("doc:create")
        @ui.submitButton.removeClass("hidden")
)

module.exports = ComposerCompositeView
