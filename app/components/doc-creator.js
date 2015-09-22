import Ember from 'ember';

const { get } = Ember;

export default Ember.Component.extend({
  classNames: ['doc-creator'],
  validateText: null,
  canNotSubmit: true,
  _initConfig: function () {
    var conf = this.container.lookup('config:embedded') || {};
    this.set('validateText', get(conf, 'validateText'));
  }.on('init')
});
