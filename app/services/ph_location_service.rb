class PhLocationService
  attr_reader :url

  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end

  def fetch_region
    request = RestClient.get("#{url}/regions")
    data = JSON.parse(request.body)
    data.each do |region|
      address_region = Address::Region.find_or_initialize_by(code: region['code'])
      address_region.name = region['regionName']
      address_region.save
    end
  end

  def fetch_province
    request = RestClient.get("#{url}/provinces")
    provinces = JSON.parse(request.body)
    provinces.each do |province|
      region = Address::Region.find_by_code(province['regionCode'])
      Address::Province.find_or_create_by(code: province['code'], name: province['name'], region: region)
    end

    request = RestClient.get("#{url}/districts")
    districts = JSON.parse(request.body)
    districts.each do |district|
      region = Address::Region.find_by_code(district['regionCode'])
      Address::Province.find_or_create_by(code: district['code'], name: district['name'], region: region)
    end
  end
end