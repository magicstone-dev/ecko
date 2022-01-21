import { connect } from 'react-redux';
import ContentTypeDropdown from '../components/content_type';
import { changeComposeContentType } from '../../../actions/compose';
import { openModal, closeModal } from '../../../actions/modal';
import { isUserTouching } from '../../../is_mobile';

const mapStateToProps = state => ({
  value: state.getIn(['compose', 'content_type']),
});

const mapDispatchToProps = dispatch => ({

  onChange (value) {
    dispatch(changeComposeContentType(value));
  },

  isUserTouching,
  onModalOpen: props => dispatch(openModal('ACTIONS', props)),
  onModalClose: () => dispatch(closeModal()),

});

export default connect(mapStateToProps, mapDispatchToProps)(ContentTypeDropdown);
