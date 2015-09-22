import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';

const { Object:EObject } = Ember;

moduleFor('controller:application');

test('It exposes the config', function(assert) {
  var controller = this.subject();
  controller.container.register('config:embedded', EObject.extend({ testProp: "testValue" }));
  assert.equal(controller.get('testProp'), 'testValue', 'it proxies the values in the config');
});

test('it hides the help by default', function(assert) {
  var controller = this.subject();
  assert.equal(controller.get('isHelpVisible'), false);
});

test('The help can be toggled with an action', function(assert) {
  var controller = this.subject();
  controller.send('toggleHelp');
  assert.equal(controller.get('isHelpVisible'), true);
  controller.send('toggleHelp');
  assert.equal(controller.get('isHelpVisible'), false);
});
