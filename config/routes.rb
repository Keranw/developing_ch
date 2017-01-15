Rails.application.routes.draw do
##development####################################################################
  root to: 'app_users#home' #
  post 'experiment' => 'app_users#experiment' #

##email##########################################################################
#改完了
  post 'email_account_signup' => 'email_account_users#email_account_sign_up'
  #多人登陆？
  post 'email_account_login' => 'email_account_users#email_account_login'
  #get  'account_activations/:id/edit' => 'account_activations#activate'
  post 'email_account_reset_password' => 'email_account_users#email_account_reset_password'
  get  'pw_resetters/:id/edit' => 'pw_resetters#edit'
  post 'pw_resetters/done' => 'pw_resetters#done', as:'pw_done'

##third_party####################################################################
#改完了
  post 'third_party_account_login' => 'third_party_account_users#third_party_account_sign_in'

##app_user#######################################################################
#改完了
  post 'auto_login' => 'app_users#auto_login'
  post 'nickname_check' => 'app_users#check_nickname_existence'
  post 'upload_dynamic_picture' => 'app_users#upload_image'
  post 'user_profile_complete' => 'app_users#user_profile_complete'
#未修改
  #个人界面加载自己的数据
  post 'fetch_my_info' => 'app_users#fetch_my_info'
  #个人界面更新自己的静态数据
  post 'app_account_manage' => 'app_users#manage_my_account'
  #个人界面更新头像
  post 'update_my_avatar' => 'app_users#update_my_avatar'
  #删除照片墙中的某张图片
  get ':user_id/delete_image/' => 'app_users#delete_image'

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
end
