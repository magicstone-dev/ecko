import React from 'react';
import PropTypes from 'prop-types';

export default class Sponsor extends React.PureComponent {

  static contextTypes = {
    router: PropTypes.object,
  };

  static propTypes = {
    sponsor_category: PropTypes.string.isRequired,
  };

  colors = {
    silver_tier: '#C0C0C0',
    gold_tier: '#FFD700',
    platinum_tier: '#e5e4e2',
  }

  render () {
    if(!this.props.sponsor_category || this.props.sponsor_category === 'free_tier') {
      return null;
    }

    let background = this.colors[this.props.sponsor_category];

    return (
      <div className='account-role admin sponsor-badge' style={{ background: background }}><span>Sponsor</span></div>
    );
  }

}
