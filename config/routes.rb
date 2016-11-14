Rails.application.routes.draw do
################################################################################
  root to: 'app_users#home'
  post 'experiment' => 'app_users#experiment'

################################################################################
  post 'email_account_signup' => 'email_account_users#email_account_sign_up'
  post 'email_account_login' => 'email_account_users#email_account_login'
  get  'account_activations/:id/edit' => 'account_activations#activate'
  post 'email_account_reset_password' => 'email_account_users#email_account_reset_password'
  get  'pw_resetters/:id/edit' => 'pw_resetters#edit'
  post 'pw_resetters/done' => 'pw_resetters#done', as:'pw_done'

################################################################################
  post 'third_party_account_signup' => 'third_party_account_users#third_party_account_sign_in'

################################################################################
  post 'app_account_manage' => 'app_users#manage_my_account'
  post 'upload_image' => 'app_users#upload_image'
  post 'fetch_my_info' => 'app_users#fetch_my_info'
  # 需求未定
  get ':user_id/delete_image/' => 'app_users#delete_image'
  post 'update_my_avatar' => 'app_users#update_my_avatar'
  post 'auto_login' => 'app_users#auto_login'
end
