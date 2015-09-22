import Ember from 'ember';

const { computed, Component } = Ember;

export default Component.extend({
  classNames: ['compose-btn'],
  canNotSubmit: computed.not('canSubmit'),
  canSubmit: false
});
