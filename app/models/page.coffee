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

)

# Page Collection
PagesCollection = Backbone.Collection.extend(
    model = PageModel
)

module.exports = 
    Page: PageModel
    PagesCollection: PagesCollection
