import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['page-wrap', 'doc-page'],
  classNameBindings: [
    'dragging',
    'isDraggable::disabled',
    'content.isAvailable::composed',
    'highlight',
    'selected',
  ],
  selected: false,
  isDraggable: Ember.computed.reads('content.available'),
  highlightClass: '',
  highlight: Ember.computed('selected', 'isDraggable', {
    get() {
      if (!this.get('selected') && this.get('isDraggable')) {
        return this.get('highlightClass');
      }
      return '';
    }
  }),
  actions: {
    startDragging() {
      this.set('dragging', true);
    },
    stopDragging() {
      this.set('dragging', false);
    }
  }
});
