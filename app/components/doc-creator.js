import Ember from 'ember';

const { get } = Ember;

export default Ember.Component.extend({
  classNames: ['doc-creator'],
  classNameBindings: ['hovered', 'hovered:hvr-buzz-out'],
  validateText: null,
  canNotSubmit: true,
  hovered: false,
  _initConfig: function () {
    var conf = this.container.lookup('config:embedded') || {};
    this.set('validateText', get(conf, 'validateText'));
  }.on('init'),
  actions: {
    dropped(obj/* , opts */) {
      obj.set('available', false);
    },
    enteringDrag() {
      this.set('hovered', true);
    },
    leavingDrag() {
      this.set('hovered', false);
    }
  }
});
