#
# App entry point
#

DragNDoc = ((Backbone, Marionette) ->

    App = new Marionette.Application()

    # private vars
    pages = {}
    callback = null
    callbackText = ""
    helpText = ""
    maxConcurrentLoadingPages = false

    App.addInitializer (options) ->
        # set layout (source and composition zones)
        AppLayout = require "views/app_layout"
        @layout = new AppLayout().render()
        # Store our options
        pages = options["pages"]
        callback = options["onValidation"]
        callbackText = options["validationText"] || "Validate"
        helpText = options["helpText"] || "How to:"
        maxConcurrentLoadingPages = options["maxConcurrentLoadingPages"] || maxConcurrentLoadingPages;

        for page,i in pages
            page["enabled"] = true # Can it be selected?
            page["composed"]= false # was it merged into a doc?
            page["id"] = i
            page["ordinal"] = i

        # Help popup
        if not localStorage['dragndoc_helper_seen']
            DragNDoc.execute "app:help"

    # Expose app options through API
    API =
        getPagesMeta: ->
            pages
        getCallbackText: ->
            callbackText
        getHelpText: ->
            helpText
        getCallback: ->
            callback
        getMaxConcurrentLoadingPages: ->
            maxConcurrentLoadingPages

    App.reqres.setHandler "pages:meta", ->
        API.getPagesMeta()

    App.reqres.setHandler "options:callbackText", ->
        API.getCallbackText()

    App.reqres.setHandler "options:callback", ->
        API.getCallback()

    App.reqres.setHandler "options:helpText", ->
        API.getHelpText()

    App.reqres.setHandler "options:maxConcurrentLoadingPages", ->
        API.getMaxConcurrentLoadingPages()

    # Marionette Command to display a large page preview as a bootsrap modal
    App.commands.setHandler "page:preview", (model) ->
        PreviewView = require("views/page_preview")
        modalView = new PreviewView(model: model)
        new Backbone.BootstrapModal(
            content: modalView,
            showFooter: false,
            animate: false,
            modalDialogId: "page-previewer").open()

    App.commands.setHandler "app:help", ->
        HelpView = require("views/help")
        modalView = new HelpView(helpText:helpText)
        new Backbone.BootstrapModal(
            content: modalView,
            animate: false,
            allowCancel: false,
            modalDialogId: "helper").open()

    App

)(Backbone, Marionette)

module.exports = DragNDoc

#
# Source page picker module
#

DragNDoc.module "DragnDoc.PagePicker", (PagePicker, DragnDoc, Backbone, Marionette, $, _) ->

    models = require("models/page")
    PagePickerCompositeView = require("views/page_picker")

    selectedPagesIds = []

    PagePicker.addInitializer ->

        # fetch pages
        pagesMeta = DragNDoc.request("pages:meta")

        # create and populate collection
        pagesCollection = new models.PagesCollection()
        pagesCollection.reset pagesMeta

        # Spawn view
        pagePickerView = new PagePickerCompositeView(
            collection: pagesCollection
        )

        # Update region & render
        DragNDoc.layout.pagePickerContent.show pagePickerView

        # Listen to view events
        pagePickerView.on "itemview:page:dragstart", (childView, model) ->
            selectedPagesIds.push model.get("id")
            selectedPagesIds = _.union(selectedPagesIds)
            pagesCollection.each (page) ->
                if page.get("id") in selectedPagesIds
                    page.set(dragging: true)

        pagePickerView.on "itemview:page:dragend", (childView, model) ->
            pagesCollection.each (page) ->
                page.set(dragging: false)
            if not model.get("selected")
                selectedPagesIds = _.without(selectedPagesIds, model.get("id"))

        pagePickerView.on "itemview:page:selected", (childView, model) ->
            selectedPagesIds.push model.get("id")

        pagePickerView.on "itemview:page:deselected", (childView, model) ->
            API.removeIdFromSelection model.get("id")


        # When a shift event is received we get all pages with ids between what
        # is saved in `selectedPagesIds` and the received pageId.
        pagePickerView.on "itemview:page:shift:selected", (childView, model) ->
            selectedPagesIds.push model.get("id")
            idsToSelect = []
            pageId = parseInt(model.get("id"), 10)
            highest = _.max(selectedPagesIds)

            if pageId < highest
                startId = pageId
                endId = highest
            else
                startId = _.min(selectedPagesIds)
                endId = pageId
            # Add pages
            while startId <= endId
                page = pagesCollection.get(startId)
                if not page.get("composed")
                    selectedPagesIds.push startId
                    pagesCollection.get(startId).set(enabled: false)
                    pagesCollection.get(startId).set(selected: true)
                startId++

        pagePickerView.on "itemview:page:show_preview", (childView, model) ->
            DragNDoc.execute "page:preview", model

        # Listen to doc creation event
        DragnDoc.vent.on "pages:added", ->
            pagesCollection.each (page) ->
                if page.get("id") in selectedPagesIds
                    page.set(enabled: false)
                    page.set(selected: false)
                    page.set(dragging: false)
                    page.set(composed: true)
            API.resetSelection()

        DragnDoc.vent.on "page:deleted", (docid) ->
            page = pagesCollection.get(docid)
            page.set(enabled: true)
            page.set(composed: false)
            page.set(dragging: false)

    API =
        getSelectedPagesIds: ->
            selectedPagesIds
        resetSelection: ->
            selectedPagesIds = []
        removeIdFromSelection: (id) ->
            selectedPagesIds = _.without(selectedPagesIds, id)

    # Expose selected pages with Marionette Request Response pattern
    DragnDoc.reqres.setHandler "pages:selection", ->
        API.getSelectedPagesIds()



#
# Composer module
#

DragNDoc.module "DragnDoc.Composer", (Composer, DragnDoc, Backbone, Marionette, $, _) ->

    ComposerCompositeView = require("views/composer")
    ComposerTitleView = require("views/composer_title")

    Composer.addInitializer ->
        # Create empty collection
        docModels = require("models/doc")
        @docs = new docModels.DocsCollection()

        # Spawn view
        composerView = new ComposerCompositeView(
            collection: @docs
        )
        composerTitleView = new ComposerTitleView()

        # Update region & render
        DragNDoc.layout.composerContent.show composerView
        DragNDoc.layout.composerTitle.show composerTitleView

        that = @

        # Handle doc:create event
        composerView.on "doc:create", ->
            pages = API.getPagesFromSelection()

            # Get pages data and keep  the selected ones
            pageModels = require("models/page")

            # Create a new collection of pages for our doc
            docPagesCollection = new pageModels.PagesCollection()
            docPagesCollection.reset(pages)

            # Create a doc instance
            doc = new docModels.Doc(pages:docPagesCollection)

            # Add this new doc to our collection
            that.docs.add(doc, at:0)
            # Tell the world about this new doc
            DragnDoc.vent.trigger("pages:added")


        # Handle itemview:page:add to add pages to an existing document
        composerView.on "itemview:page:add", (childView, doc) ->
            newPages = API.getPagesFromSelection()
            _.each(newPages, (pageMeta) ->
                pageMeta["composed"] = true
            )
            doc.get("pages").add(newPages)
            DragnDoc.vent.trigger("pages:added")


        composerView.on "docs:export", (childView, doc) ->
            DragNDoc.request("options:callback")(that.docs.toJSON())

        API =
            getPagesFromSelection: ->
                allPages = DragNDoc.request("pages:meta")

                # Get selected pages ids
                selectedPagesIds = DragNDoc.request("pages:selection")
                # Filter pagesMeta to keep the models we are interested in
                pages = _.select(allPages, (model) ->
                  _.indexOf(selectedPagesIds, model.id) > -1
                )
                pages
