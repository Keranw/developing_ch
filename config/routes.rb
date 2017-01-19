Rails.application.routes.draw do
##development####################################################################
  root to: 'app_users#home' #
##email##########################################################################
  post 'email_account_signup' => 'email_account_users#email_account_sign_up'
  #多人登陆？
  post 'email_account_login' => 'email_account_users#email_account_login'
  #get  'account_activations/:id/edit' => 'account_activations#activate'
  post 'email_account_reset_password' => 'email_account_users#email_account_reset_password'
  get  'pw_resetters/:id/edit' => 'pw_resetters#edit'
  post 'pw_resetters/done' => 'pw_resetters#done', as:'pw_done'

##third_party####################################################################
  post 'third_party_account_login' => 'third_party_account_users#third_party_account_sign_in'

##app_user#######################################################################
  post 'auto_login' => 'app_users#auto_login'
  post 'nickname_check' => 'app_users#check_nickname_existence'
  post 'upload_dynamic_picture' => 'app_users#upload_image'
  post 'user_profile_complete' => 'app_users#user_profile_complete'
  post 'fetch_my_info' => 'app_users#fetch_my_info'
  post 'manage_my_account' => 'app_users#manage_my_account'
  post 'fetch_my_picture_wall' => 'app_users#fetch_my_picture_wall'
  post 'update_my_rest_five' => 'app_users#update_my_rest_five'
  post 'update_my_avatar' => 'app_users#update_my_avatar'
  ##
  post 'fetch_the_dynamic_image' => 'app_users#fetch_the_dynamic_image'
  post 'delete_image' => 'app_users#delete_image'

##pairing#######################################################################
#已完成
  #没有装配关于P表的数据
  post 'get_more_profiles_without_gps' => 'pairing_infos#get_more_profiles_without_gps'
  post 'get_more_profiles_with_gps' => 'pairing_infos#get_more_profiles_with_gps'
  #喜欢列表需要删除已经筛选过的
  post 'update_pair_result' => 'pairing_infos#update_pair_result'
  post 'update_like_result' => 'pairing_infos#update_like_result'
  post 'get_like_me_profiles' => 'pairing_infos#get_like_me_profiles'
  post 'get_rest_dynamic_photos' => 'pairing_infos#get_rest_dynamic_photos'

##chart#########################################################################
  post 'get_friend_list' => 'chat#get_friend_list'
  post 'new_message' => 'chat#new_message'
  post 'get_messages' => 'chat#get_messages'
  post 'get_temp_image' => 'chat#get_temp_image'
  post 'get_friend_messages' => 'chat#get_friend_messages'
end
