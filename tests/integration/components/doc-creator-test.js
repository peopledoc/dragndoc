import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import startApp from '../../helpers/start-app';

moduleForComponent('doc-creator', 'Integration | Component | doc creator', {
  integration: true,
  setup: startApp
});

test('it renders', function(assert) {
  assert.expect(1);

  this.render(hbs`{{doc-creator}}`);

  assert.ok(true, 'it renders without errors');
});
