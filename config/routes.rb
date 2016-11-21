Rails.application.routes.draw do
##development####################################################################
  root to: 'app_users#home' #
  post 'experiment' => 'app_users#experiment' #

##email##########################################################################
  post 'email_account_signup' => 'email_account_users#email_account_sign_up'#
  post 'email_account_login' => 'email_account_users#email_account_login'#
  get  'account_activations/:id/edit' => 'account_activations#activate'#
  post 'email_account_reset_password' => 'email_account_users#email_account_reset_password'#
  get  'pw_resetters/:id/edit' => 'pw_resetters#edit'#
  post 'pw_resetters/done' => 'pw_resetters#done', as:'pw_done'#

##third_party####################################################################
  post 'third_party_account_login' => 'third_party_account_users#third_party_account_sign_in'#

##app_user#######################################################################
  post 'app_account_manage' => 'app_users#manage_my_account'
  post 'upload_image' => 'app_users#upload_image'
  post 'fetch_my_info' => 'app_users#fetch_my_info'
  post 'update_my_avatar' => 'app_users#update_my_avatar'
  post 'auto_login' => 'app_users#auto_login'#
  post 'nickname_check' => 'app_users#check_nickname_exist'#
  # 需求未定
  get ':user_id/delete_image/' => 'app_users#delete_image'
end
