import Ember from 'ember';
import startApp from '../../helpers/start-app';
import { initialize } from '../../../instance-initializers/config-model';
import { module, test } from 'qunit';

let instance, registry;

module('Unit | Initializer | config model', {
  beforeEach() {
    const application = startApp();
    registry = application.registry;
    // Should be an ApplcationInstance but... meh...
    instance = {
      registry,
      application,
      container: registry.container()
    };
  }
});

test('it works without config', function(assert) {
  initialize(instance);
  assert.ok(true);
});

test('it works with config but no models', function(assert) {
  registry.register('config:embedded', Ember.Object.extend({  }));
  initialize(instance);
  assert.equal(instance.container.lookup('store:main').find('page').get('length'), 0, 'no model');
});

test('it pushes models in the store', function(assert) {
  registry.register('config:embedded', Ember.Object.extend({ pages: [{}, {}] }));
  initialize(instance);
  assert.equal(instance.container.lookup('store:main').find('page').get('length'), 2, 'Models are pushed to the store');
});
