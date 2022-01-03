import React from 'react';
import PropTypes from 'prop-types';
import { Emoji } from 'emoji-mart';

export default class Sponsor extends React.PureComponent {

  static contextTypes = {
    router: PropTypes.object,
  };

  static propTypes = {
    sponsor_category: PropTypes.string.isRequired,
  };

  configurations = {
    silver_tier: {
      color: '#C0C0C0',
      title: 'Silver Sponsor',
      emoji: 'second_place_medal',
    },
    gold_tier: {
      color: '#FCD977',
      title: 'Gold Sponsor',
      emoji: 'first_place_medal',
    },
    platinum_tier: {
      color: '#e5e4e2',
      title: 'Platinum Sponsor',
      emoji: 'medal',
    },
  }

  render () {
    if(!this.props.sponsor_category || this.props.sponsor_category === 'free_tier') {
      return null;
    }

    let configurations = this.configurations[this.props.sponsor_category];

    return (
      <div className='sponsor-badge' title={configurations.title}>
        <Emoji emoji={{ id: configurations.emoji }} size={16} />
      </div>
    );
  }

}
