import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['doc-creator'],
  classNameBindings: ['hovered', 'hovered:hvr-buzz-out'],
  hovered: false,
  actions: {
    dropped(obj/* , opts */) {
      this.sendAction('create', obj);
    },
    enteringDrag() {
      this.set('hovered', true);
    },
    leavingDrag() {
      this.set('hovered', false);
    }
  }
});
