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
        retry: 0
    initialize: ->
        @maxPageLoadingRetries = DragNDoc.request("options:maxPageLoadingRetries")
    loadingEnqueue: ->
        @set "viewed", true
    loadingSucceeded: ->
        @set "loading", false
        @set "loaded", true
    loadingFailed: ->
        @set "loading", false
        if @get("retry") < @maxPageLoadingRetries
            @set("retry", @get("retry") + 1)
)

# Page Collection
PagesCollection = Backbone.Collection.extend(
    _toBeLoadedQueue: []
    _loadingSlotAvailable: ->
        return @where({loading: true}).length < @maxConcurrentLoadingPages
    _loadNextPage: () ->
        if @_loadingSlotAvailable() and @_toBeLoadedQueue.length then @_toBeLoadedQueue.shift().set("loading", true)
    _enqueuePage: (model) ->
        @_toBeLoadedQueue.push(model)
        @_loadNextPage()
    initialize: ->
        @maxConcurrentLoadingPages = DragNDoc.request("options:maxConcurrentLoadingPages")
        @on "change:viewed", (model) =>
            @_enqueuePage(model)
        @on "change:retry", (model) =>
            @_enqueuePage(model)
        @on "change:loaded", (model) =>
            if model.get("loaded") then @_loadNextPage()
    model: PageModel
    comparator: (model) ->
        model.get "ordinal"
)

module.exports =
    Page: PageModel
    PagesCollection: PagesCollection
