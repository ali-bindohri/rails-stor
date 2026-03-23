module Filterable
  extend ActiveSupport::Concern
  included do
    helper_method :apply_filters
  end

  def apply_filters(records, permitted_params)
      filtering_params = params.slice(*permitted_params)
      filtering_params.each do |key, value|
        next if value.blank?
        
        if key.to_s == 'name'
          records = records.where("name ILIKE ?", "%#{value}%")
        else
          records = records.where(key => value)
        end
      end
      records
    end
end