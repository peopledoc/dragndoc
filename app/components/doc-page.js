import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['page-wrap', 'doc-page'],
  classNameBindings: [
    'dragging',
    'content.available::disabled',
    'content.available::composed',
    'content.available:hvr-grow'
  ],
  actions: {
    startDragging() {
      this.set('dragging', true);
    },
    stopDragging() {
      this.set('dragging', false);
    }
  }
});
