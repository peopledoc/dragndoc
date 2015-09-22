import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';
import Store from "ember-cli-simple-store/store";

const { Object:EObject } = Ember;

let controller;

moduleFor('controller:application', {
  setup() {
    this.container.register('store:main', Store);
    controller = this.subject({
      store: Store.create()
    });
  }
});

test('It exposes the config', function(assert) {
  this.container.register('config:embedded', EObject.extend({ testProp: "testValue" }));
  assert.equal(controller.get('testProp'), 'testValue', 'it proxies the values in the config');
});

test('it hides the help by default', function(assert) {
  assert.equal(controller.get('isHelpVisible'), false);
});

test('The help can be toggled with an action', function(assert) {
  controller.send('toggleHelp');
  assert.equal(controller.get('isHelpVisible'), true);
  controller.send('toggleHelp');
  assert.equal(controller.get('isHelpVisible'), false);
});
