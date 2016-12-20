ActiveAdmin.register User do
permit_params :email, :password, :password_confirmation

index do
    selectable_column
    column :email
    column :encrypted_password
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    column :apdeted_at
    column :updated_at
    actions
end

form do |f|
  inputs 'Details' do
    f.input :email
    f.input :password
    f.input :password_confirmation
  end
  actions
end
end
