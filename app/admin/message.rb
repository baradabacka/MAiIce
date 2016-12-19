ActiveAdmin.register Message do
  permit_params :employee, :url, :email, :commit, :aasm_state, :user_id

  index do
      selectable_column
      column :employee
      column :url
      column :email
      column :commit
      column :aasm_state
      column :created_at
      column :updated_at
      actions
  end
end
