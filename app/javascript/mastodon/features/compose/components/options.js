import PropTypes from 'prop-types';
import React from 'react';
import { FormattedMessage, defineMessages, injectIntl } from 'react-intl';
import ImmutablePureComponent from 'react-immutable-pure-component';
import Dropdown from './dropdown';

const messages = defineMessages({
  content_type: {
    defaultMessage: 'Content type',
    id: 'content-type.change',
  },
  markdown: {
    defaultMessage: 'Markdown',
    id: 'compose.content-type.markdown',
  },
  plain: {
    defaultMessage: 'Plain text',
    id: 'compose.content-type.plain',
  },
  html: {
    defaultMessage: 'HTML',
    id: 'compose.content-type.html',
  },
});

export default @injectIntl
class ComposerOptions extends ImmutablePureComponent {

  static propTypes = {
    onChangeContentType: PropTypes.func,
    showContentTypeChoice: PropTypes.bool,
    contentType: PropTypes.string,
    onModalClose: PropTypes.func,
    onModalOpen: PropTypes.func,
    intl: PropTypes.object.isRequired,
  }

  render() {
    const {
      onChangeContentType,
      contentType,
      onModalClose,
      onModalOpen,
      intl,
    } = this.props;

    const contentTypeItems = {
      plain: {
        icon: 'file-text',
        name: 'text/plain',
        text: <FormattedMessage {...messages.plain} />,
      },
      html: {
        icon: 'code',
        name: 'text/html',
        text: <FormattedMessage {...messages.html} />,
      },
      markdown: {
        icon: 'arrow-circle-down',
        name: 'text/markdown',
        text: <FormattedMessage {...messages.markdown} />,
      },
    };

    return (
      <Dropdown
        icon={(contentTypeItems[contentType.split('/')[1]] || {}).icon}
        items={[
          contentTypeItems.plain,
          contentTypeItems.html,
          contentTypeItems.markdown,
        ]}
        onChange={onChangeContentType}
        onModalClose={onModalClose}
        onModalOpen={onModalOpen}
        title={intl.formatMessage(messages.content_type)}
        value={contentType}
      />
    );
  }

}
