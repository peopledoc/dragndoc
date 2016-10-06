
PageView = Marionette.ItemView.extend(
    tagName: "div"
    className: "page-wrap grow"
    template: "/templates/page"

    ui:
        "image": "img",
        "spinner": ".spinner"

    events:
        "click img": "imgClick"
        "dragstart img": "dragstart"
        "dragend img": "dragend"
        "click div.close": "closeClick"
        "sortable:drop": "drop"
        "inview": "inviewChanged"

    modelEvents:
        "change:enabled": "enabledChanged"
        "change:composed": "composedChanged"
        "change:selected": "selectedChanged"
        "change:dragging": "draggingChanged"
        "change:loading": "loadingChanged"

    initialize: ->
        if @model.get("composed")
            @_composePage()

        @on "itemview:page:show_preview", (childView, model) ->
            DragNDoc.execute "page:preview", model

    onRender: ->
        @ui.image.one "load", @imageLoadChanged.bind(@)

    # On drag start we update our styling
    dragstart: (e) ->
        # Check if this page is not already selected
        if @model.get("composed")
            e.stopPropagation()
            e.preventDefault()
            return

        @trigger("page:dragstart", @model)

    dragend: (e) ->
        @trigger("page:dragend", @model)

    # Page was sorted inside a doc
    drop: (e, index) ->
        e.stopPropagation()
        e.preventDefault()
        @trigger("page:sort", @model, index)


    imgClick: (e) ->
        if e.ctrlKey || e.ctrlKey && e.altKey
            # Ctrl key on active non merged page should gray out the page
            if @model.get("enabled") and not @model.get("composed")
                @model.set(enabled: false)
                @model.set(selected: true)
                @trigger("page:selected", @model)

            # On non active and not merged page it should switch back to normal
            else if not @model.get("enabled") and not @model.get("composed")
                @model.set(enabled: true)
                @model.set(selected: false)
                @trigger("page:deselected", @model)

        else if e.shiftKey
            if not $(@el).hasClass("disabled")
                @trigger("page:shift:selected", @model)
        else
            @trigger("page:show_preview", @model)

    closeClick: (e) ->
         @trigger("page:close", @model)

    # Update page styling accordingly
    enabledChanged: ->
        if @model.get("enabled")
            @_enablePage()
        else
            @_disablePage()

    composedChanged: ->
        if @model.get("composed")
            $(@el).removeClass("selected")
            $(@el).addClass("composed")
        else
            $(@el).removeClass("composed")

    selectedChanged: ->
        if @model.get("selected")
            $(@el).addClass("selected")
        else
            $(@el).removeClass("selected")

    draggingChanged: ->
        if @model.get("dragging")
            $(@el).addClass "dragging"
        else
            $(@el).removeClass "dragging"

    inviewChanged: ->
        @model.set "viewed", true

    loadingChanged: ->
        if @model.get "loading" then @_loadImage()

    imageLoadChanged: ->
        @ui.spinner.remove()
        @model.set "loading", false
        @model.set "loaded", true

    _loadImage: ->
        @ui.image.attr("src", @model.get("small_src"))

    _composePage: ->
        $(@el).addClass("composed").addClass("grow")

    _enablePage: ->
        $(@el).removeClass("disabled").addClass("grow")

    _disablePage: ->
        $(@el).addClass("disabled").removeClass("grow")
)

module.exports = PageView
