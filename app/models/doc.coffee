# Page model
PagesCollection = require("models/page").PagesCollection

DocModel = Backbone.Model.extend(
    defaults:
        pages: new PagesCollection()
        name: ""

    toJSON: ->
        pageIds = []
        for page in @get("pages").models
            pageIds.push(
                id:page.get("id") + 1
                name: page.get("name")
            )
        pageIds

)

# Page Collection
DocsCollection = Backbone.Collection.extend(
    model = DocModel
)

module.exports = 
    Doc: DocModel
    DocsCollection: DocsCollection
