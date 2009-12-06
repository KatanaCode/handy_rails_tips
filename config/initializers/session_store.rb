config.action_controller.session = {
  :session_key => '_tips_session',
  :secret      => 'ab25d67b0823ee1fdc00b17bd4ad6f4e25ea7688a39dd315933cb0065a5d3dac311230d52d1f311013a0466276c0747dbdd651709376acc87309ba6d54e77c13'
}

ActionController::Base.session_store = :active_record_store
