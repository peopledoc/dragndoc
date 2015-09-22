import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['page-wrap', 'doc-page'],
  classNameBindings: [
    'dragging',
    'isDraggable::disabled',
    'isDraggable::composed',
    'isDraggable:hvr-grow'
  ],
  isDraggable: Ember.computed.reads('content.available'),
  actions: {
    startDragging() {
      this.set('dragging', true);
    },
    stopDragging() {
      this.set('dragging', false);
    }
  }
});
