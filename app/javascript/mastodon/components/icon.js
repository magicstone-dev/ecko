import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

export default class Icon extends React.PureComponent {

  static propTypes = {
    id: PropTypes.string.isRequired,
    className: PropTypes.string,
    fixedWidth: PropTypes.bool,
    parent: PropTypes.string,
  };

  render () {
    const { id, className, fixedWidth, parent, ...other } = this.props;

    return (
      <i role='img' className={classNames(`${parent || 'fa'}`, `fa-${id}`, className, { 'fa-fw': fixedWidth })} {...other} />
    );
  }

}
