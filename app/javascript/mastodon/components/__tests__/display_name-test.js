import React from 'react';
import renderer from 'react-test-renderer';
import { fromJS }  from 'immutable';
import DisplayName from '../display_name';

describe('<DisplayName />', () => {
  it('renders display name + account name', () => {
    const account = fromJS({
      username: 'bar',
      acct: 'bar@baz',
      display_name_html: '<p>Foo</p>',
      sponsor: 'free_tier',
    });
    const component = renderer.create(<DisplayName account={account} />);
    const tree      = component.toJSON();

    expect(tree).toMatchSnapshot();
  });
});
