import { connect } from 'react-redux';
import PrivacyDropdown from '../components/privacy_dropdown';
import { changeComposeFederation, changeComposeVisibility } from '../../../actions/compose';
import { openModal, closeModal } from '../../../actions/modal';
import { isUserTouching } from '../../../is_mobile';

const mapStateToProps = state => ({
  value: state.getIn(['compose', 'privacy']),
  federation: state.getIn(['compose', 'federation']),
});

const mapDispatchToProps = dispatch => ({

  onChange (value, federation) {
    if (value === 'local') {
      dispatch(changeComposeFederation(!federation));
    } else {
      dispatch(changeComposeVisibility(value));
    }
  },
  isUserTouching,
  onModalOpen: props => dispatch(openModal('ACTIONS', props)),
  onModalClose: () => dispatch(closeModal()),

});

export default connect(mapStateToProps, mapDispatchToProps)(PrivacyDropdown);
