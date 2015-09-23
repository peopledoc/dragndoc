import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['booklet'],
  document: Ember.computed.alias('content'),
  actions: {
    reorderItems(order/* , group */) {
      const pages = this.get('document.pages');
      pages.clear();
      pages.pushObjects(order);
    },
    dropped(page) {
      this.get('document').addPage(page);
    }
  }
});
