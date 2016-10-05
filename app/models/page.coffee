# Page model
PageModel = Backbone.Model.extend(
    defaults:
        id: null
        name: ""
        small_src: ""
        large_src: ""
        enabled: true   # Can it be selected?
        composed: false   # was it merged into a doc?
        selected: false
        dragging: false
        ordinal: -1
        viewed: false
        loading: false
        loaded: false
)

# Page Collection
PagesCollection = Backbone.Collection.extend(
    _toBeLoadedQueue: []
    _loadingSlotAvailable: ->
        return not @maxConcurrentLoadingPages or @where({loading: true}).length < @maxConcurrentLoadingPages
    initialize: ->
        @maxConcurrentLoadingPages = DragNDoc.request("options:maxConcurrentLoadingPages")
        @on "change:viewed", (model, viewed) =>
            if @_loadingSlotAvailable() then model.set("loading", true)
            else if viewed then @_toBeLoadedQueue.push(model)
        @on "change:loaded", (model, loaded) =>
            if loaded and @_toBeLoadedQueue.length then @_toBeLoadedQueue.shift().set("loading", true)
    model = PageModel
    comparator: (model) ->
        model.get "ordinal"
)

module.exports =
    Page: PageModel
    PagesCollection: PagesCollection
