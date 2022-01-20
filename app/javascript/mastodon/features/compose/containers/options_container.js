import { connect } from 'react-redux';
import Options from '../components/options';
import { changeComposeContentType } from '../../../actions/compose';
import { closeModal, openModal } from 'mastodon/actions/modal';

function mapStateToProps (state) {
  return {
    contentType: state.getIn(['compose', 'content_type']),
  };
}

const mapDispatchToProps = (dispatch) => ({
  onChangeContentType(value) {
    dispatch(changeComposeContentType(value));
  },

  onModalClose() {
    dispatch(closeModal());
  },

  onModalOpen(props) {
    dispatch(openModal('ACTIONS', props));
  },

});

export default connect(mapStateToProps, mapDispatchToProps)(Options);
