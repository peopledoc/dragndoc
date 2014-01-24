PagePickerCompositeView = Marionette.CompositeView.extend(
    tagName: "row"
    template: "templates/page_list"
    itemView: require("views/page")
)

module.exports = PagePickerCompositeView