import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['booklet'],
  actions: {
    dropped(page) {
      this.get('content.pages').pushObject(page);
    }
  }
});
