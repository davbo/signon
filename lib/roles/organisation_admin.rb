module Roles
  class OrganisationAdmin

    def self.accessible_attributes
      [:uid, :name, :email, :password, :password_confirmation, :supported_permission_ids,
      :organisation_id, :unconfirmed_email, :confirmation_token]
    end

    def self.permitted_user_params
      [
        :uid,
        :name,
        :email,
        :password,
        :password_confirmation,
        :organisation_id,
        :unconfirmed_email,
        :confirmation_token,
        { supported_permission_ids: [] },
      ]
    end

    def self.role_name
      'organisation_admin'
    end

    def self.level; 2; end

    def self.manageable_roles
      ['normal']
    end
  end
end
