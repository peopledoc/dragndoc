import { moduleForComponent, test } from 'ember-qunit';

moduleForComponent('pending-document', 'Integration | Component | pending document', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(0);
  // There's a bug in testing with {{sortable-group}}
  // TODO sort out why pending-component can not be tested
});
