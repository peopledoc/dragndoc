DocumentView = Marionette.CompositeView.extend(
    itemView: require("views/page")
    itemViewContainer: ".docpages"
    template: "/templates/booklet"
    className: "booklet"

    ui:
        "docwrapper": "div.docwrapper"
        "docpages": "div.docpages"

    events:
        "dragover div.docwrapper": "dragoverBookletDropZone"
        "dragleave div.docwrapper": "dragleaveBookletDropZone"
        "drop div.docwrapper": "addPageToDoc"

    # Update drop zone design on dragover
    dragoverBookletDropZone: (e) ->
        e.originalEvent.preventDefault()
        @ui.docwrapper.addClass('hovered')

    dragleaveBookletDropZone: (e) ->
        e.originalEvent.preventDefault()
        @ui.docwrapper.removeClass('hovered')

    addPageToDoc: (e) ->
        @trigger("page:add", @model)
        @ui.docwrapper.removeClass('hovered')

    initialize: ->

        @collection = @model.get('pages')
        @collection.invoke('set', composed: true)

        @on "itemview:page:show_preview", (childView, model) ->
            DragNDoc.execute "page:preview", model

        @on "itemview:page:close", (childView, model) ->
            docid = model.get("id")
            @collection.remove(model)
            # Was it the last page ? if so we delete the doc
            if @collection.length == 0
                @close()
            # Tell the world
            DragNDoc.vent.trigger("page:deleted", docid)

        @on "itemview:page:sort", (childView, pageModel, index) ->
            tempModel = pageModel
            @collection.remove(pageModel)
            @collection.add(tempModel, at:index)


    onShow: ->
        @ui.docpages.sortable(
            container: "div.docwrapper",
            stop: (event, ui) ->
                ui.item.trigger "sortable:drop", ui.item.index()
        )

)

module.exports = DocumentView