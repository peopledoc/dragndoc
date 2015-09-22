import Ember from 'ember';
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('compose-btn', 'Integration | Component | compose btn', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);

  this.render(hbs`{{compose-btn}}`);

  assert.ok(true);
});

test('it can yield', function(assert) {
  assert.expect(1);

  this.render(hbs`
              {{#compose-btn}}
                hop hop hop
              {{/compose-btn}}`);

  assert.equal(this.$().text().trim(), 'hop hop hop');
});

test('it is hidden by default', function (assert) {
  this.render(hbs`{{compose-btn}}`);
  assert.ok(this.$('.btn').is(':hidden'));
});
