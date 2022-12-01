class ProvinceSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :region

  def region
    object.region.name
  end
end
